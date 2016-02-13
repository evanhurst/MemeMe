//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Evan Hurst on 2/6/16.
//  Copyright © 2016 Evan Hurst. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var meme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = meme.memeImage!
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editMeme:")
        navigationItem.rightBarButtonItem = editButton
        
    }
    
    
    func editMeme(sender: AnyObject?) {
        performSegueWithIdentifier("EditMemeSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! UINavigationController
        let editvc = vc.topViewController as! MemeEditorViewController
        editvc.editMeme = meme
    }


    



}
