//
//  AIImageView.swift
//  AI2020OS
//
//  Created by tinkl on 7/4/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import AISpring

/*!
*  @author tinkl, 15-04-07 15:04:21
*
*  Loading image from url
*/
public class AIImageView: UIImageView {
    
    private struct AssociatedKeys {
        static var AIAssemblyIDKey = "AIAssemblyIDKey_UIImageView"
    }

    public var assemblyID: String? {
        set{
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.AIAssemblyIDKey, newValue  as NSString?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            
        }
        get{
            return objc_getAssociatedObject(self, &AssociatedKeys.AIAssemblyIDKey) as? String
        }
    }

    
    public var placeholderImage : UIImage?
    
    public var url : NSURL? {
        didSet {
            self.image = placeholderImage
            
            if let urlString = url?.absoluteString {
                ImageLoader.sharedLoader.imageForUrl(urlString) { [weak self] image, url in
                    if let strongSelf = self {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            if strongSelf.url?.absoluteString == url {
                                strongSelf.alpha=0.2;
                                strongSelf.image = image
                                UIView.beginAnimations(nil, context: nil)
                                UIView.setAnimationDuration(0.5)
                                strongSelf.setNeedsDisplay()
                                strongSelf.alpha = 1;
                                UIView.commitAnimations()
                                //strongSelf.setNeedsDisplay()
                                
                            }
                        })
                    }
                }
            }
        }
    }
    
    public func setURL(url: NSURL?, placeholderImage: UIImage?) {
        self.placeholderImage = placeholderImage
        
        self.url = url
        
        
    }
    
}

extension UIImageView{
    
    typealias DowloadHandler = ()->()
    func sd_setImageWithURL(url:NSURL?,placeholderImage: UIImage?,completion: DowloadHandler?)->UIImageView{
        
        self.image = placeholderImage
        
        if let urlString = url?.absoluteString {
            ImageLoader.sharedLoader.imageForUrl(urlString) { [weak self] image, url in
                if let strongSelf = self {
                    dispatch_async(dispatch_get_main_queue(), {
                        strongSelf.alpha=0.2;
                        strongSelf.image = image
                        UIView.beginAnimations(nil, context: nil)
                        UIView.setAnimationDuration(0.5)
                        strongSelf.setNeedsDisplay()
                        strongSelf.alpha = 1;
                        UIView.commitAnimations()
                        completion?()
                    })
                }
            }
        }                
        return self
    }
}

