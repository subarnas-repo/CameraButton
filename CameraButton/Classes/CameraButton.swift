//
//  CameraButton.swift
//  CameraButton
//
//  Created by Subarna Santra on 8/13/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit


/**
     Delegates for camera button to allow greater control over the selected image
 */

@objc public protocol CameraButtonDelegate {
    
    
    /**
         Optional delegate method to know if the image is selected and to get the selected image
    */
    @objc optional func imagePickerDismissed(imagePicked : Bool, withImage : UIImage?)
    
    /**
     Optional delegate method to know if the existing image is deleted
     */
    @objc optional func targetImageDeleted()
    
}


/**
    A subclass of UIButton to make image capturing easy
    - uses UIImagePickerController for image selection
 */
public class CameraButton: UIButton, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    public weak var delegate : CameraButtonDelegate?
    
    /**
         Image type to be provided when getting the image type as NSData
         
         - PNG: For UIImagePNGRepresentation.
         - JPEG: For UIImageJPEGRepresentation.
     */
    
    public enum ImageDataType {
        
        case PNG
        case JPEG
    }
    
    /**
         Option types to be shown for the camera option menu.
         
         - Camera: To open the camera
         - PhotoLibrary: To open the photo library. 
         - PhotoAlbum: To open the photo album.
         - DeleteExistingImage: To delete the image that is already in the targetImageView.
     */
    public enum MenuOptonTypes {
        
        case Camera
        case PhotoLibrary
        case PhotoAlbum
        case DeleteExistingImage
        case Cancel
        
    }
    
    /**
         Available setting options for the menu.
         
         - type: Defines the what the option does (e.g. if the type is .Camera the option should open up the device camera
         - name: The name of the option to be shown to the user in menu list
         - show: Defines if the option is shown to the user when the menu list is opened
         - allowsEditing: Determines if the user should be allowed to edit the selected photo ( does not effect the option .DeleteExistingImage)
         - presentWithAnimation: Show the camera/photo library/photo album image picker is to be shown with animation ( does not effect the option .DeleteExistingImage)
         - dismissWithAnimation: Dismiss the camera/photo library/photo album image picker is to be shown with animation ( does not effect the option .DeleteExistingImage)
         - notAvailableMessage: If the camera option is not available in the message, this message can be shown to user ( does not effect the option .DeleteExistingImage)
     */
    public struct MenuSettings {
        
        var type : MenuOptonTypes
        
        var name: String
        
        var show: Bool = true
        
        var allowsEditing : Bool = false
        
        var presentWithAnimation : Bool = true
        
        var dismissWithAnimation : Bool = true
        
        var notAvailableMessage : String = ""
        
    }
    
    ///Keeps track of the current selected option
    var currentlySelectedOptionSettings : MenuSettings?
    
    ///a custom imagepicker which has to be a subclass of UIImagePickerController can be used if necessary
    public lazy var imagePicker : UIImagePickerController = UIImagePickerController()
    
    
    ///a required option, generally this is the view controller where the Camera Button is placed
    public weak var targetViewController : UIViewController?
    
    
    ///if not provided, a dummy one would be created
    public var targetImageView : UIImageView?

    
    
    ///a image name that could be placed in targetImageView after the image has been deleted
    public var placeHolderImageName : String = ""
    
    
    ///if true, indicates the targetImageView contains a image, and the delete option is shown if not otherwise disabled
    public var imageViewHasImage : Bool = false
    
    
    /**
     * Settings for different camera action,
     *
     * can be disabled by setting show = false
     * if not available a message can be shown
     * no message would be shown if notAvailableMessage is kept empty
     *
     */
    
    
    public var cameraMenuSettings : MenuSettings = MenuSettings(type : .Camera, name: "Camera", show: true, allowsEditing : false, presentWithAnimation : true, dismissWithAnimation : true, notAvailableMessage : "Unable to find camera in this device")
    
    
    ///settings for photo library action
    public var photoLibraryMenuSettings : MenuSettings = MenuSettings(type : .PhotoLibrary, name: "Photo Library", show: true, allowsEditing : false, presentWithAnimation : true, dismissWithAnimation : true, notAvailableMessage : "Unable to find photo library in this device")
    
    
    ///settings for photo album action
    public var photoAlbumMenuSettings : MenuSettings = MenuSettings(type : .PhotoAlbum, name: "Photo Album", show: true, allowsEditing : false, presentWithAnimation : true, dismissWithAnimation : true, notAvailableMessage : "Unable to find photo album in this device")
    
    
    ///the allowsEditing, prsentWithAnimation and dismissWithAnimation, notAvailableMessage does not really effect this menu
    public var deleteMenuSettings : MenuSettings = MenuSettings(type : .DeleteExistingImage, name: "Delete", show: true, allowsEditing : false, presentWithAnimation : true, dismissWithAnimation : true, notAvailableMessage : "")
    
    ///settings for cancel action
    public var cancelMenuSettings : MenuSettings = MenuSettings(type : .Cancel, name: "Cancel", show: true, allowsEditing : false, presentWithAnimation : true, dismissWithAnimation : true, notAvailableMessage : "")
    
    
    
    ///The header of the menu
    public var optinMenuHeaderTitle : String = ""
    
    
    ///this option should be used to change the order of availabel options, can also be used to not show an option
    public var optionMenuList : Array<MenuOptonTypes> = [
        
        .Camera, .PhotoLibrary, .PhotoAlbum, .DeleteExistingImage
    ]
    
    ///user can choose to show the option menu popover from other places
    
    public weak var showOptionMenuFromView : UIView?
    
    
    ///user can choose to show the option menu popover from bar button item
    
    public weak var showOptionFromBarButtonItem : UIBarButtonItem?
    
    
    ///setup image picker first
    
    func setupImagePicker() {
        
        imagePicker.delegate = self
        
    }
    
    
    
    /**
     * Image picker setup is initiated if the target view controller is availabel.
     
        - Returns: true if the targetViewController is availabel.
     */
    
    func checkSettings()->Bool {
        
        
        /// if target view controller is not given, would not work
        if (targetViewController == nil) {
            
            return false;
        }
        
        /// image picker setup is initiated
        
        self.setupImagePicker()
        
        return true;
    }
    
    
    /**
         Initializes the options depnding on the settings in optionMenuList
         
         - Parameters:
         - alertController: Alert view to show the menu
     */
    
    func createCameraOptionMenu(alertController : UIAlertController) {
        
        for (currentOption) in self.optionMenuList {
            
            
            switch currentOption {
              
            /// option to get image from camera
            case .Camera:
                
                //check settings
                if (self.cameraMenuSettings.show == false) {
                    
                    continue
                }
                
                //attach action to the menu
                let cameraAction = UIAlertAction(title: self.cameraMenuSettings.name, style: .default) { (action) in
                    
                    
                    //action to open camera
                    self.openCamera(withSettings: self.cameraMenuSettings)
                }
                
                //added to the list
                alertController.addAction(cameraAction)
                
                
            
            /// option to select image from photo library
            case .PhotoLibrary:
                
                //check settings
                if (self.photoLibraryMenuSettings.show == false) {
                    
                    continue
                }
                
                //attach action to the menu
                let photoLibraryAction = UIAlertAction(title: self.photoLibraryMenuSettings.name, style: .default) { (action) in
                    
                    //action to open photo library
                    self.openPhotoLibary(withSettings: self.photoLibraryMenuSettings)
                }
                
                //added to the list
                alertController.addAction(photoLibraryAction)
                
                
                
            /// option to select image from photo albums
            case .PhotoAlbum:
                
                //check settings
                if (self.photoAlbumMenuSettings.show == false) {
                    
                    continue
                }
                
                
                let photoAlbumAction = UIAlertAction(title: self.photoAlbumMenuSettings.name, style: .default) { (action) in
                    
                    //action to open photo album
                    self.openPhotoAlbum(withSettings: self.photoAlbumMenuSettings)
                }
                
                //added to the list
                alertController.addAction(photoAlbumAction)
                
                
                
            /// option to delete existing image in target image view
            case .DeleteExistingImage:
                
                //check settings
                if (self.deleteMenuSettings.show == false) {
                    
                    continue
                }
                
                //if there is any iamge in target image view
                if (self.imageViewHasImage == true) {
                    
                    
                    
                    let deleteImageAction = UIAlertAction(title: self.deleteMenuSettings.name, style: .default) { (action) in
                        
                        //action to delete the existing image
                        self.deleteExistingImage(withSettings: self.deleteMenuSettings)
                    }
                    
                    //added to the list
                    alertController.addAction(deleteImageAction)
                }
                
            case .Cancel:
                
                //check settings
                if (self.cancelMenuSettings.show == false) {
                    
                    continue
                }
                
                ///cancel action to cancel the camera option menu
                let cancelAction = UIAlertAction(title: self.cancelMenuSettings.name, style: .cancel) { (action) in
                }
                
                /// cancel action is added to the list
                alertController.addAction(cancelAction)
            }
        }
    }
    
    
    /**
     * Shows menu to open up options depending on the settings in optionMenuList
     */
    
    public func openCameraOptionMenu() {
        
        
        let totalOptions = self.optionMenuList.count
        
        ///if there is no option the menu would not come up
        if (totalOptions < 1) {
            return;
        }
        
        self.optionMenuList.append(.Cancel)
        
        let alertController = UIAlertController(title: nil, message: self.optinMenuHeaderTitle, preferredStyle: .actionSheet)
        
        ///add the option menus
        self.createCameraOptionMenu(alertController: alertController);
        
        
        //if the target view controller is avialble
        if let givenViewController = targetViewController {
            
            // checks to show where the menu is to be shown from ( IMPORTANT FOR IPAD)
            if ( self.showOptionMenuFromView != nil || self.showOptionFromBarButtonItem != nil || UIDevice.current.userInterfaceIdiom == .pad) {
                
                alertController.popoverPresentationController?.sourceView = self.targetViewController!.view
                
                /// camera option is shown from bar button item if given
                if (self.showOptionFromBarButtonItem != nil) {
                    
                    alertController.popoverPresentationController?.barButtonItem = self.showOptionFromBarButtonItem!
                    
                } else {
                    
                    /// if for no view is given to show the menu from, the menu is given from the camera button in case of IPAD
                    if (self.showOptionMenuFromView == nil) {
                        
                        self.showOptionMenuFromView = self
                    }
                    
                    alertController.popoverPresentationController?.sourceRect = self.showOptionMenuFromView!.frame
                    
                }
                
            }
            /// the option list is shown
            givenViewController.present(alertController, animated: true) { }
        }
        
    }
    
    /*if an image exists in the given target image view that has been selected from photo picker its deleted*/
    
    
    /**
        Delete existing image in target image view
     
        - Parameters:
        - settings: the settings for this menu options ( does not do anything actually)
     */
    public func deleteExistingImage(withSettings settings : MenuSettings) {
        
        if (self.imageViewHasImage == true && targetImageView != nil) {
            
            // image is removed
            targetImageView?.image = nil
            
            
            // flag = false to indicate there is no existing image in target image view
            imageViewHasImage = false
            
            /// place holder image is placed if the name is provided in place of the deleted image
            /// place holder image is not considered as an existing image
            if (!self.placeHolderImageName.isEmpty) {
                
                if let placeHolderImage : UIImage = UIImage(named: self.placeHolderImageName) {
                    
                    
                    targetImageView?.image = placeHolderImage
                }
            }
            
            //the delegate method to indicat image deletiion is called
            self.delegate?.targetImageDeleted?()
            
        }
    }
    
    
    /**
        Opens camera, if available
     
        - Parameters:
        - settings: the settings for this menu options
    */
    
    public func openCamera(withSettings settings : MenuSettings) {
        
        //check the settings type
        if (settings.type == .Camera) {
            
            
            //if camer available in device
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                
                // if the image picker is setup properly
                if (checkSettings() == true) {
                    
                    
                    //set the currently selected option as camera
                    self.currentlySelectedOptionSettings = settings
                    
                    
                    //allows editing of captured depending on the settings
                    imagePicker.allowsEditing = settings.allowsEditing
                    
                    
                    //source type is camera
                    imagePicker.sourceType = .camera
                    
                    
                    //show the camera to user ( with or without animation depending on the menu settings)
                    targetViewController!.present(imagePicker, animated: settings.presentWithAnimation, completion: nil)
                }
                
            } else {
                
                //shows the alert message ( if the notAvailableMessage is given)
                self.showAlertMessage(message: settings.notAvailableMessage)
            }
        }
    }
    
    
    /**
        Opens photo library, if available
     
        - Parameters:
        - settings: the settings for this menu options
    */
    
    public func openPhotoLibary(withSettings settings : MenuSettings) {
        
        if (settings.type == .PhotoLibrary) {
            
            
            //if the photo library is available
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                
                if (checkSettings() == true) {
                    
                    //set the currently selected option as photo library
                    self.currentlySelectedOptionSettings = settings
                    
                    //allows editing of selected depending on the settings
                    imagePicker.allowsEditing = settings.allowsEditing
                    
                    
                    //source type is photo library
                    imagePicker.sourceType = .photoLibrary
                    
                    //show the camera to user ( with or without animation depending on the menu settings)
                    targetViewController!.present(imagePicker, animated: settings.presentWithAnimation, completion: nil)
                }
                
            } else {
                
                //shows the alert message ( if the notAvailableMessage is given)
                self.showAlertMessage(message: settings.notAvailableMessage)
            }
        }
    }
    
    
    /**
     Opens photo album, if available
     
     - Parameters:
     - settings: the settings for this menu options
     */
    
    public func openPhotoAlbum(withSettings settings : MenuSettings) {
        
        //if the photo album is available
        if (settings.type == .PhotoAlbum) {
            
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                
                if (checkSettings() == true) {
                    
                    //set the currently selected option as photo album
                    self.currentlySelectedOptionSettings = settings
                    
                    //allows editing of selected depending on the settings
                    imagePicker.allowsEditing = settings.allowsEditing
                    
                    //source type is photo album
                    imagePicker.sourceType = .savedPhotosAlbum
                    
                    //show the camera to user ( with or without animation depending on the menu settings)
                    targetViewController!.present(imagePicker, animated: settings.presentWithAnimation, completion: nil)
                }
                
            } else {
                
                //shows the alert message ( if the notAvailableMessage is given)
                self.showAlertMessage(message: settings.notAvailableMessage)
            }
        }
    }
    
    /**
         Shows the alert message if the selected image source is not available in the device
         
         - Parameters:
         - message: The message to be shown to user
         - title: Title of the message
     
     */
    public func showAlertMessage(message : String, title : String = "" ) {
        
        // show the alert, if target view controller is there
        
        if (targetViewController != nil && !message.isEmpty) {
            
            
            //alert view controller is created with the given message and title
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            
            //dismiss action is added to the view
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            //message is shown to the user
            self.targetViewController!.present(alert, animated: true, completion: nil)
        }
    }
    
    
    ///if target image view is not already supplied, a new one is created
    public func getTargetImageView()->UIImageView? {
        
        if (targetImageView == nil) {
            
            targetImageView = UIImageView()
            //targetImageView!.contentMode = .ScaleAspectFit

        }
        
        return targetImageView!
    }
    
    
    
    //MARK : get selected image
    
    
    /**
         To get the image currently in target image view (if there is any)
         
         - Returns: the existing image in target image view
    */
    
    public func getSelectedImage()-> UIImage? {
        
        if (self.imageViewHasImage == true && self.targetImageView != nil) {
            
            if let selectedImage = self.targetImageView?.image {
                
                return selectedImage
            }
        }
        return nil
    }
    
    
    /**
         To get the image currently in target image view (if there is any) as NSData
         
         - Parameters:
             - type:                .JPEG or .PNG
             - compressionFactor:   Value between 1 & 0, if set to 1 the image is uncompressed
                                    in case of PNG representation of the data, compression factor is not used
     
     
         - Returns: the existing image as NSData
    */
    
    public func getSelectedImageAsData(type : ImageDataType, compressionFactor : CGFloat = 1.0)-> Data? {
        
        if self.imageViewHasImage == true, let selectedImage = self.targetImageView?.image {
            
            if (type == .JPEG) {
                return selectedImage.jpegData(compressionQuality: compressionFactor)
                
            } else if (type == .PNG) {
                return selectedImage.pngData()
            }
        }
        
        return nil
    }
    
    
    /**
     To get the image currently in target image view (if there is any) as as base64 encoded string
     
     - Parameters:
     - type:                .JPEG or .PNG
     - compressionFactor:   Value between 1 & 0, if set to 1 the image is uncompressed
     in case of PNG representation of the data, compression factor is not used
     
     
     - Returns: the existing image as as base64 encoded string
     */
    
    public func getImageAsBase64EncodedString(type : ImageDataType, compressionFactor : CGFloat = 1.0) -> String? {
        
        //existing image is converted to image data
        if let imageData = self.getSelectedImageAsData(type: type, compressionFactor: compressionFactor) {
            
            //image data converted to the base64 encoded string
            return imageData.base64EncodedString(options: .lineLength64Characters)
        }
        
        return nil
    }
    
    
    //MARK : UIImagePickerController delegate methods
    
    
    /**
     * Accepts photos from picker view and add the selected image to target uiiimage
     *
     * calls the delegate method for indicating image picker is dismissed after image selection
     */
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
     
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            ///get the target image view
            if let imageView = self.getTargetImageView() {
                
                /// if the target image view is available, the image is placed
                imageView.image = pickedImage
                
                
                ///flag = true to indicate there is an image in target image view now
                self.imageViewHasImage = true
                
                // the delegate method for indicating image picker is dismissed after image selection
                self.delegate?.imagePickerDismissed?(imagePicked: true, withImage: pickedImage)
                
            }
        }
        
        ///dismiss the image picker
        self.dismissImagePicker(cancelled : false, imagePicked:  true);
    }
    
    
    /**
     * Dismiss picker view.
     *
     * calls the delegate method for indicating image picker cancelled by user is implemented
     */
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
         // the delegate method for indicating image picker is dismissed without image selection
        self.delegate?.imagePickerDismissed?(imagePicked: false, withImage: nil)
        
        ///dismiss the image picker
        self.dismissImagePicker(cancelled : true, imagePicked:  false);
    }
    
   
    /**
     Dismiss picker view (with or without animation depending on the menu option settings
     
     - Parameters:
     - cancelled: True if the image picker is dismissed after user has cancelled the image picker
     - imagePicked: True if the image picker is dismissed after image is selected
     
     - Returns: None.
     */
    public func dismissImagePicker(cancelled: Bool, imagePicked : Bool) {
        
        if (targetViewController != nil) {
            
            var withAnimation : Bool = true
            
            if (self.currentlySelectedOptionSettings != nil) {
                
                withAnimation  = self.currentlySelectedOptionSettings!.dismissWithAnimation
            }
            
            ///no option is currently selected
            self.currentlySelectedOptionSettings = nil
            
            
            ///dismiss image picker
            targetViewController!.dismiss(animated: withAnimation, completion: nil)
        }
    }
   
    
}
