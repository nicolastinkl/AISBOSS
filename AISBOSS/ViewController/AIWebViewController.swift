//
//  AIWebViewController.swift
//  AI2020OS
//
//  Created by tinkl on 10/6/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

import UIKit
import Social
import WebKit

private let TitleKeyPath = "title"

private let EstimatedProgressKeyPath = "AIestimatedProgress"

public class AIWebViewController: UIViewController,UIWebViewDelegate {
    
    
    var currentUrl:NSURL?
    
    // MARK: Properties
    
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var progressBar: UIProgressView!

    @IBOutlet weak var titleLabel: UILabel!
    
    deinit {
        webView.removeObserver(self, forKeyPath: TitleKeyPath, context: nil)
        webView.removeObserver(self, forKeyPath: EstimatedProgressKeyPath, context: nil)
    }
    
    override public func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.progressBar.hidden = true

        progressBar.backgroundColor = .clearColor()
        progressBar.trackTintColor = .clearColor()
        
        webView.addObserver(self, forKeyPath: TitleKeyPath, options: .New, context: nil)
        webView.addObserver(self, forKeyPath: EstimatedProgressKeyPath, options: .New, context: nil)
//        webView.allowsBackForwardNavigationGestures = true
        
        if let url = currentUrl {
            self.webView.loadRequest(NSURLRequest(URL: url))
            self.titleLabel.text = url.URLString ?? ""
        }
    }    

    public func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        
    }
    
    public func webViewDidStartLoad(webView: UIWebView) {

    }
    
    public func webViewDidFinishLoad(webView: UIWebView) {
        
    }
    
    ///  :nodoc:
    public override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        webView.stopLoading()
    }
    
    // MARK: KVO
    /*
    ///  :nodoc:
    public override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if object as? NSObject == webView {
            switch keyPath {
            case TitleKeyPath:
                if displaysWebViewTitle {
                    title = self.webView.title
                }
                
            case EstimatedProgressKeyPath:
                let completed = self.webView.estimatedProgress == 1.0
                progressBar.setProgress(completed ? 0.0 : Float(webView.estimatedProgress), animated: !completed)
                //UIApplication.sharedApplication().networkActivityIndicatorVisible = !completed
                
            default: break
            }
        }
        else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    */

    
}