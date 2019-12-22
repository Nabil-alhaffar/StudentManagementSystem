//
//  addStudentViewController.swift
//  StudentManagementSystem2
//
//  Created by Nabil Haffar on 10/9/19.
//  Copyright © 2019 Nabil Haffar. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class StudentDetailViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var idTF: UITextField!
    @IBOutlet weak var streetAddressTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var stateTf: UITextField!
    @IBOutlet weak var zipCodeTF: UITextField!
    @IBOutlet weak var emailAddressTF: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var addImgBtn: UIButton!
    public var changedStudentIndex: Int?
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
        
        if(changedStudentIndex == nil) {
            lockEntries()
        }
        else {
            if (errorCheckInput()){
                let fetchRequest:NSFetchRequest<Student> = Student.fetchRequest()
                do
                {
                    let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
                    
                    searchResults[changedStudentIndex!].firstName = firstNameTF.text
                    searchResults[changedStudentIndex!].lastName = lastNameTF.text
                    searchResults[changedStudentIndex!].id_number = idTF.text!
                    searchResults[changedStudentIndex!].streetAddress = streetAddressTF.text
                    searchResults[changedStudentIndex!].city = cityTF.text
                    searchResults[changedStudentIndex!].state = stateTf.text
                    searchResults[changedStudentIndex!].zipCode = zipCodeTF.text
                    searchResults[changedStudentIndex!].email = emailAddressTF.text
                    searchResults[changedStudentIndex!].phoneNumber = phoneNumberTF.text
                    searchResults[changedStudentIndex!].picture = imgView.image?.jpegData(compressionQuality: 1.0) as NSData?
                    
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
    
    @IBAction func addImage(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        actionSheet.popoverPresentationController?.sourceView = self.view
        actionSheet.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction)in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }else{
                print ("Camera is not available")
            }
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action: UIAlertAction)in imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
            
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imgView.image = image
        picker.dismiss(animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
    func errorCheckInput()->Bool{
        return (!firstNameTF.text!.isEmpty && !lastNameTF.text!.isEmpty && !streetAddressTF.text!.isEmpty && !cityTF.text!.isEmpty && !stateTf.text!.isEmpty && !zipCodeTF.text!.isEmpty && !phoneNumberTF.text!.isEmpty && !emailAddressTF.text!.isEmpty && imgView.image != nil && !idTF.text!.isEmpty)
        
    }
    @IBAction func cancelBtn(_ sender: Any) {
        
        lockEntries()
        
    }
    var detailItem: Student? {
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
            if let label = firstNameTF {
                firstNameTF.text = "\(detail.firstName!) "
            }
            if let label = lastNameTF{
                lastNameTF.text = "\(detail.lastName!)"
            }
            if let label = idTF {
                label.text = "\(detail.id_number)"
            }
            if let label = streetAddressTF {
                label.text = "\(detail.streetAddress!)"
            }
            if let label = cityTF {
                label.text = "\(detail.city!)"
            }
            if let label = stateTf {
                label.text = "\(detail.state!)"
            }
            if let label = zipCodeTF {
                label.text = "\(detail.zipCode!)"
            }
            if let label = emailAddressTF {
                label.text = "\(detail.email!)"
            }
            if let label = phoneNumberTF{
                label.text = "\(detail.phoneNumber!)"
            }
            if let imageView = imgView{
                imageView.image = UIImage(data: detail.picture! as Data)
            }
        }
    }
    func lockEntries (){
        
        firstNameTF.isEnabled = false
        lastNameTF.isEnabled = false
        idTF.isEnabled = false
        streetAddressTF.isEnabled = false
        cityTF.isEnabled = false
        zipCodeTF.isEnabled = false
        stateTf.isEnabled  = false
        emailAddressTF.isEnabled = false
        phoneNumberTF.isEnabled = false
        addImgBtn.isEnabled = false
        saveButton.isEnabled = false
        editButton.isEnabled = true
        
    }
    func UnlockEntries (){
        firstNameTF.isEnabled = true
        lastNameTF.isEnabled = true
        idTF.isEnabled = true
        streetAddressTF.isEnabled = true
        cityTF.isEnabled = true
        zipCodeTF.isEnabled = true
        stateTf.isEnabled  = true
        emailAddressTF.isEnabled = true
        phoneNumberTF.isEnabled = true
        addImgBtn.isEnabled = true
        saveButton.isEnabled = true
        editButton.isEnabled = false
    }
}
