//
//  ViewController.swift
//  CameraButton
//
//  Created by subarna-santra on 08/13/2016.
//  Copyright (c) 2016 subarna-santra. All rights reserved.
//

import UIKit
import CameraButton

class ViewController: UIViewController, CameraButtonDelegate {
    
    @IBOutlet weak var myImageView: UIImageView!
    
    
    @IBOutlet weak var myCameraButton: CameraButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.setupCameraButton()
        
        self.setupCameraButton1()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Different ways of setting up the camera button
    func setupCameraButton() {
        
        // required
        myCameraButton.targetViewController = self
        
        
        //optional
        myCameraButton.targetImageView = self.myImageView
        
        myCameraButton.optinMenuHeaderTitle = "Camera Options"
        
    }
    
    
    func setupCameraButton1() {
        
        // required
        myCameraButton.targetViewController = self
        
        
        //optional
        myCameraButton.delegate = self
        
    }
    
    
    // MARK: Optional delegate method for camera buttons
    
    /* the selected image can be manipulated even if the target image view is not specified */
    
    func imagePickerDismissed(imagePicked : Bool, withImage : UIImage?) {
        
        if (imagePicked == true && withImage != nil) {
            
            self.myImageView.image = withImage!
        
        }
    }
    
    func targetImageDeleted() {
        
        //whatever action needs to be taken after the image has been deletated
        //e.g.
        self.myImageView.image = nil
    }
    
    // MARK: other ways of getting the selected image
    
    func getSelectedImage() {
        
        
        /*if let selectedImage : UIImage = self.myCameraButton.getSelectedImage() {
            
            //do something with the selected image
            
        }
        
        
        if let selectedImageData : NSData = self.myCameraButton.getSelectedImageAsData(type: .PNG) {
            
            //do something with the selected selectedImageData
            
        }
        
        if let selectedImageDataAsString : String = self.myCameraButton.getImageAsBase64EncodedString(type: .PNG) {
            
            //do something with the selected selectedImageDataAsString
            
        }*/
    }
    
    
    
    // MARK: Camera action
    @IBAction func myCameraAction(sender: AnyObject) {
        
        myCameraButton.openCameraOptionMenu()
    }
}

