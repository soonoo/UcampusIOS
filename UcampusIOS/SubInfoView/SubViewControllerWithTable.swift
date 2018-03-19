//
//  SubViewControllerWithTable.swift
//  UcampusIOS
//
//  Created by 홍순우 on 2018. 3. 19..
//  Copyright © 2018년 홍순우. All rights reserved.
//

import UIKit
import SwiftSoup
import Alamofire

protocol SubViewControllerWithTable {
    var container: SubInfoContainerController! { get set }
    var mainTableView: UITableView! { get set }
    func getPage(from text: String) -> String?
    func getPostCode(from text: String) -> String?
    func addPageLinks(from href: [String], appending to: [String]) -> [String]
    func addReferencePostLinks(from elements: [Element], appending to: [BBSItem]) -> [BBSItem]
    func addNoticePostLinks(from elements: [Element], appending to: [BBSItem]) -> [BBSItem]
    func fetchPostLinks(pages: [String], query: String, bbsType: Urls, delegate: BBSTableDelegate, tableView: UITableView)
}

extension SubViewControllerWithTable {
    func getPage(from text: String) -> String? {
        guard let fromIndex = text.index(of: "(") else { return nil }
        guard let toIndex = text.index(of: ")") else { return nil }
        let start = text.distance(from: text.startIndex, to: fromIndex) + 2
        let end = text.distance(from: text.startIndex, to: toIndex) - 2
        
        let result: String? = text.substr(from: start, to: end)
        
        return result
    }
    
    func getPostCode(from text: String) -> String? {
        guard let fromIndex = text.index(of: "(") else { return nil }
        guard let toIndex = text.index(of: ",") else { return nil }
        let start = text.distance(from: text.startIndex, to: fromIndex) + 2
        let end = text.distance(from: text.startIndex, to: toIndex) - 2

        let result: String? = text.substr(from: start, to: end)

        return result
    }
    
    func addPageLinks(from href: [String], appending to: [String]) -> [String] {
        var arr = to
        for page in href {
            if let index = getPage(from: page),
                index != "1",
                !arr.contains(index) {
                arr.append(index)
            }
        }
        return arr
    }
    
    func addReferencePostLinks(from elements: [Element], appending to: [BBSItem]) -> [BBSItem] {
        var arr = to
        for post in elements {
            if let optPostCode = try? self.getPostCode(from: post.attr("href")),
                let postCode = optPostCode,
                let optDate = try? post.parent()?.parent()?.nextElementSibling()?.text(),
                let date = optDate,
                let title = try? post.text() {
                arr.append(BBSItem(title: title, date: date, postCode: postCode))
            }
        }
        return arr
    }

    func addNoticePostLinks(from elements: [Element], appending to: [BBSItem]) -> [BBSItem] {
        var arr = to
        for post in elements {
            if let optPostCode = try? self.getPostCode(from: post.attr("href")),
                let postCode = optPostCode,
                let optDate = try? post.parent()?.parent()?.nextElementSibling()?.nextElementSibling()?.text(),
                let date = optDate,
                let title = try? post.text() {
                arr.append(BBSItem(title: title, date: date, postCode: postCode))
            }
        }
        return arr
    }

    func fetchPostLinks(pages: [String], query: String, bbsType: Urls, delegate: BBSTableDelegate, tableView: UITableView) {
        if pages.count == 0 {
            tableView.reloadData()
            return
        }
        var pageList = pages
        let url = bbsType.rawValue + query + "&p_pageno=" + pageList.remove(at: 0)
        Alamofire.request(url).response { response in
            if let data = response.data,
                let html = String(data: data, encoding: .utf8),
                let doc = try? SwiftSoup.parse(html),
                let postLinks = try? doc.select("a[href*=whenDetail]").array() {
                
                for post in postLinks {
                    if let optPostCode = try? self.getPostCode(from: post.attr("href")),
                        let postCode = optPostCode,
                        let optDate = try? post.parent()?.parent()?.parent()?.nextElementSibling()?.nextElementSibling()?.text(),
                        let date = optDate,
                        let title = try? post.text() {
                        delegate.postLinks.append(BBSItem(title: title, date: date, postCode: postCode))
                    }
                }
            }
            self.fetchPostLinks(pages: pageList, query: query, bbsType: bbsType, delegate: delegate, tableView: tableView)
        }
    }
}
