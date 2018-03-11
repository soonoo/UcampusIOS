//
//  PopupTableDelegate.swift
//  UcampusIOS
//
//  Created by 홍순우 on 2018. 2. 22..
//  Copyright © 2018년 홍순우. All rights reserved.
//

import UIKit

class PopupTableDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    var list = ["공지사항", "강의 자료실", "강의 계획서",]
    var lectures = [Lecture]()
    var controller: MainViewController!
    var selectedRow: Int!
    var rowSelectionDelegate: PopupTableSelectionNotifier!

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // triggered on cell click
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedRow = indexPath.row
        controller.popupTableHeaderView.isHidden = true
        controller.mainTableView.isUserInteractionEnabled = true
        rowSelectionDelegate.notifyPopupTableSelection(row: indexPath.row)

        UIView.animate(withDuration: 0.2, animations: {
            let currentRect = tableView.frame
            self.controller.opaqueView.alpha = CGFloat(0.0)
            tableView.frame = CGRect(x: currentRect.origin.x, y: currentRect.origin.y + 150, width: currentRect.size.width, height: currentRect.size.height)
            self.controller.popupTableHeaderView.frame = CGRect(x: currentRect.origin.x, y: UIScreen.main.bounds.height - 70, width: currentRect.size.width, height: 70)
        }, completion: {(finshied: Bool) in
//            self.controller.opaqueView.isHidden = !self.controller.opaqueView.isHidden
//            self.controller.performSegue(withIdentifier: "showDetailSubInfo", sender: self.controller)
            
            self.controller.opaqueView.isHidden = !self.controller.opaqueView.isHidden
            
            switch indexPath.row {
            case 0:
                self.controller.performSegue(withIdentifier: "showDetailSubInfo", sender: self.controller)
            case 1:
                self.controller.performSegue(withIdentifier: "showDetailSubInfo", sender: self.controller)
            case 2:
                self.controller.performSegue(withIdentifier: "showSyllabusView", sender: self.controller)
            default:
                return
            }
        })
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
