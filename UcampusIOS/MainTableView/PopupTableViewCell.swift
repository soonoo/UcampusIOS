//
//  PopupTableViewCell.swift
//  UcampusIOS
//
//  Created by 홍순우 on 2018. 2. 22..
//  Copyright © 2018년 홍순우. All rights reserved.
//

import UIKit

class PopupTableViewCell: UITableViewCell {
    let titleLabel =  UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.textColor = UIColor.black
        contentView.addSubview(titleLabel)
        contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: 30.0))
        contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1.0, constant: -10.0))
        contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 5.0))
        contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: -5.0))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
