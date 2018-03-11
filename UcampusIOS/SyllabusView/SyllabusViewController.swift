//
//  SyllabusViewController.swift
//  UcampusIOS
//
//  Created by 홍순우 on 2018. 3. 4..
//  Copyright © 2018년 홍순우. All rights reserved.
//

import UIKit
import WebKit
import Alamofire
import SwiftSoup

class SyllabusViewController: UIViewController {
    let webView = WKWebView()
    var lecture: Lecture!
    
    @IBOutlet weak var failureLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = Urls.syllabus.rawValue + lecture.syllabusQuery
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.queryString).response() { response in
            
            if let data = response.data,
                let decoded = NSString(data: data, encoding:
                    CFStringConvertEncodingToNSStringEncoding(0x0422)),
                let html = decoded as? String,
                let doc = try? SwiftSoup.parse(html),
                let _ = try? doc.select("colgroup").remove(),
                let _ = try? doc.select("input").remove(),
                let head = doc.head(),
                let _ = try? head.append("<style>table{width: 100% !important} td{font-size: 2em !important}</style>"),
                let _ = try? doc.select("*").removeAttr("width").removeAttr("style"),
                let string = try? doc.html() {

                self.webView.frame = CGRect(x: 0, y:  0, width: self.view.frame.width, height: self.view.frame.height)
                self.webView.loadHTMLString(string, baseURL: nil)
                self.webView.sizeToFit()
                self.view.addSubview(self.webView)
            } else {
               self.failureLabel.isHidden = false
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
