//
//  UIViewController+AIPopup.swift
//  DimPresentViewController
//
//  Created by admin on 3/8/16.
//  Copyright © 2016 __ASIAINFO__. All rights reserved.
//

import UIKit
import Accelerate
import Cartography

class ClosureWrapper {
    var closure: (() -> Void)?
    
    init(_ closure: (() -> Void)?) {
        self.closure = closure
    }
}

// example:

// let vc = SamplePopupViewController()
// presentPopupViewController(vc, animated: true)

// In SamplePopupViewController.swift
// call self.parentViewController?.dismissPopupViewController(true, completion: nil) some where

extension UIViewController {
	private struct AssociatedKeys {
		static var popupViewController = "popupViewController"
		static var useBlurForPopup = "useBlurForPopup"
		static var popupViewOffset = "popupViewOffset"
		static var blurViewKey = "blurViewKey"
		static var bottomConstraintKey = "bottomConstraintKey"
        static var onClickCancelArea = "onClickCancelArea"
	}
	private struct Constants {
		static let animationTime: Double = 0.25
		static let statusBarSize: CGFloat = 22
	}
	
	
	// MARK: - public
	var popupViewController: UIViewController? {
		
		set {
			objc_setAssociatedObject(self, &AssociatedKeys.popupViewController, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
		
		get {
			return objc_getAssociatedObject(self, &AssociatedKeys.popupViewController) as? UIViewController
		}
	}
	
	var useBlurForPopup: Bool? {
		set {
			objc_setAssociatedObject(self, &AssociatedKeys.useBlurForPopup, newValue, .OBJC_ASSOCIATION_ASSIGN)
		}
		
		get {
			return objc_getAssociatedObject(self, &AssociatedKeys.useBlurForPopup) as? Bool
		}
	}
	
	var popupViewOffset: CGPoint? {
		set {
			objc_setAssociatedObject(self, &AssociatedKeys.popupViewOffset, NSValue(CGPoint: newValue!), .OBJC_ASSOCIATION_ASSIGN)
		}
		
		get {
			return (objc_getAssociatedObject(self, &AssociatedKeys.popupViewOffset) as? NSValue)?.CGPointValue()
		}
	}
	
	var bottomConstraint: NSLayoutConstraint? {
		set {
			objc_setAssociatedObject(self, &AssociatedKeys.bottomConstraintKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
		
		get {
			return objc_getAssociatedObject(self, &AssociatedKeys.bottomConstraintKey) as? NSLayoutConstraint
		}
	}
    
    var onClickCancelArea: (()->Void)? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.onClickCancelArea, ClosureWrapper(newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.onClickCancelArea) as? ClosureWrapper)?.closure
        }
    }
	
    /**
     模糊化present viewcontroller
     
     - parameter viewControllerToPresent: viewControllerToPresent
     - parameter duration:                控制动画时间可空，默认0.25秒
     - parameter animated:                是否动画
     - parameter completion:              completion handler 可空
     - parameter onClickCancelArea:       模糊区域点击 handler 可空
     */
    func presentPopupViewController(viewControllerToPresent: UIViewController, duration:Double = Constants.animationTime, animated: Bool, completion: (() -> Void)? = nil, onClickCancelArea: (()->Void)? = nil) {
		if popupViewController == nil {
            self.onClickCancelArea = onClickCancelArea
			popupViewController = viewControllerToPresent
			popupViewController!.view.autoresizesSubviews = false
			popupViewController!.view.autoresizingMask = .None
			addChildViewController(viewControllerToPresent)
			
			// parallax setup
			let interpolationHorizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
			interpolationHorizontal.minimumRelativeValue = -10
			interpolationHorizontal.maximumRelativeValue = 10
			
			let interpolationVertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
			interpolationHorizontal.minimumRelativeValue = -10
			interpolationHorizontal.maximumRelativeValue = 10
			
			popupViewController!.view.addMotionEffect(interpolationHorizontal)
			popupViewController!.view.addMotionEffect(interpolationVertical)
			
			// shadow setup
			viewControllerToPresent.view.layer.shadowOffset = .zero
			viewControllerToPresent.view.layer.shadowColor = UIColor.blackColor().CGColor
			viewControllerToPresent.view.layer.shadowPath = UIBezierPath(rect: viewControllerToPresent.view.layer.bounds).CGPath
			viewControllerToPresent.view.layer.cornerRadius = 5
			
			// blurView
			addBlurView()
			
			let blurView = objc_getAssociatedObject(self, &AssociatedKeys.blurViewKey) as! UIView
			viewControllerToPresent.beginAppearanceTransition(true, animated: animated)
			
			let setupInitialConstraints = {
				
                constrain(self.view, viewControllerToPresent.view, block: { (superView, subview) -> () in
                    subview.left == superView.left
                    subview.right == superView.right
                    subview.height == viewControllerToPresent.view.frame.size.height
                    self.bottomConstraint = subview.bottom == superView.bottom + viewControllerToPresent.view.frame.size.height
                })
				
				self.view.layoutIfNeeded()
			}
			if animated {
				
				var initialAlpha: CGFloat = 1
				let finalAlpha: CGFloat = 1
				
				if modalTransitionStyle == .CrossDissolve {
					initialAlpha = 0
				}
				
				viewControllerToPresent.view.alpha = initialAlpha
				
				view.addSubview(viewControllerToPresent.view)
				// setup initial constraints
				
				setupInitialConstraints()
				
				UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
					self.bottomConstraint?.constant = 0
					viewControllerToPresent.view.alpha = finalAlpha
					blurView.alpha = self.useBlurForPopup == true ? 1 : 0.4
					
					self.view.layoutIfNeeded()
					}, completion: { (success) -> Void in
					self.popupViewController?.didMoveToParentViewController(self)
					self.popupViewController?.endAppearanceTransition()
					if let completion = completion {
						completion()
					}
				})
			} else { // don't animate
				view.addSubview(viewControllerToPresent.view)
				
				setupInitialConstraints()
				
				popupViewController?.didMoveToParentViewController(self)
				popupViewController?.endAppearanceTransition()
				if let completion = completion {
					completion()
				}
			}
			
			NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillChangeFrame:", name: UIKeyboardWillChangeFrameNotification, object: nil)
		}
	}
	
    /**
     dismiss 方法
     
     - parameter animated:      是否动画
     - parameter duration:      控制动画时间可空，默认0.25秒
     - parameter completion:    completion handler
     */
	func dismissPopupViewController(animated: Bool, duration:Double = Constants.animationTime, completion: (() -> Void)?) {
        
        if popupViewController == nil {
            parentViewController?.dismissPopupViewController(animated, completion: completion)
            return
        }
        
		let blurView = objc_getAssociatedObject(self, &AssociatedKeys.blurViewKey) as! UIView
		popupViewController?.willMoveToParentViewController(nil)
		popupViewController?.beginAppearanceTransition(false, animated: animated)
		if animated {
			var finalAlpha: CGFloat = 1
			if modalTransitionStyle == .CrossDissolve {
				finalAlpha = 0
			}
			
			view.layoutIfNeeded()
			UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
				self.bottomConstraint?.constant = self.view.frame.size.height
				self.popupViewController!.view.alpha = finalAlpha
				blurView.alpha = 0
				self.view.layoutIfNeeded()
				}, completion: { (success) -> Void in
				self.popupViewController?.removeFromParentViewController()
				self.popupViewController?.endAppearanceTransition()
				self.popupViewController!.view.removeFromSuperview()
				blurView.removeFromSuperview()
				self.popupViewController = nil
				if let completion = completion {
					completion()
				}
			})
		}
		
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillChangeFrameNotification, object: nil)
	}
	
	// MARK: - private
	
	func keyboardWillChangeFrame(notification: NSNotification) {
		var userInfo = notification.userInfo!
		
		let frameEnd = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue
		let convertedFrameEnd = self.view.convertRect(frameEnd, fromView: nil)
		let heightOffset = self.view.bounds.size.height - convertedFrameEnd.origin.y
		bottomConstraint!.constant = -heightOffset
		
		let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey]!.unsignedIntValue
		let options = UIViewAnimationOptions(rawValue: UInt(curve) << 16)
		
		UIView.animateWithDuration(
			userInfo[UIKeyboardAnimationDurationUserInfoKey]!.doubleValue,
			delay: 0,
			options: options,
			animations: {
				self.view.layoutIfNeeded()
			},
			completion: nil
		)
	}
	
	func addBlurView() {
		let fadeView = UIImageView()
		fadeView.frame = UIScreen.mainScreen().bounds
		
		if useBlurForPopup == true {
			fadeView.image = getBlurredImage(getScreenImage())
		} else {
			fadeView.backgroundColor = UIColor.blackColor()
		}
		fadeView.alpha = 0
		fadeView.userInteractionEnabled = true
		view.addSubview(fadeView)
		objc_setAssociatedObject(self, &AssociatedKeys.blurViewKey, fadeView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		
		let tap = UITapGestureRecognizer(target: self, action: "blurViewDidTapped")
		fadeView.addGestureRecognizer(tap)
	}
	
	func blurViewDidTapped() {
        view.endEditing(true)
//        if let onClickCancelArea = onClickCancelArea {
//            onClickCancelArea()
//        }
		dismissPopupViewController(true, completion: onClickCancelArea)
	}
	
	func getBlurredImage(imageToBlur: UIImage) -> UIImage {
		return imageToBlur.applyBlurWithRadius(10.0, tintColor: UIColor.clearColor(), saturationDeltaFactor: 1.0, maskImage: nil)!
	}
	
	func getScreenImage() -> UIImage {
		var frame: CGRect?
		frame = UIScreen.mainScreen().bounds
		
		UIGraphicsBeginImageContext((frame?.size)!)
		
		let currentContext = UIGraphicsGetCurrentContext()
		
		view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
		
		CGContextClipToRect(currentContext, frame!)
		
		let screenshot = UIGraphicsGetImageFromCurrentImageContext()
		
		UIGraphicsEndImageContext()
		return screenshot
	}
}

