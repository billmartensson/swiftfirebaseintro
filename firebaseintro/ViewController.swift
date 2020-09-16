//
//  ViewController.swift
//  firebaseintro
//
//  Created by Bill Martensson on 2020-09-16.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController, UITableViewDataSource {
    
    
    @IBOutlet weak var todoTextfield: UITextField!
    @IBOutlet weak var todoTableview: UITableView!
    
    
    var ref: DatabaseReference!

    var todolist = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        ref = Database.database().reference()
        
        todoTableview.dataSource = self
        
        /*
        self.ref.child("theuser").setValue(["username": "XYZ"])
        
        ref.child("firstname").observeSingleEvent(of: .value, with: { (snapshot) in
          
            var thefirstname = snapshot.value as! String
            
            print(thefirstname)
            
        }) { (error) in
            print(error.localizedDescription)
        }
        */
        
        loadTodo()
        
    }

    func loadTodo()
    {
        todolist.removeAll()
        
        ref.child("todo").observeSingleEvent(of: .value, with: { (snapshot) in
            
            for todothing in snapshot.children
            {
                let todosnapshot = todothing as! DataSnapshot
                
                print(todosnapshot.key)
                print(todosnapshot.value)
                
                self.todolist.append(todosnapshot.value as! String)
            }
            self.todoTableview.reloadData()
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    
    @IBAction func addTodo(_ sender: Any) {
        
        self.ref.child("todo").childByAutoId().setValue(todoTextfield.text)
        loadTodo()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todolist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todocell") as! TodoTableViewCell
        
        cell.todoLabel.text = todolist[indexPath.row]
        
        return cell
        
        
    }

}

