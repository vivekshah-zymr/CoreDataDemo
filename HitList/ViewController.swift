//
//  ViewController.swift
//  HitList
//
//  Created by Vivek Shah on 4/5/17.
//  Copyright © 2017 Vivek Shah. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tblViewMain: UITableView!
    var people: [NSManagedObject] = []
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "The List"
        tblViewMain.register(UITableViewCell.self,
                             forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear( animated)
        
        let managedContext = AppDelegate.shared().getManagedContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        do {
            people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("could not fetch \(error) \(error.userInfo)")
        }
        tblViewMain.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView Delegate and Datasource Methods
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            let cell =
                tableView.dequeueReusableCell(withIdentifier: "Cell",
                                              for: indexPath)
            let person = people[indexPath.row]
            
            let firstName : String? = person.value(forKeyPath: "firstName") as? String
            let lastName = person.value(forKeyPath: "lastName") as? String
            let contactNo = person.value(forKeyPath: "contactNo") as? String
            cell.textLabel?.text = "\(firstName!) \(lastName!) \(contactNo!)"
            return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let person = people[indexPath.row]
            let managedContext = AppDelegate.shared().getManagedContext()
            managedContext.delete(person)
            do {
                try managedContext.save()
                self.navigationController?.popViewController(animated: true)
            }catch let error as NSError{
                print("Could not save \(error) \(error.userInfo)")
            }
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
            
            do {
                people = try managedContext.fetch(fetchRequest)
            } catch let error as NSError {
                print("could not fetch \(error) \(error.userInfo)")
            }
            tblViewMain.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let person = people[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FormViewController") as! FormViewController
        vc.personDetails = person
        navigationController?.pushViewController(vc,animated: true)
    }
}


