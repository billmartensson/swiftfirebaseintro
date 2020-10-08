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
        
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()

        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        
        let todoimageRef = storageRef.child("todoimages").child(thetodoinfo.firebaseid)
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        todoimageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
          if let error = error {
            // Uh-oh, an error occurred!
            print("Kan inte hämta bild")
          } else {
            // Data is returned
            print("Yey. Kunde hämta bild")
            let gottenimage = UIImage(data: data!)
            self.todoImageview.image = gottenimage
          }
        }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        parentVC.loadTodo()
    }

    
    @IBAction func saveTitle(_ sender: Any) {
        
        
        
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
