//
//  AITimeLineMainViewController.swift
//  AIVeris
//
//  Created by 王坜 on 15/11/9.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AITimeLineMainViewController: UIViewController {

    var topView :UIView!
    var scrollView : UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let bgImageView = UIImageView(image: UIImage(named: "Buyer_topBar_Bg"))
        bgImageView.frame = self.view.frame
        self.view.addSubview(bgImageView)
        
        self.makeTopView()
        self.makeScrollView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let image = UIImage(named: "TimeLine_Bottom")
        let size = AITools.imageDisplaySizeFrom1080DesignSize((image?.size)!) as CGSize
        let frame = CGRectMake(0, size.height - 10, CGRectGetWidth(scrollView.frame), 10)
        scrollView.scrollRectToVisible(frame, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func makeButtonWithFrame(frame:CGRect, action:Selector) -> UIButton {
        let button = UIButton(type: .Custom)
        button.frame = frame
        button.addTarget(self, action: action, forControlEvents: .TouchUpInside)
        self.view.addSubview(button)
        
        return button
    }
    
    func backAction () {
        AIOpeningView.instance().show()
    }
    
    
    func makeTopView () {
        
        let image = UIImage(named: "TimeLine_Top")
        let size = AITools.imageDisplaySizeFrom1080DesignSize((image?.size)!) as CGSize
        topView = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), size.height))
        self.view.addSubview(topView)
        
        let topImageView = UIImageView(image: image)
        topImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), size.height)
        topView.addSubview(topImageView)
        
        // add back action
        
        let backFrame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), size.height * 3 / 2)
        topView.addSubview(self.makeButtonWithFrame(backFrame, action: "backAction"))
        
    }
    
    func makeScrollView () {
        scrollView = UIScrollView(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)))
        self.view.insertSubview(scrollView, atIndex: 1)
        
        // make contentSize
        
        let image = UIImage(named: "TimeLine_Bottom")
        let size = AITools.imageDisplaySizeFrom1080DesignSize((image?.size)!) as CGSize
        let contentImageView = UIImageView(image: image)
        contentImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), size.height)
        scrollView.addSubview(contentImageView)
        scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), size.height)
        
    }


}
