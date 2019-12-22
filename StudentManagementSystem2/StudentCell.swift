//
//  StudentCell.swift
//  StudentManagementSystem2
//
//  Created by Nabil Haffar on 10/15/19.
//  Copyright © 2019 Nabil Haffar. All rights reserved.
//
import UIKit
import Foundation
class StudentCell: UITableViewCell {
    @IBOutlet weak var studentImgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var idNumberLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
