//
//  ProposalService.swift
//  AIVeris
//
//  Created by Rocky on 15/10/23.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation

import AISwiftyJSON

protocol ProposalService {
    //获取通过proposal订购的订单实例列表
    func getProposalList(success: (responseData: ProposalOrderListModel) -> Void, fail: (errType: AINetError, errDes: String) -> Void)
    //获取proposal气泡列表
    func getPoposalBubbles(success: (responseData: AIProposalPopListModel) -> Void, fail: (errType: AINetError, errDes: String) -> Void)
    //获取proposal详情
    func queryCustomerProposalDetail(proposalId : Int,success : (responseData : AIProposalInstModel) -> Void, fail: (errType: AINetError, errDes: String) -> Void)
}

class MockProposalService : ProposalService{
    func getProposalList(success: (responseData: ProposalOrderListModel) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        if let path = NSBundle.mainBundle().pathForResource("customerOrderList", ofType: "json") {
            let data: NSData? = NSData(contentsOfFile: path)
            if let dataJSON = data {
                do {
                    let model = try ProposalOrderListModel(data: dataJSON)
                    success(responseData: model)

                } catch {
                    print("ProposalListModel JSON Parse err.")
                    fail(errType: AINetError.Format, errDes: "AIOrderPreListModel JSON Parse error.")
                }
            }
        }
    }
    
    func getPoposalBubbles(success: (responseData: AIProposalPopListModel) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        if let path = NSBundle.mainBundle().pathForResource("customerProposalList", ofType: "json") {
            let data: NSData? = NSData(contentsOfFile: path)
            
            // AIProposalPopListModel
            
            do {
                let model = try AIProposalPopListModel(data: data)
                success(responseData: model)
            } catch {
                fail(errType: AINetError.Format, errDes: "ProposalListModel JSON Parse error.")
            }
            
        }
    }
    
    func queryCustomerProposalDetail(proposalId : Int,success : (responseData : AIProposalInstModel) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        if let path = NSBundle.mainBundle().pathForResource("BusinessTravel", ofType: "json") {
            let data: NSData? = NSData(contentsOfFile: path)
            
            // AIProposalPopListModel
            
            do {
                let model = try AIProposalInstModel(data: data)
                success(responseData: model)
            } catch {
                fail(errType: AINetError.Format, errDes: "AIProposalInstModel JSON Parse error.")
            }
            
        }
    }
}

class BDKProposalService : MockProposalService{
    
    func updateParamSettingState(customerId customerId: Int, serviceId: Int, proposalId: Int, roleId: Int, flag: Bool, success: () -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        
        let message = AIMessage()
        message.url = AIApplication.AIApplicationServerURL.updateParamSettingState.description
        let flagNum = flag ? 1 : 0
        let body = ["data": ["customer_id": customerId, "service_id": serviceId, "proposal_id": proposalId, "role_id": roleId, "flag": flagNum], "desc": ["data_mode": "0", "digest": ""]]
        
        message.body = NSMutableDictionary(dictionary: body)
        AINetEngine.defaultEngine().postMessage(message, success: {(response) -> Void in
            do {
                success()
                
            } catch {
                fail(errType: AINetError.Format, errDes: "AIProposalServiceDetailModel JSON Parse error.")
            }
            
            }) {(error: AINetError, errorDes: String!) -> Void in
                fail(errType: error, errDes: errorDes ?? "")
        }
    }
    
    //服务方案删除服务分类
    //BDK还没做
    
