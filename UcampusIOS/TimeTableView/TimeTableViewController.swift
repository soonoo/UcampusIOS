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
    var bgColorList = [UIColor]()
    var subColorMap: [String: UIColor] = [:]
    let dayList = ["월", "화", "수", "목", "금", "토"]
    //let timeList = []

    typealias RGB = (Double, Double, Double)

    func getUIColor(_ value: RGB) -> UIColor{
        return UIColor(red: CGFloat(value.0/255.0), green: CGFloat(value.1/255.0), blue: CGFloat(value.2/255.0), alpha: 1.0)
    }
    
    func initColorList() {
        let rbgList = [
            (20.0, 167.0, 224.0),
            (243.0 ,175.0, 90.0),
            (236.0 ,135.0, 145.0),
            (178.0 ,212.0, 103.0),
            (102.0 ,190.0, 178.0),
            (184.0 ,157.0, 116.0),
            (255.0 ,226.0, 190.0),
            (236.0 ,231.0, 133.0),
            (138.0 ,237.0, 217.0)
        ]

        for i in 0..<rbgList.count {
            bgColorList.append(getUIColor(rbgList[i]));
        }
        subColorMap[""] = getUIColor((255, 255, 255))
    }
    
    func removeFirstRowIfEmpty() {
        // check if last row is empty
        for item in lectures[0] {
            if item != nil {
                return
            }
        }
        
        // remove last row
        lectures.removeFirst()
    }
    
    func removeLastColIfEmpty() {
        // check if last column is empty
        for item in lectures {
            if item[item.count-1] != nil {
                return
            }
        }
        
        // remove last column
        for i in 0..<lectures.count {
            lectures[i].removeLast()
        }
    }
    
    func getTitleFromText(_ text: String) -> String {
        return String(text[..<text.index(of: " ")!])
    }
    
    func getDescriptionFromText(_ text: String) -> String {
        let subString = String(text[text.index(of: "(")!..<text.index(of: ")")!])
        
        // remove opening parenthesis
        return String(subString.suffix(subString.count - 1))
    }

    func setTimeTableData(_ html: String) {
        let doc = try! SwiftSoup.parse(html)
        
        let elements = try! doc.select("prnon").first()!.child(3).child(1).children()
        
        //
        for i in 2..<elements.size() {
            self.lectures.append([Lecture?]())
            
            let row = elements.get(i).children()
            for j in 1...6 {
                if let text = try? row.get(j).text(), text.count != 0 {
                    let title = getTitleFromText(text)
                    let info = getDescriptionFromText(text)
                    
                    self.lectures[i-2].append(Lecture(title: title, info: info, code: ""))
                } else {
                    self.lectures[i-2].append(nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as! UIView
        
        statusBar.backgroundColor = getUIColor((255, 255, 255))
        
        initColorList()
        Alamofire.request(Urls.time_table.rawValue, method: .post, parameters: nil, encoding: URLEncoding.httpBody).response() { response in
            
            // response is euc-kr
            let html = NSString(data: response.data!, encoding:
                CFStringConvertEncodingToNSStringEncoding(0x0422))! as String
            
            self.setTimeTableData(html)
            self.removeFirstRowIfEmpty()
            self.removeLastColIfEmpty()
            
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

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? CGFloat(25) : CGFloat(90)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentifier = "TimeTableViewCell"

        if indexPath.row == 0{
            cellIdentifier = "TableHeaderCell"
            let dayCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TableHeaderCell
            if lectures[0].count == 5 {
                dayCell.saturdayLabel.isHidden = true
            }
            return dayCell
        }

        let dayCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TimeTableViewCell
        
        let row = self.lectures[indexPath.row - 1]
        
        var bgColor = getUIColor((255.0, 255.0, 255.0))

        for i in 0..<self.lectures[0].count {
            var title = row[i]?.title ?? ""
            var info = row[i]?.lectureInfo ?? ""

            if subColorMap[title] == nil {
                subColorMap[title] = bgColorList.removeLast()
                bgColor = subColorMap[title]!
            } else {
                bgColor = subColorMap[title]!
            }
            
            if indexPath.row != 0 && title != "" {
                if (self.lectures[indexPath.row-2][i]?.title ?? "") == title {
                    title = ""
                    info = ""
                }
            }
            
            dayCell.titleLabels[i].text = title
            dayCell.descriptionLabels[i].text = info
            dayCell.cellViews[i].backgroundColor = bgColor
        }
        dayCell.periodLabel.text = String(indexPath.row)
        dayCell.selectionStyle = .none
        
        if lectures[0].count == 5 {
            dayCell.cellViews[5].isHidden = true
        }
        
        return dayCell
    }
}
