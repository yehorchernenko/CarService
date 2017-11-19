//
//  CarCell.swift
//  CarService
//
//  Created by Egor on 12.11.2017.
//  Copyright © 2017 Egor. All rights reserved.
//

import UIKit

class CarCell: UITableViewCell {

    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var serialNumberLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
