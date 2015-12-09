//
//  Meme.swift
//  MemeMe
//
//  Created by Evan Hurst on 11/18/15.
//  Copyright © 2015 Evan Hurst. All rights reserved.
//

import Foundation
import UIKit


struct Meme {
    var topText:String = ""
    var bottomText:String = ""
    var originalImage: UIImage?
    var memeImage: UIImage?
    
    init(topText:String, bottomText:String, original: UIImage, memed:UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = original
        self.memeImage = memed
    }
}