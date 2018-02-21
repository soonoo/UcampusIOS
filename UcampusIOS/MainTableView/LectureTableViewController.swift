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

class LectureTableViewController: UITableViewController {

    var lectures = [Lecture]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request(Urls.sub_info.rawValue, method: .get, parameters: nil, encoding:  URLEncoding.queryString).responseJSON() { response in
            let html = String(data: response.data!, encoding: .utf8)!
            
            let doc = try? SwiftSoup.parse(html)
            let td = try? doc!.select("td[width='9']").first()!.parent()!.parent()!.children()

            for el in td! {
                let title = try? el.child(1).text()
                let lecture = try? Lecture(title: title!, info: el.child(2).text(), code: "")
                self.lectures.append(lecture!)
                
                self.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lectures.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "LectureTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! LectureTableViewCell
        let lecture = lectures[indexPath.row]
        cell.titleLabel.text = lecture.title
        cell.descriptionLabel.text = lecture.lectureInfo

        return cell
    }

    func setIndicator() {
        let parentView = UIView()
        let indicator = UIActivityIndicatorView()
        
        let x = (self.tableView.frame.width / 2)
        let y = (self.tableView.frame.height / 2) -  (self.navigationController?.navigationBar.frame.height)!
        
        parentView.frame = CGRect(x: x, y: y, width: self.tableView.frame.width, height: self.tableView.frame.height)
        indicator.frame = CGRect(x: x, y: y, width: 30, height: 30)
        
        parentView.addSubview(indicator)
        self.tableView.addSubview(indicator)
    }
}

