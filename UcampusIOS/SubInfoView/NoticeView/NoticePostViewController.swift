//
//  NoticePostViewController.swift
//  UcampusIOS
//
//  Created by 홍순우 on 2018. 3. 9..
//  Copyright © 2018년 홍순우. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSoup

class NoticePostViewController: UIViewController {
    var scrollView: UIScrollView!
    var lectureCode: String!
    
    @IBOutlet weak var failureLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = Urls.notice_view.rawValue + "&p_bdseq=" + lectureCode
        Alamofire.request(url).response { response in
            if let data = response.data,
                let html = String(data: data, encoding: .utf8),
                let doc = try? SwiftSoup.parse(html),
                let contents = try? doc.select(".tl_l2").array(),
                let fileLinks = try? doc.select("a[href*=download]").array() {

                var post = ""
                for element in contents {
                    post += (try? element.text()) ?? ""
                    post += "\n"
                }
                
                self.scrollView = UIScrollView(frame: self.view.bounds)
                
                let textLabel = UILabel()
                textLabel.frame = CGRect(x:15, y: 15, width: self.view.frame.width - 30, height: 0)
                
                textLabel.text = post
                textLabel.textColor = .black
                textLabel.lineBreakMode = NSLineBreakMode.byCharWrapping
                textLabel.numberOfLines = 0
                textLabel.sizeToFit()
                
                var yPosition = textLabel.frame.height + 15
                for link in fileLinks {
                    if let href = try? link.attr("href"),
                        let fileName = self.getFileName(text: href),
                        let saveName = self.getSaveName(text: href) {
                        let label = DownloadLabel()
                        label.text = saveName
                        label.fileName = fileName
                        label.frame = CGRect(x: 15, y: yPosition, width: self.scrollView.frame.width, height: 0)
                        label.sizeToFit()
                        label.frame = CGRect(x: 15, y: yPosition, width: self.scrollView.frame.width - 30, height: label.frame.height + 15.0)
                        self.scrollView.addSubview(label)
                        yPosition += label.frame.height
                    }
                }
                
                self.scrollView.addSubview(textLabel)
                self.scrollView.alwaysBounceVertical = true
                self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: yPosition)
                self.view.addSubview(self.scrollView)
            } else {
                self.failureLabel.isHidden = false
            }
        }
    }

    func getFileName(text: String) -> String? {
        guard let fromIndex = text.index(of: "(") else { return nil }
        guard let toIndex = text.index(of: ",") else { return nil }
        let from = text.distance(from: text.startIndex, to: fromIndex) + 2
        let to = text.distance(from: text.startIndex, to: toIndex) - 2
        
        let result: String? = text.substr(from: from, to: to)
        return result
    }
    
    func getSaveName(text: String) -> String? {
        guard let fromIndex = text.index(of: ",") else { return nil }
        guard let toIndex = text.index(of: ")") else { return nil }
        let from = text.distance(from: text.startIndex, to: fromIndex) + 2
        let to = text.distance(from: text.startIndex, to: toIndex) - 2
        
        let result: String? = text.substr(from: from, to: to)
        return result
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
