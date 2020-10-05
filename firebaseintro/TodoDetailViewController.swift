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

    
    @IBOutlet weak var todoTopLabel: UILabel!
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var todoImageview: UIImageView!
    
    
    var thetodoinfo = [String: Any]()
    
    var parentVC : ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        todoTopLabel.text = thetodoinfo["todotitle"] as! String
        
        if(thetodoinfo["tododone"] as! Bool == true)
        {
            doneButton.backgroundColor = UIColor.green
        } else {
            doneButton.backgroundColor = UIColor.red
        }
        
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()

        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        
        let todoimageRef = storageRef.child("todoimages").child(thetodoinfo["fbkey"] as! String)
        
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

    @IBAction func changeTodoDone(_ sender: Any) {
        
        var ref = Database.database().reference()
        
        if(thetodoinfo["tododone"] as! Bool == true)
        {
            ref.child("todomoreusers").child(Auth.auth().currentUser!.uid).child(thetodoinfo["fbkey"] as! String).child("tododone").setValue(false)
            doneButton.backgroundColor = UIColor.red
            thetodoinfo["tododone"] = false
        } else {
            ref.child("todomoreusers").child(Auth.auth().currentUser!.uid).child(thetodoinfo["fbkey"] as! String).child("tododone").setValue(true)
            doneButton.backgroundColor = UIColor.green
            thetodoinfo["tododone"] = true
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
        let todoimageRef = storageRef.child("todoimages").child(thetodoinfo["fbkey"] as! String)
        
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
