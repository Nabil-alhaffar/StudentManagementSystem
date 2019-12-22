//
//  StudentViewController.swift
//  StudentManagementSystem2
//
//  Created by Nabil Haffar on 10/7/19.
//  Copyright © 2019 Nabil Haffar. All rights reserved.
//
import UIKit
import CoreData
import Foundation



class StudentsMasterViewController : UIViewController, UITableViewDataSource ,NSFetchedResultsControllerDelegate{
    private var students = [Student]()
    @IBOutlet var tableView: UITableView!
    var detailViewController: StudentDetailViewController? = nil
    var objects = [Any]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(fetch), name: NSNotification.Name(rawValue: "load"), object: nil)
        
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        _ = self.editButtonItem
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? StudentDetailViewController
            split.preferredDisplayMode = .allVisible
        }
        
        let fetchRequest:NSFetchRequest<Student> = Student.fetchRequest()
        do{
            let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
            print ("Number of results: \(searchResults.count) ")
            
            for result in searchResults as [Student]{
                print (" \(result.firstName!) \(result.lastName!) is " )
                
                self.students = searchResults
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
        //load data here
        let fetchRequest:NSFetchRequest<Student> = Student.fetchRequest()
        do{
            let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
            print ("Number of results: \(searchResults.count) ")
            
            for result in searchResults as [Student]{
                print (" \(result.firstName!) \(result.lastName!) is " )
                
                self.students = searchResults
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
                }
            }
            
        }
        catch{
            print ("Error")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let fetchRequest:NSFetchRequest<Student> = Student.fetchRequest()
        do{
            let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
            print ("Number of results: \(searchResults.count) ")
            
            for result in searchResults as [Student]{
                print (" \(result.firstName!) \(result.lastName!) is " )
                
                self.students = searchResults
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
        if segue.identifier == "showDetailStudent" {
            if let indexPath = tableView.indexPathForSelectedRow{
                let student = students[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! StudentDetailViewController
                controller.changedStudentIndex = indexPath.row
                controller.detailItem = student
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
                
                let student = students[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! StudentDetailViewController
                controller.detailItem = student
                controller.editting = 1
                controller.changedStudentIndex = indexPath.row
                
                print ("segue2")
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    @objc
    func addItem (_sender: Any){
        
        let student:Student = NSEntityDescription.insertNewObject(forEntityName: "Student" , into: DatabaseController.persistentContainer.viewContext) as! Student
        student.firstName = "new "
        student.lastName = "student"
        student.id_number = "####"
        student.campusAddress = ""
        student.streetAddress = ""
        student.city = ""
        student.state = ""
        student.zipCode = ""
        student.phoneNumber = ""
        student.email = ""
        student.picture = UIImage(named: "StudentIcon")?.jpegData(compressionQuality: 1.0) as NSData?
        DatabaseController.saveContext()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        performSegue(withIdentifier: "addItem", sender: students.count)
    }
    private func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        let rowToMove = students[fromIndexPath.row]
        students.remove(at: fromIndexPath.row)
        students.insert(rowToMove, at: toIndexPath.row)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell") as? StudentCell
            else {
                print ("error creating cell")
                return UITableViewCell()
                
        }
        cell.nameLbl.text = students[indexPath.row].firstName! + students[indexPath.row].lastName!
        if(students[indexPath.row].picture != nil){
            cell.studentImgView.image = UIImage(data: students[indexPath.row].picture! as Data)
        }
        cell.idNumberLbl.text = students[indexPath.row].id_number
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let student = students[indexPath.row]
            students.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            let context:NSManagedObjectContext = DatabaseController.getContext()
            context.delete(student as NSManagedObject)
            DatabaseController.saveContext()
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    
}




