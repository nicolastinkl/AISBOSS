//
//  BuildInCameraUtils.swift
//  AIVeris
//
//  Created by Rocky on 16/5/11.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation
import MobileCoreServices

class BuildInCameraUtils {
    class func startCameraControllerFromViewController<T where T: UIImagePickerControllerDelegate, T:UINavigationControllerDelegate>(viewController: UIViewController, delegate: T) -> Bool {
        if !UIImagePickerController.isSourceTypeAvailable(.Camera) {
            return false
        }
        
        let cameraUI = UIImagePickerController()
        
        cameraUI.sourceType = .Camera

        
        if let mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(.Camera) {
            if mediaTypes.contains( kUTTypeImage as String) {
                cameraUI.mediaTypes = [ kUTTypeImage as String]
            } else {
                cameraUI.mediaTypes = mediaTypes
            }
            
            cameraUI.delegate = delegate;
            cameraUI.allowsEditing = false
            
            viewController.presentViewController(cameraUI, animated: true, completion: nil)
        } else {
            return false
        }

        return true
    }
}

