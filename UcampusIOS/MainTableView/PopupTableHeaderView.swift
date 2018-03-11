//
//  PopupTableHeaderView.swift
//  UcampusIOS
//
//  Created by 홍순우 on 2018. 2. 24..
//  Copyright © 2018년 홍순우. All rights reserved.
//

import UIKit

class PopupTableHeaderView: UIView {
    var headerTitle = UILabel()
    var bottomBorder = UIView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        headerTitle.translatesAutoresizingMaskIntoConstraints = false
        headerTitle.textColor = .black
        
        bottomBorder.backgroundColor = TimeTableViewController.getUIColor((160, 160, 160))
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(headerTitle)
        self.backgroundColor = .white
        self.addConstraint(NSLayoutConstraint(item: headerTitle, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 15.0))
        self.addConstraint(NSLayoutConstraint(item: headerTitle, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -15.0))
        self.addConstraint(NSLayoutConstraint(item: headerTitle, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 5.0))
        self.addConstraint(NSLayoutConstraint(item: headerTitle, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -5.0))
        
        self.addSubview(bottomBorder)
        self.addConstraint(NSLayoutConstraint(item: bottomBorder, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: bottomBorder, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: bottomBorder, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: bottomBorder, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1.0))
    }
}
