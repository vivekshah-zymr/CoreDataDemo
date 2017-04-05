//
//  FormViewController.swift
//  HitList
//
//  Created by Vivek Shah on 4/5/17.
//  Copyright © 2017 Vivek Shah. All rights reserved.
//

import UIKit
import CoreData

class FormViewController: UIViewController {
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtContactNo: UITextField!
    
    var personDetails: NSManagedObject?
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Form"
        if let person = personDetails{
            txtFirstName?.text = person.value(forKeyPath: "firstName") as? String
            txtLastName?.text = person.value(forKeyPath: "lastName") as? String
            txtContactNo?.text = person.value(forKeyPath: "contactNo") as? String
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Tap Events
    @IBAction func didTapSave(_ sender: Any) {
        
        let managedContext = AppDelegate.shared().getManagedContext()
        
        if let person = personDetails {
            //update exsisting
            person.setValue(txtFirstName.text, forKey: "firstName")
            person.setValue(txtLastName.text, forKey: "lastName")
            person.setValue(txtContactNo.text, forKey: "contactNo")
        }
        else{
            //save new entity
            let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
            let person = NSManagedObject(entity: entity, insertInto: managedContext)
            person.setValue(txtFirstName.text, forKey: "firstName")
            person.setValue(txtLastName.text, forKey: "lastName")
            person.setValue(txtContactNo.text, forKey: "contactNo")
        }
        do {
            try managedContext.save()
            self.navigationController?.popViewController(animated: true)
        }catch let error as NSError{
            managedContext.rollback()
            print("Could not save \(error) \(error.userInfo)")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func didTapStaticData(_ sender: Any) {
        
        var arrayData = [PersonnBean]()
        for var j in 0..<8{
            var item = PersonnBean();
            item.firstName = "Test fname \(j)"
            item.lastName = "Test lname \(j)"
            if j%2==0 {
                item.contactNo = "999"
            }
            else{
                item.contactNo = "478 \(j)"
            }
            arrayData.append(item);
        }
        print(arrayData);
        
        let managedContext = AppDelegate.shared().getManagedContext()
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        
        for var i in 0..<8{
            let item: PersonnBean = arrayData[i] as PersonnBean
            
            let person = NSManagedObject(entity: entity, insertInto: managedContext)
            person.setValue(item.firstName, forKey: "firstName")
            person.setValue(item.lastName, forKey: "lastName")
            person.setValue(item.contactNo, forKey: "contactNo")
        }
        
        do {
            try managedContext.save()
            self.navigationController?.popViewController(animated: true)
        }catch let error as NSError{
            managedContext.rollback()
            print("Could not save \(error) \(error.userInfo)")
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
}
