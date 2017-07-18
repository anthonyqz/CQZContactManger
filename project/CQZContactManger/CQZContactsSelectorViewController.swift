//
//  CQZContactsSelectorViewController.swift
//  CQZContactManger
//
//  Created by Christian Quicano on 3/19/17.
//  Copyright © 2017 ca9z. All rights reserved.
//

import UIKit
import Contacts

class CQZContactsSelectorViewController: UIViewController {
    
    //MARK:- public
    var completeSelection:((_ contacts:[CNContact]) -> ())?
    
    //MARK:- @IBOutlet properties
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var contactsSelectedView: UIView!
    @IBOutlet fileprivate weak var searchBar: UISearchBar!
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    @IBOutlet fileprivate weak var heightContactsSelectedView: NSLayoutConstraint!
    
    fileprivate var cancelButton:UIBarButtonItem?
    fileprivate var doneButton:UIBarButtonItem?
    
    //MARK:- fileprivate properties
    fileprivate var contacts = CQZContactManger.shared.getAllContacts()
    fileprivate var contactsGroup = [ContactGroup]()
    fileprivate var contactsFiltered = [CNContact]()
    fileprivate var indexesTitles = [String]()
    fileprivate var contactsSelected = [CNContact]()
    fileprivate var isSearchActivated = false
    
    //MARK:- UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        register(nibs: [kCQZContactsSelectorCell], inTableView: tableView, inCollectionView: nil)
        register(nibs: [kCQZContactSelectedCell], inTableView: nil, inCollectionView: collectionView)
        
        configureBarButtons()
        animateCollectionView(expand: false, animate: false)
        
        //sort contacts
        contactsGroup = sortedAlphabetically(contacts:contacts)
        //add index Titles
        for group in contactsGroup {
            indexesTitles.append(group.indexTitle)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    //MARK:- IBAction
    
    //MARK:- fileprivate
    fileprivate func sortedAlphabetically(contacts:[CNContact]) -> [ContactGroup] {
        var contacts = contacts
        var result = [ContactGroup]()
        for indice in CQZArrayAlphabet {
            let group = contacts.filter(){ $0.givenName.hasPrefix("\(indice.lowercased())") || $0.familyName.hasPrefix("\(indice.lowercased())") || $0.givenName.hasPrefix("\(indice.uppercased())") || $0.familyName.hasPrefix("\(indice.uppercased())") }
            contacts = contacts.filter(){ !group.contains($0) }
            result.append(ContactGroup(indexTitle: indice.uppercased(), contacts: group))
        }
        //clean data
        result = result.filter(){ $0.contacts.count > 0 }
        return result
    }
    
    fileprivate func filter(contacts:[CNContact], bySearchText text:String) -> [CNContact] {
        return contacts.filter(){ $0.givenName.contains(text) || $0.familyName.contains(text) }
    }
    
    //MARK:- private
    private func configureBarButtons() {
        //configure BarButtonItem
        cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(CQZContactsSelectorViewController.dismissViewController))
        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(CQZContactsSelectorViewController.doneAction))
        //configure navigationItem
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc private func dismissViewController() {
        completeSelection?([])
        dismiss(animated: true, completion: nil)
    }
    
    @objc func doneAction(_ sender: UIBarButtonItem) {
        completeSelection?(contactsSelected)
        dismiss(animated: true, completion: nil)
    }
    
    private func register(nibs:[String], inTableView tableView:UITableView?, inCollectionView collectionView:UICollectionView?) {
        for nibName in nibs {
            let nib = UINib(nibName: nibName, bundle: Bundle(for: CQZContactsSelectorViewController.self));
            tableView?.register(nib, forCellReuseIdentifier: nibName)
            collectionView?.register(nib, forCellWithReuseIdentifier: nibName)
        }
    }
    
    fileprivate func animateCollectionView(expand:Bool, animate:Bool) {
        //change contactsSelectedView
        let duration:TimeInterval = (animate ? 0.3 : 0)
        let height:CGFloat = expand ? 90 : 0
        if self.heightContactsSelectedView.constant != height {
            self.heightContactsSelectedView.constant = height
            UIView.animate(withDuration:duration ) { [weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }
    
}

//MARK:- UITableViewDataSource, UITableViewDelegate
extension CQZContactsSelectorViewController:UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isSearchActivated ? 1 : contactsGroup.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchActivated ? contactsFiltered.count : contactsGroup[section].contacts.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return isSearchActivated ? nil : contactsGroup[section].indexTitle
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return isSearchActivated ? nil : indexesTitles
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let section = indexPath.section
        let cell = tableView.dequeueReusableCell(withIdentifier: kCQZContactsSelectorCell, for: indexPath) as! CQZContactsSelectorCell
        let contact = isSearchActivated ? contactsFiltered[row] : contactsGroup[section].contacts[row]
        cell.accessoryType = contactsSelected.contains(contact) ? .checkmark : .none
        cell.configureCell(withContact: contact)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let section = indexPath.section
        let contact = isSearchActivated ? contactsFiltered[row] : contactsGroup[section].contacts[row]
        if !contactsSelected.contains(contact) {
            contactsSelected.append(contact)
            collectionView.reloadData()
        } else {
            if let index = contactsSelected.index(of: contact) {
                contactsSelected.remove(at: index)
                collectionView.reloadData()
            }
        }
        animateCollectionView(expand: (contactsSelected.count == 0 ? false : true), animate: true)
        //scroll to botton
        if contactsSelected.count > 0 {
            collectionView.selectItem(at: IndexPath(row: contactsSelected.count - 1, section: 0), animated: true, scrollPosition: .right)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}

//MARK:- UICollectionViewDelegate, UICollectionViewDataSource
extension CQZContactsSelectorViewController:UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contactsSelected.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCQZContactSelectedCell, for: indexPath) as! CQZContactSelectedCell
        let contact = contactsSelected[row]
        cell.configureCell(withContact: contact, atIndexPath: indexPath)
        cell.delegate = self
        return cell
    }
    
    //MARK:- Size collection view
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 74, height: 90)
    }
    
    
    
}

//MARK:- CQZContactSelectedCellDelegate
extension CQZContactsSelectorViewController:CQZContactSelectedCellDelegate {
    
    func deleteContact(atIndexPath indexPath: IndexPath?) {
        guard let indexPath = indexPath else {
            return
        }
        let row = indexPath.row
        let contact = contactsSelected[row]
        contactsSelected.remove(at: row)
        collectionView.reloadData()
        //reload cell
        var sectionGroup = 0
        for group in contactsGroup {
            if let rowTable = group.contacts.index(of: contact) {
                tableView.reloadRows(at: [IndexPath(row: rowTable, section: sectionGroup)], with: .automatic)
            }
            sectionGroup += 1
        }
        animateCollectionView(expand: (contactsSelected.count == 0 ? false : true), animate: true)
    }
    
}

//MARK:- UISearchBarDelegate
extension CQZContactsSelectorViewController:UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String)
    {
        searchBar.showsCancelButton = true
        filterBy(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        searchBar.text = ""
        filterBy(searchBar.text ?? "")
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        if searchBar.text?.characters.count == 0 {
            searchBar.showsCancelButton = true
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    private func filterBy(_ searchText:String) {
        isSearchActivated = searchText.characters.count == 0 ? false : true
        contactsFiltered = isSearchActivated ? filter(contacts: contacts, bySearchText: searchText) : []
        tableView.reloadData()
    }
    
}
