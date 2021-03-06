//
//  CQZContactUtils.swift
//  CQZContactManger
//
//  Created by Christian Quicano on 3/20/17.
//  Copyright © 2017 ca9z. All rights reserved.
//

import Foundation
import Contacts

class CQZContactUtil {
    
    class func createAbreviation(forContact contact:CNContact) -> String {
        var text = ""
        if let letter = contact.givenName.characters.first {
            text.append(letter)
        }
        if let letter = contact.familyName.characters.first {
            text.append(letter)
        }
        return text
    }
    
    class func createImage(fromLabel label:UILabel) -> UIImage? {
        UIGraphicsBeginImageContext(label.frame.size)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? nil
    }
    
    class func createLabel(withText text:String, andSize size:CGSize, fontSize:CGFloat) -> UILabel {
        let label = UILabel()
        label.frame.size = size
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        label.textColor = UIColor.black
        label.text = text
        label.textAlignment = NSTextAlignment.center
        return label
    }
    
    
}
