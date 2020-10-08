//
//  TodoDetailViewController.swift
//  firebaseintro
//
//  Created by Bill Martensson on 2020-09-28.
//

import UIKit
import Firebase
import FirebaseStorage

class TodoDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var titleTextfield: UITextField!
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var todoImageview: UIImageView!
    
    var thetodoinfo = TodoItem()
    
    var parentVC : ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        titleTextfield.text = thetodoinfo.todotitle
        
        if(thetodoinfo.tododone == true)
        {
            doneButton.backgroundColor = UIColor.green
        } else {
            doneButton.backgroundColor = UIColor.red
        }
        
        thetodoinfo.getImage() { theimage in
            todoImageview.image = theimage
        }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        parentVC.loadTodo()
    }

    
    @IBAction func saveTitle(_ sender: Any) {
        
        thetodoinfo.todotitle = titleTextfield.text!
        
        thetodoinfo.save()
    }
    
    
    
    @IBAction func changeTodoDone(_ sender: Any) {
        thetodoinfo.changeDone()
        if(thetodoinfo.tododone == true)
        {
            doneButton.backgroundColor = UIColor.green
        } else {
            doneButton.backgroundColor = UIColor.red
        }
    }
    
    
    @IBAction func uploadImage(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let pickedImage = info[.originalImage] as! UIImage

        self.dismiss(animated: true, completion: nil)
        
        
        let jpegImage = pickedImage.jpegData(compressionQuality: 0.8)
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let todoimageRef = storageRef.child("todoimages").child(thetodoinfo.firebaseid)
        
        let uploadTask = todoimageRef.putData(jpegImage!, metadata: nil) { (metadata, error) in
          guard let metadata = metadata else {
            // Uh-oh, an error occurred!
            print("Upload error. Något gick fel")
            return
          }
            
            // Upload gick bra
            print("Upload ok. Hurra.")
            self.todoImageview.image = pickedImage
        }
        
    }
    
}
