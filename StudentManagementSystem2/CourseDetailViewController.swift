//
//  CourseDetailViewController.swift
//  StudentManagementSystem2
//
//  Created by Nabil Haffar on 10/20/19.
//  Copyright © 2019 Nabil Haffar. All rights reserved.
//



import Foundation
import UIKit
import CoreData
class CourseDetailViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    @IBOutlet weak var departmentCodeTF: UITextField!
    @IBOutlet weak var courseNumberTF: UITextField!
    @IBOutlet weak var courseNameTF: UITextField!
    @IBOutlet weak var daysItMeetsTF: UITextField!
    @IBOutlet weak var timeTF: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
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
        else {
            if (errorCheckInput()){
                let fetchRequest:NSFetchRequest<Course> = Course.fetchRequest()
                do
                {
                    let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
                    
                    searchResults[changedCourseIndex!].departmentCode = departmentCodeTF.text
                    searchResults[changedCourseIndex!].name = courseNameTF.text
                    searchResults[changedCourseIndex!].courseNumber = courseNumberTF.text!
                    searchResults[changedCourseIndex!].daysItMeets = daysItMeetsTF.text
                    searchResults[changedCourseIndex!].time = timeTF.text
                    
                    DatabaseController.saveContext()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                    sender.isEnabled = false
                    editButton.isEnabled = true
                    editting = 0
                    lockEntries()
                }
                catch{
                    print("Error Saving Changes")
                }
                
            }
            else{
                let alert = UIAlertController(title: "Title", message: "Error Saving Changes. Please complete missing fields.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            
        }
        
        
        
    }
    
    
    func errorCheckInput()->Bool{
        return (!courseNameTF.text!.isEmpty && !courseNumberTF.text!.isEmpty && !departmentCodeTF.text!.isEmpty && !daysItMeetsTF.text!.isEmpty && !timeTF.text!.isEmpty )
        
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
            if let label = courseNameTF {
                label.text = "\(detail.name!)"
            }
            if let label = departmentCodeTF{
                label.text = "\(detail.departmentCode!)"
            }
            if let label = courseNumberTF {
                label.text = "\(detail.courseNumber!)"
            }
            if let label = daysItMeetsTF {
                label.text = "\(detail.daysItMeets!)"
            }
            if let label = timeTF {
                label.text = "\(detail.time!)"
            }
            
            
        }
        
    }
    func lockEntries (){
        
        departmentCodeTF.isEnabled = false
        daysItMeetsTF.isEnabled = false
        courseNameTF.isEnabled = false
        courseNumberTF.isEnabled = false
        timeTF.isEnabled = false
        
        saveButton.isEnabled = false
        editButton.isEnabled = true
        
    }
    func UnlockEntries (){
        departmentCodeTF.isEnabled = true
        daysItMeetsTF.isEnabled = true
        courseNameTF.isEnabled = true
        courseNumberTF.isEnabled = true
        saveButton.isEnabled = true
        editButton.isEnabled = false
    }
}
