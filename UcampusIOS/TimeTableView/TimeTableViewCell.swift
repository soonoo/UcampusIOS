//
//  TimeTableViewCell.swift
//  UcampusIOS
//
//  Created by 홍순우 on 2018. 2. 20..
//  Copyright © 2018년 홍순우. All rights reserved.
//

import UIKit

class TimeTableViewCell: UITableViewCell {

    @IBOutlet var descriptionLabels: [UILabel]!
    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet var cellViews: [UIView]!
    @IBOutlet weak var periodLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
