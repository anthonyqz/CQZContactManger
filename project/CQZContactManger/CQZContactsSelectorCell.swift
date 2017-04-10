//
//  CQZContactsSelectorCell.swift
//  CQZContactManger
//
//  Created by Christian Quicano on 3/19/17.
//  Copyright © 2017 ca9z. All rights reserved.
//

import UIKit
import Contacts

class CQZContactsSelectorCell: UITableViewCell {

    //MARK:- @IBOutlet
    @IBOutlet private weak var contactImage: UIImageView!
    @IBOutlet private weak var contactName: UILabel!
    
    //MARK:- public methods
    func configureCell(withContact contact:CNContact) {
        
        let name = "\(contact.givenName) \(contact.familyName)"
        
        let image = contact.imageData != nil ? UIImage(data: contact.imageData!) : nil
        if image != nil {
            contactImage.image = image
        } else {
            let abreviation = CQZContactUtil.createAbreviation(forContact: contact)
            let nameLabel = CQZContactUtil.createLabel(withText: abreviation, andSize: contactImage.frame.size, fontSize: 9)
            contactImage.image = CQZContactUtil.createImage(fromLabel: nameLabel)
        }
        
        contactImage.layer.cornerRadius = contactImage.frame.size.width / 2
        contactName.text = name
    }
}
