//
//  AIGalleryView.swift
//  AIVeris
//
//  Created by tinkl on 19/11/2015.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit

/// 相册
internal class AIGalleryView : UIView,UIScrollViewDelegate {
     
    // MARK: -> Internal class methods
    
    var imageModelArray : [String]? {
        didSet {
            guard let imageArray = imageModelArray else { return }
            
            var pageViews: [UIView] = []
            var index:Int = 0
            for url in imageArray {

                let imageView = AIImageView()
                //imageView.image = UIImage(named: "Placehold")
                imageView.contentMode = .ScaleAspectFill
                imageView.setURL(NSURL(string: url), placeholderImage: UIImage(named: "Placehold"))
                imageView.clipsToBounds = true
                self.pageScrollView.addSubview(imageView)
                imageView.frame = pageScrollView.frame
                imageView.setX(CGFloat(index) * imageView.width)
                pageViews.append(imageView)
                index = index + 1
            }
            self.pageControl.numberOfPages = imageArray.count

        }
    }
    
    /**
     private lazy var imageView:AIImageView = {
     let imView = AIImageView()
     imView.image = UIImage(named: "Placehold")
     imView.contentMode = .ScaleAspectFill
     imView.clipsToBounds = true
     return imView
     }()
     */
    
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = self.imageModelArray?.count ?? 0
        pageControl.currentPage = 0
        pageControl.transform = CGAffineTransformMakeScale(0.8, 0.8)
        pageControl.tag = 12
        return pageControl
    }()
    
    private lazy var pageScrollView:UIScrollView = {
        // Setup the paging scroll view
        let pageScrollView = UIScrollView()
        pageScrollView.backgroundColor = UIColor.clearColor()
        pageScrollView.pagingEnabled = true
        pageScrollView.showsHorizontalScrollIndicator = false
        pageScrollView.showsVerticalScrollIndicator = false
        pageScrollView.tag = 12
        return pageScrollView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(pageScrollView)
        pageScrollView.frame = frame
        
        self.addSubview(pageControl)
        let point = CGPointMake((self.width - pageControl.width)/2, self.height - 10)
        pageControl.setX(point.x)
        pageControl.setY(point.y)
        pageScrollView.delegate = self
        
        guard let superScroll = scrollView() else { return }

        let ges = self.pageScrollView.gestureRecognizers?.last!
        if let g =  superScroll.gestureRecognizers?.last {
            g.requireGestureRecognizerToFail(ges!)
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
        pageControl.currentPage = Int(index)
    }
    
    
    // MARK: -
    // MARK: Methods (Public)
    
    private func scrollView() -> UIScrollView? {
        return superview as? UIScrollView
    }
}