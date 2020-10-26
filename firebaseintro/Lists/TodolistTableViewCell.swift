//
//  TodolistTableViewCell.swift
//  firebaseintro
//
//  Created by Bill Martensson on 2020-10-22.
//

import UIKit

class TodolistTableViewCell: UITableViewCell {

    
    @IBOutlet weak var listTitleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
