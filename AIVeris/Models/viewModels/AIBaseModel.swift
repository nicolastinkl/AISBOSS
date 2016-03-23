//
//  AIBaseModel.swift
//  AIVeris
//
//  Created by 刘先 on 16/3/11.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AIBaseViewModel : NSObject {
 
    class func printModelContent(obj : AnyObject) -> String{
        var outString = ""
        var outCount : UInt32 = 0
        let propertyList : UnsafeMutablePointer<objc_property_t>! = class_copyPropertyList(obj.classForCoder, &outCount)
        let count = Int(outCount)
        for i in 0...(count - 1){
            let aPro: objc_property_t = propertyList[i]
            let proName:String! = String(UTF8String: property_getName(aPro))
            outString += "\(proName) : \(String(obj.valueForKey(proName)!)) \r\n"
        }
        return outString
    }
    
    class func printArrayModelContent(array : Array<AnyObject>) -> String{
        var outString = ""
        for (index,item) in array.enumerate(){
            outString += "\(index) :"
            
            var outCount : UInt32 = 0
            let propertyList : UnsafeMutablePointer<objc_property_t>! = class_copyPropertyList(item.classForCoder, &outCount)
            let count = Int(outCount)
            for i in 0...(count - 1){
                let aPro: objc_property_t = propertyList[i]
                let proName:String! = String(UTF8String: property_getName(aPro))
                outString += "\(proName) : \(String(item.valueForKey(proName)!)) \r\n"
            }
            outString += "\r\n"
        }
        return outString
    }
}