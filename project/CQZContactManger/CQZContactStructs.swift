//
//  CQZContactStructs.swift
//  CQZContactManger
//
//  Created by Christian Quicano on 3/20/17.
//  Copyright © 2017 ca9z. All rights reserved.
//

import Foundation
import Contacts

public struct ContactGroup {
    
    public let indexTitle:String
    public let contacts:[CNContact]
    
    public init(withIndexTitle indexTitle:String, contacts:[CNContact]) {
        self.indexTitle = indexTitle
        self.contacts = contacts
    }
    
}