public extension UIImage {
	public func applyLightEffect() -> UIImage? {
		return applyBlurWithRadius(30, tintColor: UIColor(white: 1.0, alpha: 0.3), saturationDeltaFactor: 1.8)
	}
	
	public func applyExtraLightEffect() -> UIImage? {
		return applyBlurWithRadius(20, tintColor: UIColor(white: 0.97, alpha: 0.82), saturationDeltaFactor: 1.8)
	}
	
	public func applyDarkEffect() -> UIImage? {
		return applyBlurWithRadius(20, tintColor: UIColor(white: 0.11, alpha: 0.73), saturationDeltaFactor: 1.8)
	}
	
	public func applyTintEffectWithColor(tintColor: UIColor) -> UIImage? {
		let effectColorAlpha: CGFloat = 0.6
		var effectColor = tintColor
		
		let componentCount = CGColorGetNumberOfComponents(tintColor.CGColor)
		
		if componentCount == 2 {
			var b: CGFloat = 0
			if tintColor.getWhite(&b, alpha: nil) {
				effectColor = UIColor(white: b, alpha: effectColorAlpha)
			}
		} else {
			var red: CGFloat = 0
			var green: CGFloat = 0
			var blue: CGFloat = 0
			
			if tintColor.getRed(&red, green: &green, blue: &blue, alpha: nil) {
				effectColor = UIColor(red: red, green: green, blue: blue, alpha: effectColorAlpha)
			}
		}
		
		return applyBlurWithRadius(10, tintColor: effectColor, saturationDeltaFactor: -1.0, maskImage: nil)
	}
	
