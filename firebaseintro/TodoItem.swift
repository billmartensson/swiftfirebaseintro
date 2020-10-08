//
//  TodoItem.swift
//  firebaseintro
//
//  Created by Bill Martensson on 2020-10-08.
//

import Foundation
import Firebase

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
    
    
}
