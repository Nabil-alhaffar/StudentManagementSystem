//
//  CourseMasterViewController.swift
//  StudentManagementSystem2
//
//  Created by Nabil Haffar on 10/10/19.
//  Copyright © 2019 Nabil Haffar. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CourseMasterViewController: UITableViewController ,NSFetchedResultsControllerDelegate {
    private var courses = [Course]()
    var detailViewController: CourseDetailViewController? = nil
    
    var objects = [Any]()
    
  //  @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         NotificationCenter.default.addObserver(self, selector: #selector(fetch), name: NSNotification.Name(rawValue: "load"), object: nil)
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
                   let controllers = split.viewControllers
                   detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? CourseDetailViewController
            split.preferredDisplayMode = .allVisible
        }
            let fetchRequest:NSFetchRequest<Course> = Course.fetchRequest()
                   do{
                       let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
                       print ("Number of results: \(searchResults.count) ")
                       
                       
                           
                       self.courses = searchResults
                       DispatchQueue.main.async {
                       self.tableView.reloadData()

                       }
                   }
                   catch{
                       print ("Error")
                   }
    }
    @objc func fetch(notification: NSNotification){
        
        let fetchRequest:NSFetchRequest<Course> = Course.fetchRequest()
        do{
            let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
            print ("Number of results: \(searchResults.count) ")
            self.courses = searchResults
            DispatchQueue.main.async {
            self.tableView.reloadData()
            }
        }
        catch{
            print ("Error")
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           DispatchQueue.main.async {
          self.tableView.reloadData()
           
           }
       }
       
       
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           print("segue1")
           if segue.identifier == "showDetailCourse" {
               if let indexPath = tableView.indexPathForSelectedRow{
                   let course = courses[indexPath.row]
                   let controller = (segue.destination as! UINavigationController).topViewController as! CourseDetailViewController
                controller.changedCourseIndex = indexPath.row
                   controller.detailItem = course
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
             
            let course = courses[indexPath.row]
            let controller = (segue.destination as! UINavigationController).topViewController as! CourseDetailViewController
            controller.detailItem = course
            controller.editting = 1
            controller.changedCourseIndex = indexPath.row

            print ("segue2")
            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
       }
       
       @objc
       func addItem (_sender: Any){
          let course:Course = NSEntityDescription.insertNewObject(forEntityName: "Course" , into: DatabaseController.persistentContainer.viewContext) as! Course
          
          course.departmentCode = ""
          course.courseNumber = ""
             course.name  = "New Course"
          course.daysItMeets = ""
          course.time = ""
             DatabaseController.saveContext()
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
            performSegue(withIdentifier: "addItem", sender: courses.count)
        //           let addCoursePopUpVC = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addCoursesPopUpVC") as! UIViewController
           //addStudentsPopUpVC.modalTransitionStyle = .crossDissolve
          // addStudentsPopUpVC.modalPresentationStyle = .overCurrentContext
         //  self.definesPresentationContext = true
        //   present(addStudentsPopUpVC, animated: true, completion: nil)
//
//           self.addChild(addCoursePopUpVC)
//           addCoursePopUpVC.view.frame = self.view.frame
//           self.view.addSubview (addCoursePopUpVC.view)
//
           
       }
       
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
               return courses.count
           }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell") as? CourseCell
                  else {
                       print ("error creating cell")
                      return UITableViewCell()
                      
                  }
               cell.departmentCodeLbl.text = courses[indexPath.row].departmentCode!
            cell.courseNameLbl.text = courses[indexPath.row].name!
               cell.courseNumberLbl.text = courses[indexPath.row].courseNumber
                  return cell
           }
    override func numberOfSections(in tableView: UITableView) -> Int {
           return 1
       }
     

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            let course = courses[indexPath.row]
            courses.remove(at: indexPath.row)
               tableView.deleteRows(at: [indexPath], with: .fade)
            let context:NSManagedObjectContext = DatabaseController.getContext()
            context.delete(course as NSManagedObject)
            
            DatabaseController.saveContext()
           } else if editingStyle == .insert {
               // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
           }
       }
}

