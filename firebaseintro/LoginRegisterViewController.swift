//
//  LoginRegisterViewController.swift
//  firebaseintro
//
//  Created by Bill Martensson on 2020-09-23.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginRegisterViewController: UIViewController {

    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func doRegister(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { authResult, error in
            if(error == nil)
            {
                // Skapa konto OK.
                print("Skapa konto ok")
                self.dismiss(animated: false, completion: nil)
            } else {
                print("Skapa konto error")
                print(error?.localizedDescription)
            }
        }
    }
    

    @IBAction func doLogin(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { authResult, error in
            if(error == nil)
            {
                // LOGIN OK!
                print("Login ok")
                self.dismiss(animated: false, completion: nil)
            } else {
                print("Login error")
                print(error?.localizedDescription)
            }
        }
    }
}