    func delServiceCategory(serviceId : Int, proposalId: Int, success: () -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
//        catalog_id
//        scheme_id
        let message = AIMessage()
        message.url = AIApplication.AIApplicationServerURL.delServiceCategory.description
        
        let body = ["data":["scheme_id": serviceId, "catalog_id": proposalId, "service_type":0],"desc":["data_mode":"0","digest":""]]
        //     let body = ["data":["service_id": 900001001000, "proposal_id": 2043, "service_type":0],"desc":["data_mode":"0","digest":""]]
        
        //     let header = ["HttpQuery":"0&0&0&0"]
        
        message.body = NSMutableDictionary(dictionary: body)
        //      message.header = NSMutableDictionary(dictionary: header)
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            do {
//                let dic = response as! [NSObject : AnyObject]
//                let model = try AIProposalServiceDetailModel(dictionary: dic)
                
//                success(responseData: model)
                
            } catch {
                fail(errType: AINetError.Format, errDes: "AIProposalServiceDetailModel JSON Parse error.")
            }
            
            }) { (error: AINetError, errorDes: String!) -> Void in
                fail(errType: error, errDes: errorDes ?? "")
        }
    }
    
    
    /**
    气泡数据
    
    - parameter success: <#success description#>
    - parameter fail:    <#fail description#>
    - parameter errDes:  <#errDes description#>
    */
    
    override func getPoposalBubbles(success: (responseData: AIProposalPopListModel) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        
        let message = AIMessage()
        let url = AIApplication.AIApplicationServerURL.queryCustomerProposalList.description
        message.url = url
        
        let user : String = NSUserDefaults.standardUserDefaults().objectForKey(kDefault_UserID) as! String
        let body = ["data":["user_id":user, "role_type": "1", "status":1],"desc":["data_mode":"0","digest":""]]
        message.body = NSMutableDictionary(dictionary: body)
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            
            do {
                let dic = response as! [NSObject : AnyObject]
                let model = try AIProposalPopListModel(dictionary: dic)
                success(responseData: model)
            } catch {
                fail(errType: AINetError.Format, errDes: "ProposalListModel JSON Parse error.")
            }
            
            }) { (error: AINetError, errorDes: String!) -> Void in
                fail(errType: error, errDes: errorDes)
        }
    }
    
    /**
    列表数据
    
    - parameter success: <#success description#>
    - parameter fail:    <#fail description#>
    - parameter errDes:  <#errDes description#>
    */
    override func getProposalList(success: (responseData: ProposalOrderListModel) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        let message = AIMessage()
        message.url = "http://171.221.254.231:3000/queryCustomerOrderListFake"
        
        let body = ["data":["order_role":1, "order_state": "0"],"desc":["data_mode":"0","digest":""]]
        message.body = NSMutableDictionary(dictionary: body)
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            
            do {
                let dic = response as! [NSObject : AnyObject]
                let model = try ProposalOrderListModel(dictionary: dic)
                success(responseData: model)
            } catch {
                fail(errType: AINetError.Format, errDes: "ProposalListModel JSON Parse error.")
            }
            
            }) { (error: AINetError, errorDes: String!) -> Void in
                fail(errType: error, errDes: errorDes)
        }

    }
    
    /**
    proposal详情数据
    
    - parameter success: <#success description#>
    - parameter fail:    <#fail description#>
    - parameter errDes:  <#errDes description#>
    */
    override func queryCustomerProposalDetail(proposalId : Int,success : (responseData : AIProposalInstModel) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        let message = AIMessage()
        
        message.url = AIApplication.AIApplicationServerURL.findCustomerProposalDetail.description
        
        let body = ["data":["proposal_id": proposalId],"desc":["data_mode":"0","digest":""]]
        message.body = NSMutableDictionary(dictionary: body)
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            
            do {
                let dic = response as! [NSObject : AnyObject]
                let model = try AIProposalInstModel(dictionary: dic)
                success(responseData: model)
            } catch {
                fail(errType: AINetError.Format, errDes: "AIProposalInstModel JSON Parse error.")
            }
            
            }) { (error: AINetError, errorDes: String!) -> Void in
                fail(errType: error, errDes: errorDes)
        }
        
    }
    
    
    
    /**
     Service Detail详情数据
     
     - parameter success: <#success description#>
     - parameter fail:    <#fail description#>
     - parameter errDes:  <#errDes description#>
     */
    func findServiceDetail(serviceId : Int, proposalId: Int, success : (responseData : AIProposalServiceDetailModel) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        let message = AIMessage()
        message.url = "http://171.221.254.231:3000/findServiceDetail"
        
        let body = ["data":["service_id": serviceId, "proposal_id": proposalId, "service_type":0],"desc":["data_mode":"0","digest":""]]
   //     let body = ["data":["service_id": 900001001000, "proposal_id": 2043, "service_type":0],"desc":["data_mode":"0","digest":""]]
        
   //     let header = ["HttpQuery":"0&0&0&0"]
        
        message.body = NSMutableDictionary(dictionary: body)
  //      message.header = NSMutableDictionary(dictionary: header)
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in            
            do {
                let dic = response as! [NSObject : AnyObject]
                let model = try AIProposalServiceDetailModel(dictionary: dic)
                
                success(responseData: model)
            
            } catch {
                fail(errType: AINetError.Format, errDes: "AIProposalServiceDetailModel JSON Parse error.")
            }
            
            }) { (error: AINetError, errorDes: String!) -> Void in
                fail(errType: error, errDes: errorDes ?? "")
        }
        
    }
}


