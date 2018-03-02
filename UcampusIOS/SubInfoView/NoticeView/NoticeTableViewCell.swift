//
//  NoticeTableViewCell.swift
//  UcampusIOS
//
//  Created by 홍순우 on 2018. 3. 1..
//  Copyright © 2018년 홍순우. All rights reserved.
//

import UIKit

class NoticeTableViewCell: UITableViewCell {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
