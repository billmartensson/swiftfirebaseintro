//
//  TodoDetailViewController.swift
//  firebaseintro
//
//  Created by Bill Martensson on 2020-09-28.
//

import UIKit

class TodoDetailViewController: UIViewController {

    
    @IBOutlet weak var todoTopLabel: UILabel!
    
    var thetodoinfo = [String: Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        todoTopLabel.text = thetodoinfo["todotitle"] as! String
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
