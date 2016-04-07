//
//  AIImageView.swift
//  AI2020OS
//
//  Created by tinkl on 7/4/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import Spring

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
            
            self.sd_setImageWithURL(url) { [weak self]  (imgContent, ErrorType, CacheType, CacheURL) -> Void in
                if let strongSelf = self {
                    if strongSelf.url == CacheURL {
                        strongSelf.alpha=0.2;
                        strongSelf.image = imgContent
                        UIView.beginAnimations(nil, context: nil)
                        UIView.setAnimationDuration(0.5)
                        strongSelf.setNeedsDisplay()
                        strongSelf.alpha = 1;
                        UIView.commitAnimations()
                        
                    }
                }
            }
            
            /*
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
            }*/
        }
    }
    
    public func setURL(url: NSURL?, placeholderImage: UIImage?) {
        self.placeholderImage = placeholderImage
        if url?.URLString.length > 10 {
            self.url = url
        }         
    }
    
}


