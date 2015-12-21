//
//  AIRemoteRequestQueue.swift
//  AIVeris
//
//  Created by tinkl on 18/12/2015.
//  Base on Tof Templates
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
 
// MARK: -
// MARK: AIRemoteRequestQueue
// Remote Muti Request By tinkl.
// MARK: -
internal class AIRemoteRequestQueue {
    
    // MARK: -> Internal variable
    
    private var m_strSuccNotificationName = ""
    private var m_strFailedNotificationName = ""
    
    private lazy var m_queueRemoteRequestOperation:dispatch_queue_t = {
        //串行队列
        let queue = dispatch_queue_create("AI.SBOSS.AsyncRequset", DISPATCH_QUEUE_SERIAL)
        return queue
    }()
    
    private lazy var m_arrRemoteRequestOperation:NSMutableArray = {
        return NSMutableArray()
    }()
    
    
    // MARK: -> Internal class
    
    func asyncRequset(subview:UIView,message:AIMessage,successRequst: (UIView) -> Void, fail: (errorView:UIView,error: String) -> Void){
        
        let md5 = "\(NSDate().timeIntervalSince1970)"
        m_strSuccNotificationName = "SUCCESS$\(md5)"
        m_strFailedNotificationName = "FAILED$\(md5)"

        Async.customQueue(after: 1, queue: self.m_queueRemoteRequestOperation) { () -> Void in
            // New Request
            
            AINetEngine.defaultEngine().postMessage(message, success: { (response ) -> Void in
                // parse here
                let messageView = subview as! AIWishMessageView
                let id = response["note_id"] as! NSNumber
                messageView.noteID = id.integerValue
                successRequst(messageView)
                }, fail: { (errorType : AINetError, errorStr:String!) -> Void in
                    fail(errorView: subview,error: errorStr)
            })
        }         
        
    }
    

}
