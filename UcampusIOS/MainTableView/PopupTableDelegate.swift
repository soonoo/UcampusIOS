//
//  PopupTableDelegate.swift
//  UcampusIOS
//
//  Created by 홍순우 on 2018. 2. 22..
//  Copyright © 2018년 홍순우. All rights reserved.
//

import UIKit

class PopupTableDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    var list = ["공지사항", "강의 자료실", "강의 계획서", "과제 조회",]
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // triggered on cell click
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // returns row number
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    // returns cell view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "popupCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PopupTableViewCell

        cell.titleLabel.text = list[indexPath.row]
        
        return cell
    }
    
    // returns cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
