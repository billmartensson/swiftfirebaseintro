//
//  TodoDetailViewController.swift
//  firebaseintro
//
//  Created by Bill Martensson on 2020-09-28.
//

import UIKit
import Firebase

class TodoDetailViewController: UIViewController {

    
    @IBOutlet weak var todoTopLabel: UILabel!
    
    @IBOutlet weak var doneButton: UIButton!
    
    
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
    

}
