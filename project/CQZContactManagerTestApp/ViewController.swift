//
//  ViewController.swift
//  CQZContactManagerTestApp
//
//  Created by Christian Quicano on 3/18/17.
//  Copyright © 2017 ca9z. All rights reserved.
//

import UIKit
import CQZContactManger
import Alamofire
import Contacts

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func selectContact(_ sender: Any) {
        
        CQZContactManger.shared.showContactsSelectionCustom(inViewController: self
            , barTintColor: UIColor.green
            , itemTintColor: UIColor.black
            , titleNavigationItem: "Contactos") { (contacts) in
                //send to service test
                let url = "https://miscitas.herokuapp.com/api/doctores/store/pacientes"
                let params = self.createParams(from: contacts)
                
                self.requestPost(toUrl: url
                    , parameters: params
                    , completed: { (success, response) in
                        print(response)
                })
                
                print(contacts.count)
        }
        
    }
    
    func createParams(from contacts:[CNContact]) -> [String:AnyObject] {
        var pacientes = [[String:Any]]()
        var paciente = [String:Any]()
        for contact in contacts {
            paciente["nombre"] = contact.givenName
            paciente["apellido"] = contact.familyName
            //get numbers
            var numbers = [String]()
            for phoneNumber in contact.phoneNumbers {
                numbers.append(phoneNumber.value.stringValue)
            }
            paciente["celular"] = numbers
            //get emails
            var emails = [String]()
            for emailsContact in contact.emailAddresses {
                emails.append(emailsContact.value as String)
            }
            paciente["email"] = emails
            pacientes.append(paciente)
        }
        return ["doctor_id":"58d0983664069e0011b22173" as AnyObject, "pacientes":pacientes as AnyObject]
    }
    
    func requestPost(toUrl url:String, parameters:[String:AnyObject], completed:@escaping (_ success:Bool, _ response:AnyObject?)->()) {
        Alamofire.request(url
            , method: HTTPMethod.post
            , parameters: parameters
            , encoding: JSONEncoding.default
            ).responseJSON { (response) in
                let result = response.result
                if result.isFailure {
                    completed(false, nil)
                }else{
                    do {
                        let itemsResponse = try JSONSerialization.jsonObject(with: response.data!, options: [])
                        completed(true, itemsResponse as AnyObject?)
                    }catch{
                        completed(false, nil)
                    }
                }
        }
    }

}
