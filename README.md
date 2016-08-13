# CameraButton

CameraButton is a subclass of UIButton, that will allow to include photo capturing functionality in any app as easy as asigning the class to the you wish to show camera options button and changing a couple of configuration

##Installation

####CocoaPods

pod 'CameraButton'

####Manually

Add the `CameraButton.swift` file to your project. 

##Usage

###Import

```
Add `import CameraButton.swift` in your file

```

####In Storyboard

In storyboard assign the class to the button that would be used to show the camera,

and create the outlet for that button 

e.g.

```
@IBOutlet weak var myCameraButton: CameraButton!

```
Attach the button to a action 
e.g.

```
@IBAction func myCameraAction(sender: AnyObject) {

    myCameraButton.openCameraOptionMenu()
}

```



####programmatically

In view controller

e.g.

```

let cameraButton: CameraButton = CameraButton(frame: CGRectMake(100, 400, 100, 50))

cameraButton.setTitle("Click Me", forState: UIControlState.Normal)


cameraButton.addTarget(self, action: "myCameraAction:", forControlEvents: UIControlEvents.TouchUpInside) //Attach a action to the button 

self.view.addSubview(cameraButton) // add to view as subview


//create the action
@IBAction func myCameraAction(sender: AnyObject) {

    myCameraButton.openCameraOptionMenu()
}

```

####Setup the camera button 

```
func setupCameraButton() {

    // required
    myCameraButton.targetViewController = self


    //optional
    myCameraButton.targetImageView = self.myImageView // self.myImageView is the UIImageView to put the selected image

    myCameraButton.optinMenuHeaderTitle = "Camera Options"

}

```

or if you want to use the delgate options to manipulate the image 

add the delegate option with the viewcontroler


```
class ViewController: UIViewController, CameraButtonDelegate {

    ...

}


```

```
func setupCameraButton() {

    // required
    myCameraButton.targetViewController = self


    //optional
    myCameraButton.delegate = self

}
```

##Change the options in Menu 

```
func changeMenuOptionsForCamera() {

    //only camera option will be shown
    //default optios are .Camera, .PhotoLibrary, .PhotoAlbum, .DeleteExistingImage

    //.DeleteExistingImage image will only work when the targetImageView controller contains image
    // or cameraButton.imageViewHasImage = true
    // if this flag is true, the existing image from the targetImageView would be removed, even though it has not been
    // picked using the camera button image picker

    myCameraButton.optionMenuList = [ .Camera]


}

```


the delegates

```
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

```


####Other Useful methods

```
/*if let selectedImage : UIImage = self.myCameraButton.getSelectedImage() {

//do something with the selected image

}


if let selectedImageData : NSData = self.myCameraButton.getSelectedImageAsData(type: .PNG) {

//do something with the selected selectedImageData

}

if let selectedImageDataAsString : String = self.myCameraButton.getImageAsBase64EncodedString(type: .PNG) {

//do something with the selected selectedImageDataAsString

}*/

```

#### Other customizable options


```

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
* e.g.
* self.cameraButton.cameraMenuSettings.show = false, the camera option will not be shown in menu
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

```

## Requirements
Requires Swift2.0 and atleast iOS 7.0

## Features
- Highly customizable


## Contributing
Forks, patches and other feedback are welcome.

## Creator
### CameraButton
[Subarna]


## License
CameraButton is available under the MIT license. See the [LICENSE](./LICENSE) file for more info.



