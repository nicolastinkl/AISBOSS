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
        
//        checkIcon.image = UIImage(named: "timer_button_selected")
//        writeIcon.image = UIImage(named: "ai_audioButton_default")
//        cameraIcon.image = UIImage(named: "Seller_Icon")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func questButtonClicked(sender: AnyObject) {
   //     BuildInCameraUtils.startCameraControllerFromViewController(self, delegate: self)
    //    let asset = BuildInCameraUtils.getLastPhotoAsset()
        
        BuildInCameraUtils.getFirstImageInfoFromLibrary()
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
                let imageMetadata = info[UIImagePickerControllerMediaMetadata] as! NSDictionary
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
