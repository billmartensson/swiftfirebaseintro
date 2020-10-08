//
//  TodoItem.swift
//  firebaseintro
//
//  Created by Bill Martensson on 2020-10-08.
//

import Foundation
import Firebase
import FirebaseStorage

class TodoItem
{
    var todotitle = ""
    var tododone = false
    var firebaseid = ""
    
    func changeDone()
    {
        let ref = Database.database().reference()
        
        if(tododone == true)
        {
            tododone = false
        } else {
            tododone = true
        }

        ref.child("todomoreusers").child(Auth.auth().currentUser!.uid).child(firebaseid).child("tododone").setValue(tododone)

    }
    
    func save()
    {
        let ref = Database.database().reference()
        
        let newtodo : [String : Any] = ["todotitle": todotitle, "tododone": tododone]
        
        let todoUserRef = ref.child("todomoreusers").child(Auth.auth().currentUser!.uid)
        
        if(firebaseid == "")
        {
            // Har inget id. Skapa ny
            todoUserRef.childByAutoId().setValue(newtodo)
        } else {
            // Har id. Spara över.
            todoUserRef.child(firebaseid).setValue(newtodo)
        }
        
    }
    
    func getImage(completion: @escaping (_ theimage : UIImage?) -> Void)
    {
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()

        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        
        let todoimageRef = storageRef.child("todoimages").child(firebaseid)
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        todoimageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
          if let error = error {
            // Uh-oh, an error occurred!
            print("Kan inte hämta bild")
            
            completion(nil)
          } else {
            // Data is returned
            print("Yey. Kunde hämta bild")
            let gottenimage = UIImage(data: data!)
            
            completion(gottenimage)
          }
        }
        
    }
    
    
}
