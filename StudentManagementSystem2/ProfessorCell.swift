//
//  ProfessorCell.swift
//  StudentManagementSystem2
//
//  Created by Nabil Haffar on 10/17/19.
//  Copyright © 2019 Nabil Haffar. All rights reserved.
//

import Foundation
import UIKit
class ProfessorCell: UITableViewCell {
    

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailAddress: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
