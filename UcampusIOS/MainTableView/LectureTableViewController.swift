
//
//  LectureTableViewController.swift
//  UcampusIOS
//
//  Created by 홍순우 on 2018. 2. 19..
//  Copyright © 2018년 홍순우. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSoup

class LectureTableViewController: NSObject, UITableViewDataSource, UITableViewDelegate {
    var lectures = [Lecture]()

    var opaqueView: UIView!
    var popupTableView: UITableView!
    var popupTableHeaderView: PopupTableHeaderView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // triggered on cell click
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // prevent cell multitouch
        tableView.isUserInteractionEnabled = false

        self.opaqueView.isHidden = !self.opaqueView.isHidden
 
        let currentRect = self.popupTableView.frame
        popupTableHeaderView.headerTitle.text = lectures[indexPath.row].title
        popupTableHeaderView.isHidden = false

        UIView.animate(withDuration: 0.2, animations: {
            self.opaqueView.alpha = 0.7
            self.popupTableView.frame = CGRect(x: currentRect.origin.x, y: currentRect.origin.y - 200, width: currentRect.size.width, height: currentRect.size.height)
            self.popupTableHeaderView.frame = CGRect(x: currentRect.origin.x, y: currentRect.origin.y - 270, width: currentRect.size.width, height: 70)
        })
    }
    
    // returns row number
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lectures.count
    }
    
    // returns cell view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "LectureTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! LectureTableViewCell
        let lecture = lectures[indexPath.row]
        cell.titleLabel.text = lecture.title
        cell.descriptionLabel.text = lecture.lectureInfo
        
        return cell
    }
}

