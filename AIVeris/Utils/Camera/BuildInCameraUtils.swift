//
//  BuildInCameraUtils.swift
//  AIVeris
//
//  Created by Rocky on 16/5/11.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation
import MobileCoreServices
import Photos
import AssetsLibrary

class BuildInCameraUtils {
    class func startCameraControllerFromViewController<T where T: UIImagePickerControllerDelegate, T:UINavigationControllerDelegate>(viewController: UIViewController, delegate: T) -> Bool {

        return startImagePickViewControllerFromViewController(.Camera, viewController: viewController, delegate: delegate)
    }
    
    class func startMediaBrowserFromViewController<T where T: UIImagePickerControllerDelegate, T:UINavigationControllerDelegate>(viewController: UIViewController, delegate: T) -> Bool {
        
        return startImagePickViewControllerFromViewController(.SavedPhotosAlbum, viewController: viewController, delegate: delegate)
    }
    
    private class func startImagePickViewControllerFromViewController<T where T: UIImagePickerControllerDelegate, T:UINavigationControllerDelegate>(sourceType: UIImagePickerControllerSourceType, viewController: UIViewController, delegate: T) -> Bool {
        
        if !UIImagePickerController.isSourceTypeAvailable(sourceType) {
            return false
        }
        
        let mediaUI = UIImagePickerController()
        
        mediaUI.sourceType = sourceType
        
        
        if let mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(sourceType) {
            if mediaTypes.contains(kUTTypeImage as String) {
                mediaUI.mediaTypes = [kUTTypeImage as String]
            } else {
                mediaUI.mediaTypes = mediaTypes
            }
            
            mediaUI.delegate = delegate;
            mediaUI.allowsEditing = false
            
            viewController.presentViewController(mediaUI, animated: true, completion: nil)
        } else {
            return false
        }
        
        return true
    }

    
    class func getLastPhotoAsset() -> PHAsset{
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let assetsFetchResults = PHAsset.fetchAssetsWithOptions(options)
         let count = assetsFetchResults.count
        return assetsFetchResults.firstObject as! PHAsset
    }
    
    class func getImageFromPHAsset(asset : PHAsset) {
        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: CGSize(width: 300, height: 300), contentMode: PHImageContentMode.Default, options: nil) { (image, info) -> Void in
            if let isFullImageKey = info!["PHImageResultIsDegradedKey"] as? Int{
                let data = UIImagePNGRepresentation(image!)
                let cfData = CFDataCreate(kCFAllocatorDefault, UnsafePointer<UInt8>(data!.bytes), data!.length)
                let cgImageSource = CGImageSourceCreateWithData(cfData, nil)
                let properties = NSDictionary(dictionary: CGImageSourceCopyProperties(cgImageSource!, nil)!)
                print("photo properties: \(properties)")

               /* if isFullImageKey == 0{
                    //let cgImageRef = image?.CGImage
                    //let data = UIImageJPEGRepresentation(image!, 0)
                    let data = UIImagePNGRepresentation(image!)
                    let cfData = CFDataCreate(kCFAllocatorDefault, UnsafePointer<UInt8>(data!.bytes), data!.length)
                    let cgImageSource = CGImageSourceCreateWithData(cfData, nil)
                    let properties = NSDictionary(dictionary: CGImageSourceCopyProperties(cgImageSource!, nil)!)
                    print("photo properties: \(properties)")
                }*/
            }
            
        }
    }
    
    class func getFirstImageInfoFromLibrary() -> NSDictionary? {
        var info: NSDictionary?
        let library = ALAssetsLibrary()
        
        library.enumerateGroupsWithTypes(ALAssetsGroupSavedPhotos, usingBlock: { (assetsGroup: ALAssetsGroup!, pointer: UnsafeMutablePointer<ObjCBool>) in
            
            if (assetsGroup != nil) {
                assetsGroup.setAssetsFilter(ALAssetsFilter.allPhotos())
                
                assetsGroup.enumerateAssetsAtIndexes(NSIndexSet.init(index: 0), options: NSEnumerationOptions.init(rawValue: 0), usingBlock: { (asset: ALAsset!, index: Int, point: UnsafeMutablePointer<ObjCBool>) in
                    
                    if (asset != nil) {
                        let representation = asset.defaultRepresentation()
                        info = representation.metadata()
                        NSLog("info: %@", info!)
                        //        print(String.init(format: "info: %@", info!))
                    }
                    
                })
            }
            
            
        }) { (error:NSError!) in
            
        }
        
        return info
    }
    
    /*
     let options = PHContentEditingInputRequestOptions()
     options.networkAccessAllowed = true
     asset.requestContentEditingInputWithOptions(options) { (contentEditingInput : PHContentEditingInput?, _) in
     let fullImage = CIImage(contentsOfURL: contentEditingInput!.fullSizeImageURL!)
     print(fullImage?.properties)
     }
    */
    
    /*
     // Get the assets library
     ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
     
     // Enumerate just the photos and videos group by using ALAssetsGroupSavedPhotos.
     [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
     usingBlock:^(ALAssetsGroup *group, BOOL *stop)
     {
     
     // Within the group enumeration block, filter to enumerate just photos.
     [group setAssetsFilter:[ALAssetsFilter allPhotos]];
     
     // For this example, we're only interested in the first item.
     [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:0]
     options:0
     usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop)
     {
     
     // The end of the enumeration is signaled by asset == nil.
     if (alAsset) {
     ALAssetRepresentation *representation = [alAsset defaultRepresentation];
     NSDictionary *imageMetadata = [representation metadata];
     // Do something interesting with the metadata.
     }
     }];
     }
     failureBlock: ^(NSError *error)
     {
     // Typically you should handle an error more gracefully than this.
     NSLog(@"No groups");
     }];
     
     [library release];
    */
}

