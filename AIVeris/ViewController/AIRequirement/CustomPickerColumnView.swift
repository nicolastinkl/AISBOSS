

import UIKit

protocol CustomPickerColumnViewDelegate: NSObjectProtocol {
	func customPickerView(customPickerView: CustomPickerColumnView, didSelectRow row: Int)
}

class CustomPickerColumnView: UIView {
	var row: Int {
		let height = CGRectGetHeight(bounds) / 3
		return Int(scrollView.contentOffset.y / height) + 1
	}
	override init(frame: CGRect) {
		super.init(frame: frame)
		clipsToBounds = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	struct Constants {
		static let taskBallsize: CGFloat = 44
		static let blueBallSize: CGFloat = 118 / 3
		static let blueColor = UIColor(red: 0.1294, green: 0.6078, blue: 1.0, alpha: 1.0)
		static let grayColor = UIColor(red: 0.2314, green: 0.2196, blue: 0.4902, alpha: 1.0)
	}
	
	weak var delegate: CustomPickerColumnViewDelegate?
	
	lazy var scrollView: UIScrollView = { [unowned self] in
		let result = UIScrollView()
		result.showsVerticalScrollIndicator = false
		result.alwaysBounceVertical = true
		result.clipsToBounds = false
		result.pagingEnabled = true
		result.frame = self.bounds
		result.delegate = self
		self.addSubview(result)
		return result
	}()
	
	lazy var verticalLineView: UIImageView = {
		[unowned self] in
		let result = UIImageView(image: UIImage(named: "datePickerLine"))
		self.scrollView.addSubview(result)
		return result
	}()
	
	lazy var views: [UIView] = {
		[unowned self] in
		var result = [UIView]()
		for i in 0 ... 2 {
			
			let view = UIView()
			self.scrollView.addSubview(view)
			view.tag = i
			
			if i == 1 {
				let size = Constants.taskBallsize
				let imageView = UIImageView(image: UIImage(named: "taskIconSmall"))
				view.frame = CGRect(x: 0, y: 0, width: size, height: size)
				imageView.frame = view.bounds
				view.addSubview(imageView)
				let animation: CAAnimationGroup = {
					let scale = CABasicAnimation(keyPath: "transform.scale")
					scale.fromValue = 0.4 as NSNumber
					scale.toValue = 1 as NSNumber
					
					let group = CAAnimationGroup()
					group.animations = [scale]
					return group
				}()
				view.layer.addAnimation(animation, forKey: nil)
			} else {
				let size = Constants.blueBallSize
				let blueColor = Constants.blueColor
				let grayColor = Constants.grayColor
				view.frame = CGRect(x: 0, y: 0, width: size, height: size)
				view.backgroundColor = blueColor
				let animation: CAAnimationGroup = {
					let scale = CABasicAnimation(keyPath: "transform.scale")
					scale.fromValue = 0.25 as NSNumber
					scale.toValue = 1 as NSNumber
					
					
					let color = CAKeyframeAnimation(keyPath: "backgroundColor")
					color.values = [
						grayColor.CGColor,
						blueColor.CGColor
					]
					
					let group = CAAnimationGroup()
					group.animations = [color, scale]
					return group
				}()
				view.layer.addAnimation(animation, forKey: nil)
			}
			
			view.layer.speed = 0
			view.layer.cornerRadius = view.frame.size.height / 2
			
			result.append(view)
		}
		
		return result
	}()
	
	override func layoutSubviews() {
		super.layoutSubviews()
		let height = CGRectGetHeight(bounds) / 3
		let width = CGRectGetWidth(bounds)
		var frame = bounds
		frame.origin.y = height
		frame.size.height = height
		scrollView.frame = frame
		scrollView.contentSize = scrollView.bounds.size
		scrollView.contentInset = UIEdgeInsets(top: height, left: 0, bottom: height, right: 0)
		for view in views {
			let i = view.tag
			view.center = CGPoint(x: width / 2, y: height / 2 + CGFloat(i - 1) * height)
		}
		
		var center = scrollView.center
		center.y -= height
		verticalLineView.center = center
		scrollView.sendSubviewToBack(verticalLineView)
		
		scrollView.setContentOffset(CGPoint(x: 0, y: 1), animated: true) // tricky call scrollViewDidScroll
	}
	
	override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
		if super.hitTest(point, withEvent: event) == self {
			return scrollView
		} else {
			return super.hitTest(point, withEvent: event)
		}
	}
}

extension CustomPickerColumnView: UIScrollViewDelegate {
	func scrollViewDidScroll(scrollView: UIScrollView) {
		let height = CGRectGetHeight(bounds) / 3
		let contentCenterOffsetY = scrollView.contentOffset.y + height / 2
		for view in views {
			let layer = view.layer
			let spaceBetweenViewAndCenter = fabs(contentCenterOffsetY - view.center.y)
			let timeOffset = min(1, max(0, CGFloat(1) - spaceBetweenViewAndCenter * 2 / height))
			layer.timeOffset = Double(timeOffset)
			if view.tag == 0 {
				print(timeOffset)
			}
		}
	}
	
	func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
		let height = CGRectGetHeight(bounds) / 3
		let row = Int(scrollView.contentOffset.y / height) + 1
		if let delegate = delegate {
			delegate.customPickerView(self, didSelectRow: row)
		}
	}
}
