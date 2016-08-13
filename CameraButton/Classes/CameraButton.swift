//
//  CameraButton.swift
//  CameraButton
//
//  Created by Subarna Santra on 8/13/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

@objc public protocol CameraButtonDelegate {
    
    optional func imagePickerDismissed(imagePicked : Bool, withImage : UIImage?)
    
    optional func targetImageDeleted()
    
}

public class CameraButton: UIButton, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    public weak var delegate : CameraButtonDelegate?
    
    //image type to be provided when getting the image type as NSData
    public enum ImageDataType {
        
        case PNG
        case JPEG
    }
    
    
    public enum MenuOptonTypes {
        
        case Camera
        case PhotoLibrary
        case PhotoAlbum
        case DeleteExistingImage
        
    }
    
    
    public struct MenuSettings {
        
        var type : MenuOptonTypes
        
        var name: String
        
        var show: Bool = true
        
        var allowsEditing : Bool = false
        
        var presentWithAnimation : Bool = true
        
        var dismissWithAnimation : Bool = true
        
        var notAvailableMessage : String = ""
        
    }
    
    var currentlySelectedOptionSettings : MenuSettings?
    
    //a custom imagepicker which has to be a subclass of UIImagePickerController can be used if necessary
    public lazy var imagePicker : UIImagePickerController = UIImagePickerController()
    
    
    //a required option, generally this is the view controller where the Camera Button is placed
    public weak var targetViewController : UIViewController?
    
    
    //if not provided, a dummy one would be created
    public weak var targetImageView : UIImageView?

    
    
    //a image name that could be placed in targetImageView after the image has been deleted
    public var placeHolderImageName : String = ""
    
    
    //if true, indicates the targetImageView contains a image, and the delete option is shown if not otherwise disabled
    public var imageViewHasImage : Bool = false
    
    
    /**settings for different camera action, 
     *
     * can be disabled by setting show = false
     * if not available a message can be shown
     * no message would be shown if notAvailableMessage is kept empty
     *
     */
    public var cameraMenuSettings : MenuSettings = MenuSettings(type : .Camera, name: "Camera", show: true, allowsEditing : false, presentWithAnimation : true, dismissWithAnimation : true, notAvailableMessage : "Unable to find camera in this device")
    
    
    //settings for photo library action
    public var photoLibraryMenuSettings : MenuSettings = MenuSettings(type : .PhotoLibrary, name: "Photo Library", show: true, allowsEditing : false, presentWithAnimation : true, dismissWithAnimation : true, notAvailableMessage : "Unable to find photo library in this device")
    
    
    //settings for photo album action
    public var photoAlbumMenuSettings : MenuSettings = MenuSettings(type : .PhotoAlbum, name: "Photo Album", show: true, allowsEditing : false, presentWithAnimation : true, dismissWithAnimation : true, notAvailableMessage : "Unable to find photo album in this device")
    
    
    //the allowsEditing, prsentWithAnimation and dismissWithAnimation, notAvailableMessage does not really effect this menu
    
    public var deleteMenuSettings : MenuSettings = MenuSettings(type : .DeleteExistingImage, name: "Delete", show: true, allowsEditing : false, presentWithAnimation : true, dismissWithAnimation : true, notAvailableMessage : "")
    
    
    
    //The header of the menu
    public var optinMenuHeaderTitle : String = ""
    
    
    //this option should be used to change the order of availabel options, can also be used to not show an option
    public var optionMenuList : Array<MenuOptonTypes> = [
        
        .Camera, .PhotoLibrary, .PhotoAlbum, .DeleteExistingImage
    ]
    
    
    
    
    //setup image picker first
    
    func setupImagePicker() {
        
        imagePicker.delegate = self
        
    }
    
    
    
    /* returns false if the target image view controller is not supplied
    or the image picker is not setup propertly*/
    
    func checkSettings()->Bool {
        
        
        // if target view controller is not given, would not work
        if (targetViewController == nil) {
            
            return false;
        }
        
        // if image picker is not already setup, its set up first
        
        self.setupImagePicker()
        
        return true;
    }
    
    
    /** Camera options menus shown or hidden depending on the settings */
    
    func createCameraOptionMenu(alertController alertController : UIAlertController) {
        
        for (currentOption) in self.optionMenuList {
            
            
            
            switch currentOption {
                
            case .Camera:
                
                if (self.cameraMenuSettings.show == false) {
                    
                    continue
                }
                
                
                let cameraAction = UIAlertAction(title: self.cameraMenuSettings.name, style: .Default) { (action) in
                    
                    self.openCamera(withSettings: self.cameraMenuSettings)
                }
                
                alertController.addAction(cameraAction)
                
                
            case .PhotoLibrary:
                
                if (self.photoLibraryMenuSettings.show == false) {
                    
                    continue
                }
                
                let cameraAction = UIAlertAction(title: self.photoLibraryMenuSettings.name, style: .Default) { (action) in
                    
                    self.openPhotoLibary(withSettings: self.photoLibraryMenuSettings)
                }
                
                alertController.addAction(cameraAction)
                
            case .PhotoAlbum:
                
                if (self.photoAlbumMenuSettings.show == false) {
                    
                    continue
                }
                
                
                let cameraAction = UIAlertAction(title: self.photoAlbumMenuSettings.name, style: .Default) { (action) in
                    
                    self.openPhotoAlbum(withSettings: self.photoAlbumMenuSettings)
                }
                
                alertController.addAction(cameraAction)
                
            case .DeleteExistingImage:
                
                if (self.deleteMenuSettings.show == false) {
                    
                    continue
                }
                
                
                if (self.imageViewHasImage == true) {
                    
                    let cameraAction = UIAlertAction(title: self.deleteMenuSettings.name, style: .Default) { (action) in
                        
                        self.deleteExistingImage(withSettings: self.photoAlbumMenuSettings)
                    }
                    alertController.addAction(cameraAction)
                }
            }
        }
    }
    
    
    /** shows menu to open up options */
    
    public func openCameraOptionMenu() {
        
        
        let totalOptions = self.optionMenuList.count
        
        //if there is no option the menu would not come up
        if (totalOptions < 1) {
            return;
        }
        
        let alertController = UIAlertController(title: nil, message: self.optinMenuHeaderTitle, preferredStyle: .ActionSheet)
        
        
        //add the option menus
        
        self.createCameraOptionMenu(alertController: alertController);
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            
            
        }
        
        alertController.addAction(cancelAction)
        
        
        if (targetViewController != nil) {
            
            self.targetViewController!.presentViewController(alertController, animated: true) {
               
            }
        }
        
    }
    
    /*if an image exists in the given target image view that has been selected from photo picker its deleted*/
    
    public func deleteExistingImage(withSettings settings : MenuSettings) {
        
        if (self.imageViewHasImage == true && targetImageView != nil) {
            
            
            targetImageView?.image = nil
            
            imageViewHasImage = false
            
            //place holder image is not considered as an existing image
            if (!self.placeHolderImageName.isEmpty) {
                
                if let placeHolderImage : UIImage = UIImage(named: self.placeHolderImageName) {
                    
                    targetImageView?.image = placeHolderImage
                }
            }
            
            
            self.delegate?.targetImageDeleted?()
            
        }
    }
    
    
    //opens camera, if available
    
    public func openCamera(withSettings settings : MenuSettings) {
        
        
        if (settings.type == .Camera) {
            
            if UIImagePickerController.isSourceTypeAvailable(.Camera){
                
                if (checkSettings() == true) {
                    
                    self.currentlySelectedOptionSettings = settings
                    
                    imagePicker.allowsEditing = settings.allowsEditing
                    
                    imagePicker.sourceType = .Camera
                    
                    targetViewController!.presentViewController(imagePicker, animated: settings.presentWithAnimation, completion: nil)
                }
                
            } else {
                
                //shows the alert message
                self.showAlertMessage(settings.notAvailableMessage)
            }
        }
    }
    
    
    //opens photo library, if available
    public func openPhotoLibary(withSettings settings : MenuSettings) {
        
        if (settings.type == .PhotoLibrary) {
            
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary){
                
                if (checkSettings() == true) {
                    
                    self.currentlySelectedOptionSettings = settings
                    
                    imagePicker.allowsEditing = settings.allowsEditing
                    
                    imagePicker.sourceType = .PhotoLibrary
                    
                    targetViewController!.presentViewController(imagePicker, animated: settings.presentWithAnimation, completion: nil)
                }
                
            } else {
                
                //shows the alert message
                self.showAlertMessage(settings.notAvailableMessage)
            }
        }
    }
    
    
    
    
    //opens photo album
    public func openPhotoAlbum(withSettings settings : MenuSettings) {
        
        
        if (settings.type == .PhotoAlbum) {
            
            if UIImagePickerController.isSourceTypeAvailable(.SavedPhotosAlbum){
                
                if (checkSettings() == true) {
                    
                    self.currentlySelectedOptionSettings = settings
                    
                    imagePicker.allowsEditing = settings.allowsEditing
                    
                    imagePicker.sourceType = .SavedPhotosAlbum
                    
                    targetViewController!.presentViewController(imagePicker, animated: settings.presentWithAnimation, completion: nil)
                }
                
            } else {
                
                //shows the alert message
                self.showAlertMessage(settings.notAvailableMessage)
            }
        }
    }
    
    
    public func showAlertMessage(message : String, title : String = "" ) {
        
        
        // show the alert, if target view controller is there
        
        if (targetViewController != nil && !message.isEmpty) {
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.targetViewController!.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    //if target image view is not already supplied, a new one is created
    public func getTargetImageView()->UIImageView? {
        
        if (targetImageView == nil) {
            
            targetImageView = UIImageView()
            //targetImageView!.contentMode = .ScaleAspectFit

        }
        
        return targetImageView!
    }
    
    //accepts photos from picker view and add the selected image to target uiiimage
    
    public func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            if let imageView = self.getTargetImageView() {
            
                imageView.image = pickedImage
                
                self.imageViewHasImage = true
                
                
                self.delegate?.imagePickerDismissed?(true, withImage: pickedImage)
                
            }
        }
        
        self.dismissImagePicker(cancelled : false, imagePicked:  true);
    }
    
    
    
    public func getSelectedImage()-> UIImage? {
        
        if (self.imageViewHasImage == true && self.targetImageView != nil) {
            
            if let selectedImage = self.targetImageView?.image {
                
                return selectedImage
            }
        }
        return nil
    }
    
    
    //in case of PNG representation of the data, compression factor is not used
    
    public func getSelectedImageAsData(type type : ImageDataType, compressionFactor : CGFloat = 1.0)-> NSData? {
        
        if (self.imageViewHasImage == true && self.targetImageView != nil) {
            
            if let selectedImage = self.targetImageView?.image {
                
                if (type == .JPEG) {
                    
                    if let imageData: NSData = UIImageJPEGRepresentation(selectedImage, compressionFactor) {
                        
                        return imageData
                    }
                    
                } else if (type == .PNG) {
                    
                    if let imageData: NSData = UIImagePNGRepresentation(selectedImage) {
                        
                        return imageData
                    }
                }
            }
        }
        return nil
    }
    
    
    //get the selected image ( if any) as base64 encoded string
    
    public func getImageAsBase64EncodedString(type type : ImageDataType, compressionFactor : CGFloat = 1.0) -> String? {
        
        
        if let imageData = self.getSelectedImageAsData(type: type, compressionFactor: compressionFactor) {
            
            if let strBase64:String = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength) {
                
                return strBase64;
            }
        }
        
        return nil
    }
    
    
    //image picker is cancelled
    public func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        self.delegate?.imagePickerDismissed?(false, withImage: nil)
        
        
        self.dismissImagePicker(cancelled : true, imagePicked:  false);
    }
    
    //dismiss picker view
    public func dismissImagePicker(cancelled cancelled: Bool, imagePicked : Bool) {
        
        if (targetViewController != nil) {
            
            var withAnimation : Bool = true
            
            if (self.currentlySelectedOptionSettings != nil) {
                
                withAnimation  = self.currentlySelectedOptionSettings!.dismissWithAnimation
            }
            
            self.currentlySelectedOptionSettings = nil
            
            targetViewController!.dismissViewControllerAnimated(withAnimation, completion: nil)
        }
    }
   
    
}
