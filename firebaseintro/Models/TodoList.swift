//
//  TodoList.swift
//  firebaseintro
//
//  Created by Bill Martensson on 2020-10-22.
//

import Foundation
import Firebase

class TodoList
{
    var todotitle = ""
    var firebaseid = ""
    var owner = false
    
    var items : [TodoItem]?
    
    func save()
    {
        let ref = Database.database().reference()
        
        var newtodo : [String : Any] = ["todotitle": todotitle, "users" : [Auth.auth().currentUser!.uid : ["owner" : true]]]

        let todoUserRef = ref.child("todoadvanced").child("todolists")
        
        if(firebaseid == "")
        {
            // Har inget id. Skapa ny
            todoUserRef.childByAutoId().setValue(newtodo)
        } else {
            // Har id. Spara över.
            todoUserRef.child(firebaseid).setValue(newtodo)
        }
        
    }
    
    func addNewItems(itemtitle : String)
    {
        var newitems = TodoItem()
        newitems.mylist = self
        newitems.todotitle = itemtitle
        newitems.tododone = false
        newitems.save()
    }
    
    func loadTodoItems(completion: @escaping () -> Void)
    {
        let ref = Database.database().reference()
        
        ref.child("todoadvanced").child("todoitems").child(firebaseid).observeSingleEvent(of: .value, with: { [self] (snapshot) in
            
            items = [TodoItem]()
            
            for todothing in snapshot.children
            {
                let todosnapshot = todothing as! DataSnapshot
                                
                let tododict = todosnapshot.value as! [String : Any]
                
                let temptodo = TodoItem()
                temptodo.mylist = self
                temptodo.firebaseid = todosnapshot.key
                temptodo.todotitle = tododict["todotitle"] as! String
                temptodo.tododone = tododict["tododone"] as! Bool
                
                
                items!.append(temptodo)
            }
            completion()
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
