//
//  CQZContactSelectedCell.swift
//  CQZContactManger
//
//  Created by Christian Quicano on 3/19/17.
//  Copyright © 2017 ca9z. All rights reserved.
//

import UIKit
import Contacts

protocol CQZContactSelectedCellDelegate:NSObjectProtocol {
    func deleteContact(atIndexPath indexPath:IndexPath?)
}

class CQZContactSelectedCell: UICollectionViewCell {

    //MARK:- public properties
    var delegate:CQZContactSelectedCellDelegate?
    
    //MARK:- private properties
    private var indexPathSelected:IndexPath?
    
    //MARK:- @IBOutlet properties
    @IBOutlet private weak var imageContact: UIImageView!
    @IBOutlet private weak var nameContact: UILabel!
    @IBOutlet private weak var buttonDelete: UIButton!
    
    //MARK:- public func
    func configureCell(withContact contact:CNContact, atIndexPath indexPath:IndexPath) {
        buttonDelete.layer.cornerRadius = buttonDelete.frame.size.width / 2
        buttonDelete.layer.masksToBounds = true
        
        let image = contact.imageData != nil ? UIImage(data: contact.imageData!) : nil
        if image != nil {
            imageContact.image = image
        } else {
            let abreviation = CQZContactUtil.createAbreviation(forContact: contact)
            let nameLabel = CQZContactUtil.createLabel(withText: abreviation, andSize: imageContact.frame.size, fontSize: 14)
            imageContact.image = CQZContactUtil.createImage(fromLabel: nameLabel)
        }
        
        imageContact.layer.cornerRadius = imageContact.frame.size.width / 2
        imageContact.layer.masksToBounds = true
        
        nameContact.text = "\(contact.givenName) \(contact.familyName)"
        indexPathSelected = indexPath
    }
    
    //MARK:- @IBAction
    @IBAction private func deleteContact(_ sender: UIButton) {
        delegate?.deleteContact(atIndexPath: indexPathSelected)
    }
    
}
