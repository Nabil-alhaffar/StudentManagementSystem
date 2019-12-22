//
//  ProfessorMasterViewController.swift
//  StudentManagementSystem2
//
//  Created by Nabil Haffar on 10/10/19.
//  Copyright © 2019 Nabil Haffar. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ProfessorMasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    private var professors = [Professor]()
    var detailViewController: ProfessorDetailViewController? = nil
    
    //  @IBOutlet var tableView: UITableView!
    
    var objects = [Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(fetch), name: NSNotification.Name(rawValue: "load"), object: nil)
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(getter: editButtonItem))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem = editButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? ProfessorDetailViewController
            split.preferredDisplayMode = .allVisible
            
            
        }
        let fetchRequest:NSFetchRequest<Professor> = Professor.fetchRequest()
        do{
            let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
            print ("Number of prof results: \(searchResults.count) ")
            
            for result in searchResults as [Professor]{
                print (" \(result.firstName!) \(result.lastName!) is " )
                
                self.professors = searchResults
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
                }
            }
            
        }
        catch{
            print ("Error")
        }
        
    }
    @objc func fetch(notification: NSNotification){
        
        let fetchRequest:NSFetchRequest<Professor> = Professor.fetchRequest()
        do{
            let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
            print ("Number of prof results: \(searchResults.count) ")
            
            for result in searchResults as [Professor]{
                print (" \(result.firstName!) \(result.lastName!) is " )
                
                self.professors = searchResults
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
                }
            }
            
        }
        catch{
            print ("Error")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("segue1")
        if segue.identifier == "showDetailProfessor" {
            if let indexPath = tableView.indexPathForSelectedRow{
                let professor = professors[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! ProfessorDetailViewController
                controller.changedProfessorIndex = indexPath.row
                controller.detailItem = professor
                controller.editting = 0
                
                print ("segue2")
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
            
            
        }
        if segue.identifier == "addItem"{
            
            // Then grab the number of rows in the last section
            let lastRowIndex = self.tableView!.numberOfRows(inSection: 0) - 1
            
            // Now just construct the index path
            let pathToLastRow = NSIndexPath(row: lastRowIndex, section: 0)
            tableView.selectRow(at: pathToLastRow as IndexPath, animated: true, scrollPosition: .none)
            
            if lastRowIndex < 0 { //if invalid row
                return
            }
            if let  indexPath = tableView.indexPathForSelectedRow{
                
                let professor = professors[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! ProfessorDetailViewController
                controller.detailItem = professor
                controller.editting = 1
                controller.changedProfessorIndex = indexPath.row
                
                print ("segue2")
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.tableView.reloadData()
            
        }
    }
    
    @objc
    func addItem (_sender: Any){
        
        let professor:Professor = NSEntityDescription.insertNewObject(forEntityName: "Professor" , into: DatabaseController.persistentContainer.viewContext) as! Professor
        professor.firstName = "new "
        professor.lastName = "professor"
        professor.officeAddress = ""
        professor.streetAddress = ""
        professor.city = ""
        professor.state = ""
        professor.zipCode = ""
        professor.email = ""
        professor.picture = UIImage(named: "ProfessorIcon")?.jpegData(compressionQuality: 1.0) as NSData?
        DatabaseController.saveContext()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        
        performSegue(withIdentifier: "addItem", sender: professors.count)
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return professors.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfessorCell") as? ProfessorCell
            else {
                print ("error creating cell")
                return UITableViewCell()
                
        }
        cell.nameLbl.text = professors[indexPath.row].firstName! + professors[indexPath.row].lastName!
        if(professors[indexPath.row].picture != nil){
            cell.imgView.image = UIImage (data:  professors[indexPath.row].picture as! Data)
        }
        cell.emailAddress.text = professors[indexPath.row].email
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let professor = professors [indexPath.row]
            professors.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            let context:NSManagedObjectContext = DatabaseController.getContext()
            context.delete(professor as NSManagedObject)
            DatabaseController.saveContext()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
}

