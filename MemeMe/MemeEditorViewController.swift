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
        
        shareButton.enabled = false
        topTextField.hidden = true
        bottomTextField.hidden = true
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
        presentViewController(activityController, animated: true) { () -> Void in
            self.saveMeme(self)
        }
    }
    
    //MARK: Helper Methods
    func generateMeme() -> UIImage {
        toolbar.hidden = true
        navigationController?.navigationBar.hidden = true
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        toolbar.hidden = false
        navigationController?.navigationBar.hidden = false
        return memedImage
    }
    
    
    func presentImagePicker(sourceType: UIImagePickerControllerSourceType) {
        gettingStartedLabel.removeFromSuperview()
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
        topTextField.text = "Top Text Feild"
        bottomTextField.text = "Bottom Text Field"
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
        
//        if let _ = imageView.image {
//            let cancelConfirmation = UIAlertController(title: "Cancel Edit", message: "Are you sure you want to cancel?", preferredStyle: .ActionSheet)
//            let confirmAction = UIAlertAction(title: "Yes", style: .Default) { (action) -> Void in
//                self.dismissViewControllerAnimated(true, completion: nil)
//            }
//            let undoAction = UIAlertAction(title: "No", style: .Default, handler: nil)
//            
//            cancelConfirmation.addAction(confirmAction)
//            cancelConfirmation.addAction(undoAction)
//            self.presentViewController(cancelConfirmation, animated: true, completion: nil)
//        } else {
//            self.dismissViewControllerAnimated(true, completion: nil)
//        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

