//
//  CQZContactManger.swift
//  CQZContactManger
//
//  Created by Christian Quicano on 3/18/17.
//  Copyright © 2017 ca9z. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

open class CQZContactManger: NSObject {
    
    //MARK:- public properties
    open static let shared = CQZContactManger()
    
    //MARK:- fileprivate properties
    fileprivate let contactsStore = CNContactStore()
    fileprivate let contactPicker = CNContactPickerViewController()
    
    fileprivate var completeSelection:((_ contacts:[CNContact]) -> ())?
    
    //MARK:- override methods
    @objc fileprivate override init(){
        super.init()
        
        contactPicker.delegate = self
    }
    
    //MARK:- public methods
    open func requestForAccess(completionHandler:@escaping (_ access:Bool)->()) {
        //validate authorization
        let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
        if authorizationStatus != .authorized {
            contactsStore.requestAccess(for: .contacts, completionHandler: { (access, error) in
                completionHandler(access)
            })
        } else {
            completionHandler(true)
        }
    }
    
    open func showContactsSelectionDefault(inViewController viewController:UIViewController?, completeSelection:@escaping (_ contacts:[CNContact]) -> ()) {
        self.completeSelection = completeSelection
        viewController?.present(contactPicker, animated: true, completion: nil)
    }
    
    open func showContactsSelectionCustom(inViewController viewController:UIViewController?, completeSelection:@escaping (_ contacts:[CNContact]) -> ()) {
//        let contactsViewController = CQZContactsSelectorViewController()
        let contactsViewController = CQZContactsSelectorViewController(nibName: kCQZContactsSelectorViewController, bundle: nil)
        contactsViewController.completeSelection = completeSelection
        let nav = UINavigationController(rootViewController: contactsViewController)
        nav.navigationBar.isTranslucent = false
        viewController?.present(nav, animated: true, completion: nil)
    }
    
    open func getAllContacts() -> [CNContact] {
        
        //Keys to fecth
        let keys:[CNKeyDescriptor] = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactEmailAddressesKey as CNKeyDescriptor,
            CNContactPhoneNumbersKey as CNKeyDescriptor,
            CNContactThumbnailImageDataKey as CNKeyDescriptor,
            CNContactImageDataKey as CNKeyDescriptor,
            CNContactImageDataAvailableKey as CNKeyDescriptor
        ]
        
        //All the containers
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactsStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }
        
        //result
        var contacts = [CNContact]()
        
        //get all contacts
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            do {
                let containerResult = try contactsStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keys)
                contacts.append(contentsOf: containerResult)
            } catch {
                print("Error fetching results for container")
            }
        }
        
        return contacts
    }

}

//MARK:- CNContactPickerDelegate methods
extension CQZContactManger:CNContactPickerDelegate {
    
    public func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        completeSelection?(contacts)
    }
    
}
