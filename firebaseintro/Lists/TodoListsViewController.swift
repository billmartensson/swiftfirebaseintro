//
//  TodoListsViewController.swift
//  firebaseintro
//
//  Created by Bill Martensson on 2020-10-22.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class TodoListsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var listnameTextfield: UITextField!
    @IBOutlet weak var todolistsTableview: UITableView!
    
    var ref: DatabaseReference!

    var todolists = [TodoList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        todolistsTableview.dataSource = self
        todolistsTableview.delegate = self
        
        ref = Database.database().reference()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if(Auth.auth().currentUser == nil)
        {
            performSegue(withIdentifier: "gologin", sender: nil)
        } else {
            loadLists()
            
        }
        
    }
    
    @IBAction func logout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "gologin", sender: nil)
        } catch {
            
        }
    }
    
    @IBAction func addList(_ sender: Any) {
        var newlist = TodoList()
        newlist.todotitle = listnameTextfield.text!
        newlist.save()
    }
    
    func loadLists()
    {
        let fb_lists = ref.child("todoadvanced").child("todolists")
        
        let fb_query = fb_lists.queryOrdered(byChild: "users/"+Auth.auth().currentUser!.uid+"/owner").queryStarting(atValue: false).queryEnding(atValue: true)
        
        fb_query.observeSingleEvent(of: .value, with: { [self] (snapshot) in
            
            todolists.removeAll()
            for todothing in snapshot.children
            {
                let todosnapshot = todothing as! DataSnapshot
                                
                let tododict = todosnapshot.value as! [String : Any]
                
                let temptodo = TodoList()
                temptodo.firebaseid = todosnapshot.key
                temptodo.todotitle = tododict["todotitle"] as! String
                //temptodo.owner = tododict["owner"] as! Bool

                todolists.append(temptodo)
            }
            self.todolistsTableview.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todolists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "listcell") as! TodolistTableViewCell
        
        cell.listTitleLabel.text = todolists[indexPath.row].todotitle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "todolist", sender: indexPath.row)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "todolist")
        {
            let dest = segue.destination as! ViewController
            dest.currentList = todolists[sender as! Int]
        }
    }
}
