//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Evan Hurst on 11/18/15.
//  Copyright © 2015 Evan Hurst. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    //MARK: Storyboard Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var gettingStartedLabel: UILabel!
    @IBOutlet weak var memeContainerView: UIView!
    
    var editMeme: Meme?
    
    //MARK: Instance Variables
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40.0)!,
        NSStrokeWidthAttributeName : -1.5
    ]
    
    //MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        configureMemeTextFields()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotification()
        
        if let meme = editMeme {
            gettingStartedLabel.hidden = true
            topTextField.text = meme.topText
            bottomTextField.text = meme.bottomText
            imageView.image = meme.originalImage
        } else {
            topTextField.text = "Top Text Feild"
            bottomTextField.text = "Bottom Text Field"
            shareButton.enabled = false
            topTextField.hidden = true
            bottomTextField.hidden = true
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    //MARK: Storyboard Actions

    @IBAction func pickImage(sender: AnyObject) {
        presentImagePicker(.PhotoLibrary)
    }
    
    @IBAction func takePhoto(sender: AnyObject) {
        presentImagePicker(.Camera)
    }

    
    @IBAction func shareMeme(sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: [generateMeme()], applicationActivities: nil)
        activityController.completionWithItemsHandler = {(activityType, completed:Bool, returnedItems:[AnyObject]?, error: NSError?) in
            
            if (!completed) {
                return
            }
            
            self.saveMeme(self)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        presentViewController(activityController, animated: true, completion: nil)
        
        
    }
    
    //MARK: Helper Methods
    func generateMeme() -> UIImage {
        topTextField.resignFirstResponder()
        bottomTextField.resignFirstResponder()
        UIGraphicsBeginImageContext(imageView.frame.size)
        memeContainerView.drawViewHierarchyInRect(imageView.frame, afterScreenUpdates: true)
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return memedImage
    }
    
    
    func presentImagePicker(sourceType: UIImagePickerControllerSourceType) {
        gettingStartedLabel.hidden = true
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        presentViewController(picker, animated: true, completion: nil)
    }
    
    
    func saveMeme(sender: AnyObject) {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, original: imageView.image!, memed: generateMeme())
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }
    
    func configureMemeTextFields() {
        topTextField.delegate = self
        bottomTextField.delegate = self
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .Center
        topTextField.textColor = UIColor.whiteColor()
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = .Center
        bottomTextField.textColor = UIColor.whiteColor()
    }
    
    //MARK: UITextFieldDelegate Methods
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Image Picker Delegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imageView.image = image
        dismissViewControllerAnimated(true) { () -> Void in
            self.shareButton.enabled = true
            self.topTextField.hidden = false
            self.bottomTextField.hidden = false
            self.topTextField.text = "Top Text"
            self.bottomTextField.text = "Bottom Text"
        }
        

    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //MARK: Keyboard Appearance
    
    func keyboardWillAppear(sender: NSNotification) {
        let userInfo = sender.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        let keyboardRect = keyboardSize.CGRectValue()
        if (bottomTextField.isFirstResponder() && keyboardRect.intersects(bottomTextField.frame)) {
            view.frame.origin.y -= keyboardSize.CGRectValue().height
        }
        
    }
    
    func keyboardWillDisappear(sender: NSNotification) {
        view.frame.origin.y = 0
    }
    
    func subscribeToKeyboardNotification(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillAppear:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillDisappear:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    @IBAction func cancelCreatingMeme(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

