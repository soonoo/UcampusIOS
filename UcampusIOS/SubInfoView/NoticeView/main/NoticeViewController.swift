//
//  NoticeViewController.swift
//  UcampusIOS
//
//  Created by 홍순우 on 2018. 3. 1..
//  Copyright © 2018년 홍순우. All rights reserved.
//

import UIKit
import SwiftSoup
import Alamofire

class NoticeViewController: UIViewController, SubViewControllerWithTable {

    @IBOutlet weak var failureLabel: UILabel!
    @IBOutlet weak var mainTableView: UITableView!

    var container: SubInfoContainerController!
    var delegate: BBSTableDelegate!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? NoticePostViewController {
            destination.lectureCode = delegate.postLinks[delegate.rowNumber].postCode
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        container = parent! as! SubInfoContainerController
        delegate = BBSTableDelegate(container: container, controller: self, segue: "showNoticePost")
        mainTableView.delegate = delegate
        mainTableView.dataSource = delegate
        delegate.container = container
        mainTableView.register(UINib(nibName: "BBSCellView", bundle: nil), forCellReuseIdentifier: "BBSCellView")
        mainTableView.tableFooterView = UIView()
        
        let url = Urls.notice.rawValue + container.lecture.noticeQuery
        Alamofire.request(url).response() { response in
            if let data = response.data,
                let html = String(data: data, encoding: .utf8),
                let doc = try? SwiftSoup.parse(html),
                let pageLinks = try? doc.select("a[href*=goPage]").array().flatMap{ try? $0.attr("href") },
                let postLinks = try? doc.select("a[href*=whenDetail]").array() {
                
                if html.range(of: "로그인을 하셔야 합니다.") != nil {
                    NetworkManager.reloadSession(url: url, callback: { response in
                        if let data = response.data,
                            let html = String(data: data, encoding: .utf8),
                            let doc = try? SwiftSoup.parse(html),
                            let pageLinks = try? doc.select("a[href*=goPage]").array().flatMap{ try? $0.attr("href") },
                            let postLinks = try? doc.select("a[href*=whenDetail]").array() {
                            
                            self.delegate.pages = self.addPageLinks(from: pageLinks, appending: self.delegate.pages)
                            self.delegate.postLinks = self.addNoticePostLinks(from: postLinks, appending: self.delegate.postLinks)
                            
                            if self.delegate.postLinks.count == 0 {
                                self.failureLabel.text = "등록된 글이 없습니다."
                                self.failureLabel.isHidden = false
                            } else {
                                self.fetchPostLinks(pages: self.delegate.pages, query: self.container.lecture.noticeQuery, bbsType: .reference, delegate: self.delegate, tableView: self.mainTableView)
                            }
                        } else {
                            self.failureLabel.text = "정보를 가져오는데 실패했습니다."
                            self.failureLabel.isHidden = false
                        }
                    })
                    return
                }
                
                self.delegate.pages = self.addPageLinks(from: pageLinks, appending: self.delegate.pages)
                self.delegate.postLinks = self.addNoticePostLinks(from: postLinks, appending: self.delegate.postLinks)
                
                if self.delegate.postLinks.count == 0 {
                    self.failureLabel.text = "등록된 글이 없습니다."
                    self.failureLabel.isHidden = false
                } else {
                    self.fetchPostLinks(pages: self.delegate.pages, query: self.container.lecture.noticeQuery, bbsType: .reference, delegate: self.delegate, tableView: self.mainTableView)
                }
            } else {
                self.failureLabel.text = "정보를 가져오는데 실패했습니다."
                self.failureLabel.isHidden = false
            }
        }
    }
}
