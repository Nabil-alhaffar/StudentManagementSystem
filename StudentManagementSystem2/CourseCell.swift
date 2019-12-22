//
//  CourseCell.swift
//  StudentManagementSystem2
//
//  Created by Nabil Haffar on 10/17/19.
//  Copyright © 2019 Nabil Haffar. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CourseCell: UITableViewCell {
    
    @IBOutlet weak var departmentCodeLbl: UILabel!
    
    @IBOutlet weak var courseNumberLbl: UILabel!
    
    @IBOutlet weak var courseNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
