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
class ProfessorDetailViewController : UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var streetAddressTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var stateTF: UITextField!
    @IBOutlet weak var zipCodeTF: UITextField!
    @IBOutlet weak var emailAddressTF: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var officeAddressTF: UITextField!
    @IBOutlet weak var addImgBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    public var changedProfessorIndex: Int?
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
        if (changedProfessorIndex == nil){
            lockEntries()
        }
        else{
            if(errorCheckInput()){
                let fetchRequest:NSFetchRequest<Professor> = Professor.fetchRequest()
                do
                {
                    let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
                    
                    searchResults[changedProfessorIndex!].firstName = firstNameTF.text
                    searchResults[changedProfessorIndex!].lastName = lastNameTF.text
                    searchResults[changedProfessorIndex!].streetAddress = streetAddressTF.text
                    searchResults[changedProfessorIndex!].city = cityTF.text
                    searchResults[changedProfessorIndex!].state = stateTF.text
                    searchResults[changedProfessorIndex!].zipCode = zipCodeTF.text
                    searchResults[changedProfessorIndex!].email = emailAddressTF.text
                    searchResults[changedProfessorIndex!].officeAddress = officeAddressTF.text
                    searchResults[changedProfessorIndex!].picture = imgView.image?.jpegData(compressionQuality: 1.0) as NSData?
                    
                    DatabaseController.saveContext()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                    editting = 0
                    lockEntries()
                }
                catch{
                    print("Error Saving Changes")
                    
                }
            }
            else{
                let alert = UIAlertController(title: "Title", message: "Error adding Professor. Please complete missing fields.", preferredStyle: UIAlertController.Style.alert)
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
        //    firstNameTF.text = nil
        return (!firstNameTF.text!.isEmpty && !lastNameTF.text!.isEmpty && !streetAddressTF.text!.isEmpty && !cityTF.text!.isEmpty && !stateTF.text!.isEmpty && !zipCodeTF.text!.isEmpty && !officeAddressTF.text!.isEmpty && !emailAddressTF.text!.isEmpty && imgView.image != nil)
        
    }
    @IBAction func cancelBtn(_ sender: Any) {
        lockEntries()
        
    }
    var detailItem: Professor? {
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
                label.text = "\(detail.firstName!)"
            }
            if let detail = detailItem {
                if let label = lastNameTF {
                    label.text = "\(detail.lastName!)"
                }
                if let label = streetAddressTF {
                    label.text = "\(detail.streetAddress!)"
                }
                if let label = cityTF{
                    label.text = "\(detail.city!)"
                }
                if let label = officeAddressTF{
                    label.text = "\(detail.officeAddress!)"
                }
                if let label = zipCodeTF{
                    label.text = "\(detail.zipCode!)"
                }
                if let label = stateTF{
                    label.text = "\(detail.state!)"
                }
                if let label = emailAddressTF {
                    label.text = "\( detail.email!)"
                }
                if let imageView = imgView{
                    imageView.image = UIImage(data: detail.picture as! Data)
                }
                
            }
        }
        
    }
    func lockEntries (){
        
        firstNameTF.isEnabled = false
        lastNameTF.isEnabled = false
        streetAddressTF.isEnabled = false
        cityTF.isEnabled = false
        stateTF.isEnabled = false
        zipCodeTF.isEnabled = false
        emailAddressTF.isEnabled = false
        officeAddressTF.isEnabled = false
        addImgBtn.isEnabled = false
        saveBtn.isEnabled = false
        editButton.isEnabled = true
        
    }
    func UnlockEntries (){
        firstNameTF.isEnabled = true
        lastNameTF.isEnabled = true
        streetAddressTF.isEnabled = true
        cityTF.isEnabled = true
        zipCodeTF.isEnabled = true
        stateTF.isEnabled  = true
        emailAddressTF.isEnabled = true
        officeAddressTF.isEnabled = true
        addImgBtn.isEnabled = true
        saveBtn.isEnabled = true
        editButton.isEnabled = false
    }
}
