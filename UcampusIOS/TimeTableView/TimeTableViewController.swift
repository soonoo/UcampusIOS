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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request(Urls.time_table.rawValue, method: .post, parameters: nil, encoding: URLEncoding.httpBody).response() { response in
            let html = NSString(data: response.data!, encoding:
                CFStringConvertEncodingToNSStringEncoding(0x0422))! as String
            
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
        cell.subView0.text = row[0]?.title ?? ""
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
