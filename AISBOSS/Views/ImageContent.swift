//
//  ImageContent.swift
//  AIVeris
//
//  Created by Rocky on 15/10/22.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import AISpring

class ImageContent: UIView {
    
    private var imageUrl: String?
    private var imageView: UIImageView!
    private let LEFT_MARGIN: CGFloat = 20 / 3
    private let RIGHT_MARGIN: CGFloat = 20 / 3
    private let BOTTOM_MARGIN: CGFloat = 26 / 3

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSelf()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSelf()
    }
    
    private func initSelf() {
        imageView = UIImageView(frame: CGRect(x: LEFT_MARGIN, y: 0, width: bounds.width - LEFT_MARGIN - RIGHT_MARGIN, height: bounds.height - BOTTOM_MARGIN))
        imageView.contentMode = .ScaleAspectFill
        addSubview(imageView)
    }
    
    var imgUrl: String? {
        get {
            return imageUrl
        }
        
        set {
            if let url = newValue {
                ImageLoader.sharedLoader.imageForUrl(url) { (image, url) -> () in
                    if let img = image {
                        self.imageView?.image = img
                    }
                }
            }
            
            imageUrl = imgUrl
        }
    }

}
