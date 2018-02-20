//
//  TimeTableViewController.swift
//  UcampusIOS
//
//  Created by 홍순우 on 2018. 2. 20..
//  Copyright © 2018년 홍순우. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSoup

class TimeTableViewController: UITableViewController {
    var lectures = [[Lecture?]]()

    func removeFirstRowIfEmpty() {
        for item in lectures[0] {
            if item != nil {
                return
            }
        }
        lectures.removeFirst()
    }
    
    func setTimeTableData(_ html: String) {
        let doc = try! SwiftSoup.parse(html)
        
        let elements = try! doc.select("prnon").first()!.child(3).child(1).children()
        
        for i in 2..<elements.size() {
            let row = elements.get(i).children()
            self.lectures.append([Lecture?]())
            for j in 1...6 {
                if let title = try? row.get(j).text(), title.count != 0 {
                    self.lectures[i-2].append(Lecture(title: title, info: "", code: ""))
                } else {
                    self.lectures[i-2].append(nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request(Urls.time_table.rawValue, method: .post, parameters: nil, encoding: URLEncoding.httpBody).response() { response in
            let html = NSString(data: response.data!, encoding:
                CFStringConvertEncodingToNSStringEncoding(0x0422))! as String
            
            self.setTimeTableData(html)
            self.removeFirstRowIfEmpty()
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lectures.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TimeTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TimeTableViewCell
        
        let row = self.lectures[indexPath.row]
        cell.titleLabel1.text = row[0]?.title ?? ""
        cell.titleLabel2.text = row[1]?.title ?? ""
        cell.titleLabel3.text = row[2]?.title ?? ""
        cell.titleLabel4.text = row[3]?.title ?? ""
        cell.titleLabel5.text = row[4]?.title ?? ""
        cell.titleLabel6.text = row[5]?.title ?? ""
        
        return cell
    }
}
