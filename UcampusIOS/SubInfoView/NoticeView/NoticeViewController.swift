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

class NoticeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SubViewControllerWithTable {
    
    @IBOutlet weak var failureLabel: UILabel!
    @IBOutlet weak var mainTableView: UITableView!
    var postLinks = [Notice]()
    var postList = [Notice]()
    var container: SubInfoContainerController!
    var pages = [String]()
    var rowNumber: Int!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? NoticePostViewController {
            destination.lectureCode = postLinks[rowNumber].postCode
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate {
            return
        }
        container.isScrolling = false
        container.view.addGestureRecognizer(container.gestureRecognizer)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y != 0 && (scrollView.contentSize.height - scrollView.frame.size.height < scrollView.contentOffset.y || scrollView.contentOffset.y < 0) {
            return
        }
        container.isScrolling = false
        container.view.addGestureRecognizer(container.gestureRecognizer)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postLinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "BBSCellView"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! BBSCellView
        cell.separatorInset = UIEdgeInsets.zero
        cell.titleLabel.text = postLinks[indexPath.row].title
        cell.descriptionLabel.text = postLinks[indexPath.row].date
        return cell
    }
    
    // triggered on click
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        rowNumber = indexPath.row
        performSegue(withIdentifier: "showNoticePost", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        container = parent! as! SubInfoContainerController

        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(UINib(nibName: "BBSCellView", bundle: nil), forCellReuseIdentifier: "BBSCellView")
        mainTableView.tableFooterView = UIView()

        let url = Urls.notice.rawValue + container.lecture.noticeQuery
        Alamofire.request(url).response() { response in
            if let data = response.data,
                let html = String(data: data, encoding: .utf8),
                let doc = try? SwiftSoup.parse(html),
                let pageLinks = try? doc.select("a[href*=goPage]").array().flatMap{ try? $0.attr("href") },
                let postLinks = try? doc.select("a[href*=whenDetail]").array() {

                for page in pageLinks {
                    if let index = self.getPage(text: page),
                        index != "1",
                        !self.pages.contains(index) {
                        self.pages.append(index)
                    }
                }
                
                for post in postLinks {
                    if let optPostCode = try? self.getPostCode(text: post.attr("href")),
                        let postCode = optPostCode,
                        let optDate = try? post.parent()?.parent()?.nextElementSibling()?.nextElementSibling()?.text(),
                        let date = optDate,
                        let title = try? post.text() {
                        self.postLinks.append(Notice(title: title, date: date, postCode: postCode))
                    }
                }
                if self.postLinks.count == 0 {
                    self.failureLabel.text = "등록된 글이 없습니다."
                    self.failureLabel.isHidden = false
                } else {
                    self.fetchPostLinks()
                }
            } else {
                self.failureLabel.text = "정보를 가져오는데 실패했습니다."
                self.failureLabel.isHidden = false
            }
        }
    }
    
    func fetchPostLinks() {
        if pages.count == 0 {
            mainTableView.reloadData()
            return
        }
        
        let url = Urls.notice.rawValue + container.lecture.noticeQuery + "&p_pageno=" + pages.remove(at: 0)
        Alamofire.request(url).response() { response in
            if let data = response.data,
                let html = String(data: data, encoding: .utf8),
                let doc = try? SwiftSoup.parse(html),
                let postLinks = try? doc.select("a[href*=whenDetail]").array() {

                for post in postLinks {
                    if let optPostCode = try? self.getPostCode(text: post.attr("href")),
                        let postCode = optPostCode,
                        let optDate = try? post.parent()?.parent()?.parent()?.nextElementSibling()?.nextElementSibling()?.text(),
                        let date = optDate,
                        let title = try? post.text() {
                        self.postLinks.append(Notice(title: title, date: date, postCode: postCode))
                    }
                }
                self.fetchPostLinks()
            }
        }
    }
    
    func getPage(text: String) -> String? {
        guard let fromIndex = text.index(of: "(") else { return nil }
        guard let toIndex = text.index(of: ")") else { return nil }
        let from = text.distance(from: text.startIndex, to: fromIndex) + 2
        let to = text.distance(from: text.startIndex, to: toIndex) - 2

        let result: String? = text.substr(from: from, to: to)
        
        return result
    }
    
    func getPostCode(text: String) -> String? {
        guard let fromIndex = text.index(of: "(") else { return nil }
        guard let toIndex = text.index(of: ",") else { return nil }
        let from = text.distance(from: text.startIndex, to: fromIndex) + 2
        let to = text.distance(from: text.startIndex, to: toIndex) - 2
        
        let result: String? = text.substr(from: from, to: to)
        
        return result
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
