//
//  TodoTableViewCell.swift
//  firebaseintro
//
//  Created by Bill Martensson on 2020-09-16.
//

import UIKit

class TodoTableViewCell: UITableViewCell {

    
    @IBOutlet weak var todoLabel: UILabel!
    
    @IBOutlet weak var todoDoneView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
