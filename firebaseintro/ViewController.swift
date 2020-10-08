//
//  ViewController.swift
//  firebaseintro
//
//  Created by Bill Martensson on 2020-09-16.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage


class TodoItem
{
    var todotitle = ""
    var tododone = false
    var firebaseid = ""
}


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var todoTextfield: UITextField!
    @IBOutlet weak var todoTableview: UITableView!
    
    
    @IBOutlet weak var fbImageview: UIImageView!
    
    var ref: DatabaseReference!

    var todolist = [TodoItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        ref = Database.database().reference()
        
        todoTableview.dataSource = self
        todoTableview.delegate = self
        
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()

        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        
        let myimageRef = storageRef.child("frog.jpg")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        myimageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let error = error {
            // Uh-oh, an error occurred!
          } else {
            // Data is returned
            let gottenimage = UIImage(data: data!)
            self.fbImageview.image = gottenimage
          }
        }
        
        /*
        self.ref.child("theuser").setValue(["username": "XYZ"])
        
        ref.child("firstname").observeSingleEvent(of: .value, with: { (snapshot) in
          
            var thefirstname = snapshot.value as! String
            
            print(thefirstname)
            
        }) { (error) in
            print(error.localizedDescription)
        }
        */
        
        
        
    }

    override func viewWillAppear(_ animated: Bool) {

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if(Auth.auth().currentUser == nil)
        {
            performSegue(withIdentifier: "gologin", sender: nil)
        } else {
            
            print(Auth.auth().currentUser?.uid)
            
            loadTodo()
        }
        
    }
    
    func loadTodo()
    {
        /*
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
        */
        
        ref.child("todomoreusers").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { [self] (snapshot) in
            todolist.removeAll()
            for todothing in snapshot.children
            {
                let todosnapshot = todothing as! DataSnapshot
                                
                var tododict = todosnapshot.value as! [String : Any]
                
                var temptodo = TodoItem()
                temptodo.firebaseid = todosnapshot.key
                temptodo.todotitle = tododict["todotitle"] as! String
                temptodo.tododone = tododict["tododone"] as! Bool
                
                todolist.append(temptodo)
            }
            self.todoTableview.reloadData()
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    
    @IBAction func addTodo(_ sender: Any) {
        
        let newtodo : [String : Any] = ["todotitle": todoTextfield.text!, "tododone": false]
        
        self.ref.child("todomoreusers").child(Auth.auth().currentUser!.uid).childByAutoId().setValue(newtodo)
        loadTodo()
    }
    
    
    @IBAction func letsLogout(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "gologin", sender: nil)
        } catch {
            
        }
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todolist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todocell") as! TodoTableViewCell
        
        let todoRowInfo = todolist[indexPath.row]
        
        cell.todoLabel.text = todoRowInfo.todotitle
        
        if(todoRowInfo.tododone == true)
        {
            cell.todoDoneView.backgroundColor = UIColor.green
        } else {
            cell.todoDoneView.backgroundColor = UIColor.red
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(todolist.count == 0)
        {
            return
        }
        
        let todoitem = todolist[indexPath.row]
        
        /*
        if(todoitem["tododone"] as! Bool == true)
        {
            self.ref.child("todomoreusers").child(Auth.auth().currentUser!.uid).child(todoitem["fbkey"] as! String).child("tododone").setValue(false)
        } else {
            self.ref.child("todomoreusers").child(Auth.auth().currentUser!.uid).child(todoitem["fbkey"] as! String).child("tododone").setValue(true)
        }
        
        loadTodo()
        */
        
        performSegue(withIdentifier: "gotodo", sender: todoitem)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "gotodo")
        {
            var dest = segue.destination as! TodoDetailViewController
            dest.thetodoinfo = sender as! [String: Any]
            dest.parentVC = self
        }
        
        
    }
    
}

