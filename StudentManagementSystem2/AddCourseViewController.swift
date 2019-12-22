//
//  AddCourseViewController.swift
//  StudentManagementSystem2
//
//  Created by Nabil Haffar on 10/17/19.
//  Copyright © 2019 Nabil Haffar. All rights reserved.
//
import UIKit
import Foundation
import CoreData

class CourseDetailViewController : UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var departmentCodeTF: UITextField!
    @IBOutlet weak var courseNumberTF: UITextField!
    @IBOutlet weak var courseNameTF: UITextField!
    @IBOutlet weak var daysItmeetsTF: UITextField!
    @IBOutlet weak var timeTF: UITextField!
    public var changedCourseIndex: Int?
      public var editting: Int! = 0
     let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editItem))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (editting == 1){
            UnlockEntries()
        }
        else if (editting == 0) {
        lockEntries()
        }
        navigationItem.rightBarButtonItem = editButton
        
        configureView();
    }
    @objc func editItem(){
         UnlockEntries()
        
         
     }
    @IBAction func saveBtnActionHandler(_ sender: UIButton) {
        if(changedCourseIndex == nil) {
                       lockEntries()
                   }
        if (errorCheckInput()){
             let fetchRequest:NSFetchRequest<Course> = Course.fetchRequest()
            do
               {
                let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
            
                searchResults[changedCourseIndex!].departmentCode = departmentCodeTF.text!
                searchResults[changedCourseIndex!].courseNumber = courseNumberTF.text!
                searchResults[changedCourseIndex!].daysItMeets = daysItmeetsTF.text!
                searchResults[changedCourseIndex!].time = timeTF.text!
                
                searchResults[changedCourseIndex!].name = courseNameTF.text!

                DatabaseController.saveContext()
                lockEntries()
                editting = 0
                         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                }
               catch{
                print("Error Saving Changes")
                }
         
        }
        else{
            let alert = UIAlertController(title: "Title", message: "Error adding Course. Please complete missing fields.", preferredStyle: UIAlertController.Style.alert)
                       alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                       self.present(alert, animated: true, completion: nil)
            
        }
       }
    func errorCheckInput()->Bool{
        return (!departmentCodeTF.text!.isEmpty && !courseNameTF!.text!.isEmpty && !courseNameTF.text!.isEmpty && !daysItmeetsTF.text!.isEmpty && !timeTF.text!.isEmpty)
        
    }
  
    @IBAction func cancelBtn(_ sender: Any) {

           lockEntries()
           
       }
    var detailItem: Course? {
           didSet {
               // Update the view.
           //    nameLbl?.text =
               self.loadView()
               configureView()
           }
       }
       func configureView() {
           // Update the user interface for the detail item.
           if let detail = detailItem {
               if let label = departmentCodeTF {
                   label.text = "\( detail.departmentCode!)"
               }
               if let label = courseNumberTF {
                       label.text = "\(detail.courseNumber!)"
                   }
               if let label = courseNameTF{
                   label.text = "\(detail.name!)"
                   }
               if let label =  daysItmeetsTF{
                   label.text =  "\(detail.daysItMeets!)"
                   }
            if let label = timeTF{
                label.text = "\(detail.time!)"
            }
        
           }
    }
    func lockEntries (){
        
        courseNameTF.isEnabled = false
        courseNumberTF.isEnabled = false
        departmentCodeTF.isEnabled = false
        timeTF.isEnabled = false
        daysItmeetsTF.isEnabled = false
        saveButton.isEnabled = false
        editButton.isEnabled = true
        
    }
    func UnlockEntries (){
             courseNameTF.isEnabled = true
           courseNumberTF.isEnabled = true
           departmentCodeTF.isEnabled = true
           timeTF.isEnabled = true
           daysItmeetsTF.isEnabled = true
        saveButton.isEnabled = true
        editButton.isEnabled = false
    }
}
