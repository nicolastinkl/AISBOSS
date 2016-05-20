//
//  TaskResultCommitViewController.swift
//  AIVeris
//
//  Created by Rocky on 16/5/10.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import MobileCoreServices

class TaskResultCommitViewController: UIViewController {

    @IBOutlet weak var checkIcon: UIImageView!
    @IBOutlet weak var writeIcon: UIImageView!
    @IBOutlet weak var cameraIcon: UIImageView!
    @IBOutlet weak var questButton: UIButton!
    
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    @IBOutlet weak var line3: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        questButton.layer.cornerRadius = questButton.height / 2
        
        
        let cameraSelector =
            #selector(TaskResultCommitViewController.cameraAction(_:))
        let cameraTap = UITapGestureRecognizer(target: self, action: cameraSelector)
        cameraIcon.addGestureRecognizer(cameraTap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func questButtonClicked(sender: AnyObject) {

    }
    
    func cameraAction(sender : UIGestureRecognizer) {
        startImagePickController()
    }
    
    private func startImagePickController() {
        
        let alert = UIAlertController(title: nil, message: "选择图片来源", preferredStyle: .ActionSheet)
        
        let actionCamera = UIAlertAction(title: "相机", style: .Default) { (UIAlertAction) in
            BuildInCameraUtils.startCameraControllerFromViewController(self, delegate: self)
        }
        
        let actionPhotosAlbum = UIAlertAction(title: "相册", style: .Default) { (UIAlertAction) in
            BuildInCameraUtils.startMediaBrowserFromViewController(self, delegate: self)
        }
        
        let actionCancel = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        
        alert.addAction(actionCamera)
        alert.addAction(actionPhotosAlbum)
        alert.addAction(actionCancel)
        
        presentViewController(alert, animated: true, completion: nil)

    }
}

extension TaskResultCommitViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        if mediaType == (kUTTypeImage as String) {
            var imageToSave: UIImage?
            
            if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
                imageToSave = editedImage
            } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                imageToSave = originalImage
            }
            
            if picker.sourceType == .Camera {
                _ = info[UIImagePickerControllerMediaMetadata] as! NSDictionary
                print("")
            }
            
            
            
            if let image = imageToSave {
                cameraIcon.image = image
            }
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        /*
         // Get the image metadata
         UIImagePickerControllerSourceType pickerType = picker.sourceType;
         if(pickerType == UIImagePickerControllerSourceTypeCamera)
         {
         NSDictionary *imageMetadata = [info objectForKey:
         UIImagePickerControllerMediaMetadata];
         // Get the assets library
         ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
         ALAssetsLibraryWriteImageCompletionBlock imageWriteCompletionBlock =
         ^(NSURL *newURL, NSError *error) {
         if (error) {
         NSLog( @"Error writing image with metadata to Photo Library: %@", error );
         } else {
         NSLog( @"Wrote image with metadata to Photo Library");
         }
         };
         
         // Save the new image (original or edited) to the Camera Roll
         [library writeImageToSavedPhotosAlbum:[imageToSave CGImage]
         metadata:imageMetadata
         completionBlock:imageWriteCompletionBlock];
         }
        */
        
        
        /*
         NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
         UIImage *originalImage, *editedImage, *imageToSave;
         
         // Handle a still image capture
         if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
         == kCFCompareEqualTo) {
         
         editedImage = (UIImage *) [info objectForKey:
         UIImagePickerControllerEditedImage];
         originalImage = (UIImage *) [info objectForKey:
         UIImagePickerControllerOriginalImage];
         
         if (editedImage) {
         imageToSave = editedImage;
         } else {
         imageToSave = originalImage;
         }
         
         // Save the new image (original or edited) to the Camera Roll
         UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil);
         }
         
         // Handle a movie capture
         if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0)
         == kCFCompareEqualTo) {
         
         NSString *moviePath = [[info objectForKey:
         UIImagePickerControllerMediaURL] path];
         
         if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
         UISaveVideoAtPathToSavedPhotosAlbum (
         moviePath, nil, nil, nil);
         }
         }
        */
    }
}

extension TaskResultCommitViewController: UINavigationControllerDelegate {
    
}