	public func applyBlurWithRadius(blurRadius: CGFloat, tintColor: UIColor?, saturationDeltaFactor: CGFloat, maskImage: UIImage? = nil) -> UIImage? {
		// Check pre-conditions.
		if (size.width < 1 || size.height < 1) {
			print("*** error: invalid size: \(size.width) x \(size.height). Both dimensions must be >= 1: \(self)")
			return nil
		}
		if self.CGImage == nil {
			print("*** error: image must be backed by a CGImage: \(self)")
			return nil
		}
		if maskImage != nil && maskImage!.CGImage == nil {
			print("*** error: maskImage must be backed by a CGImage: \(maskImage)")
			return nil
		}
		
		let __FLT_EPSILON__ = CGFloat(FLT_EPSILON)
		let screenScale = UIScreen.mainScreen().scale
		let imageRect = CGRect(origin: CGPointZero, size: size)
		var effectImage = self
		
		let hasBlur = blurRadius > __FLT_EPSILON__
		let hasSaturationChange = fabs(saturationDeltaFactor - 1.0) > __FLT_EPSILON__
		
		if hasBlur || hasSaturationChange {
			func createEffectBuffer(context: CGContext) -> vImage_Buffer {
				let data = CGBitmapContextGetData(context)
				let width = vImagePixelCount(CGBitmapContextGetWidth(context))
				let height = vImagePixelCount(CGBitmapContextGetHeight(context))
				let rowBytes = CGBitmapContextGetBytesPerRow(context)
				
				return vImage_Buffer(data: data, height: height, width: width, rowBytes: rowBytes)
			}
			
			UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
			let effectInContext = UIGraphicsGetCurrentContext()
			
			CGContextScaleCTM(effectInContext, 1.0, -1.0)
			CGContextTranslateCTM(effectInContext, 0, -size.height)
			CGContextDrawImage(effectInContext, imageRect, self.CGImage)
			
			var effectInBuffer = createEffectBuffer(effectInContext!)
			
			UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
			let effectOutContext = UIGraphicsGetCurrentContext()
			
			var effectOutBuffer = createEffectBuffer(effectOutContext!)
			
			if hasBlur {
				// A description of how to compute the box kernel width from the Gaussian
				// radius (aka standard deviation) appears in the SVG spec:
				// http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
				//
				// For larger values of 's' (s >= 2.0), an approximation can be used: Three
				// successive box-blurs build a piece-wise quadratic convolution kernel, which
				// approximates the Gaussian kernel to within roughly 3%.
				//
				// let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
				//
				// ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
				//
				
				let inputRadius = blurRadius * screenScale
				var radius = UInt32(floor(inputRadius * 3.0 * CGFloat(sqrt(2 * M_PI)) / 4 + 0.5))
				if radius % 2 != 1 {
					radius += 1 // force radius to be odd so that the three box-blur methodology works.
				}
				
				let imageEdgeExtendFlags = vImage_Flags(kvImageEdgeExtend)
				
				vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
				vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
				vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
			}
			
			var effectImageBuffersAreSwapped = false
			
			if hasSaturationChange {
				let s: CGFloat = saturationDeltaFactor
				let floatingPointSaturationMatrix: [CGFloat] = [
					0.0722 + 0.9278 * s, 0.0722 - 0.0722 * s, 0.0722 - 0.0722 * s, 0,
					0.7152 - 0.7152 * s, 0.7152 + 0.2848 * s, 0.7152 - 0.7152 * s, 0,
					0.2126 - 0.2126 * s, 0.2126 - 0.2126 * s, 0.2126 + 0.7873 * s, 0,
					0, 0, 0, 1
				]
				
				let divisor: CGFloat = 256
				let matrixSize = floatingPointSaturationMatrix.count
				var saturationMatrix = [Int16](count: matrixSize, repeatedValue: 0)
				
				for var i: Int = 0; i < matrixSize; ++i {
					saturationMatrix[i] = Int16(round(floatingPointSaturationMatrix[i] * divisor))
				}
				
				if hasBlur {
					vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
					effectImageBuffersAreSwapped = true
				} else {
					vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
				}
			}
			
			if !effectImageBuffersAreSwapped {
				effectImage = UIGraphicsGetImageFromCurrentImageContext()
			}
			
			UIGraphicsEndImageContext()
			
			if effectImageBuffersAreSwapped {
				effectImage = UIGraphicsGetImageFromCurrentImageContext()
			}
			
			UIGraphicsEndImageContext()
		}
		
		// Set up output context.
		UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
		let outputContext = UIGraphicsGetCurrentContext()
		CGContextScaleCTM(outputContext, 1.0, -1.0)
		CGContextTranslateCTM(outputContext, 0, -size.height)
		
		// Draw base image.
		CGContextDrawImage(outputContext, imageRect, self.CGImage)
		
		// Draw effect image.
		if hasBlur {
			CGContextSaveGState(outputContext)
			if let image = maskImage {
				CGContextClipToMask(outputContext, imageRect, image.CGImage);
			}
			CGContextDrawImage(outputContext, imageRect, effectImage.CGImage)
			CGContextRestoreGState(outputContext)
		}
		
		// Add in color tint.
		if let color = tintColor {
			CGContextSaveGState(outputContext)
			CGContextSetFillColorWithColor(outputContext, color.CGColor)
			CGContextFillRect(outputContext, imageRect)
			CGContextRestoreGState(outputContext)
		}
		
		// Output image is ready.
		let outputImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return outputImage
	}
}