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
        if let destination = segue.destination as? BBSPostViewController {
            destination.lectureCode = delegate.postLinks[delegate.rowNumber].postCode
            destination.isNoticeView = true
        }
    }

    func fetchAll(for page: Int) {
        let url = Urls.notice.rawValue + container.lecture.noticeQuery  + "&p_pageno=" + String(page)
        Alamofire.request(url).response { response in
            if let data = response.data,
                let html = String(data: data, encoding: .utf8),
                let doc = try? SwiftSoup.parse(html),
                let postLinks = try? doc.select("a[href*=whenDetail]").array() {
                for post in postLinks {
                    if let optPostCode = try? self.getPostCode(from: post.attr("href")),
                        let postCode = optPostCode,
                        let optDate = try? post.parent()?.parent()?.nextElementSibling()?.nextElementSibling()?.text(),
                        let date = optDate,
                        let title = try? post.text(),
                        let optId = try? post.parent()?.parent()?.previousElementSibling()?.text(),
                        let id = optId {
                        self.delegate.postLinks.append(BBSItem(title: title, date: date, postCode: postCode, id: id))
                    }
                }
                if postLinks.count == 0 {
                    self.failureLabel.text = "등록된 글이 없습니다."
                    self.failureLabel.isHidden = false
                    return
                } else if self.delegate.postLinks.last!.id == "1" {
                    self.mainTableView.reloadData()
                } else {
                    self.fetchAll(for: page + 1)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        container = parent! as! SubInfoContainerController
        delegate = BBSTableDelegate(container: container, controller: self, segue: "showNoticePost")
        mainTableView.delegate = delegate
        mainTableView.dataSource = delegate
        mainTableView.register(UINib(nibName: "BBSCellView", bundle: nil), forCellReuseIdentifier: "BBSCellView")
        mainTableView.tableFooterView = UIView()

        let url = Urls.notice.rawValue + container.lecture.noticeQuery  + "&p_pageno=0"
        Alamofire.request(url).response() { response in
            if let data = response.data,
                let html = String(data: data, encoding: .utf8) {
                
                if html.range(of: "로그인을 하셔야 합니다.") != nil {
                    NetworkManager.reloadSession(url: url, callback: { response in
                        self.fetchAll(for: 1)
                    })
                } else {
                    self.fetchAll(for: 1)
                }
            } else {
                self.failureLabel.text = "정보를 가져오는데 실패했습니다."
                self.failureLabel.isHidden = false
            }
        }
    }
}
