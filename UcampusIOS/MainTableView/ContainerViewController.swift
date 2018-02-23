//
//  ContainerViewController.swift
//  UcampusIOS
//
//  Created by 홍순우 on 2018. 2. 22..
//  Copyright © 2018년 홍순우. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSoup

class ContainerViewController: UIViewController {
    @IBOutlet weak var mainTableTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var mainTableView: UITableView!
    var popupTableView: UITableView!
    
    let opaqueView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    let mainDelegate = LectureTableViewController()
    let popupDelegate = PopupTableDelegate()
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        opaqueView.isHidden = !opaqueView.isHidden
        
        UIView.animate(withDuration: 0.3, animations: {
            let currentRect = self.popupTableView.frame
            self.popupTableView.frame = CGRect(x: currentRect.origin.x, y: currentRect.origin.y + 200, width: currentRect.size.width, height: currentRect.size.height)
        }, completion: {(finished: Bool) in
            //self.tabBarController!.tabBar.isHidden = !self.tabBarController!.tabBar.isHidden
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let popupTableHeight = 200
        popupTableView = UITableView(frame: CGRect(x: CGFloat(0), y: UIScreen.main.bounds.height, width: CGFloat(view.frame.width), height: CGFloat(popupTableHeight)))
        
        popupTableView.delegate = popupDelegate
        popupTableView.dataSource = popupDelegate
        popupTableView.register(PopupTableViewCell.self, forCellReuseIdentifier: "popupCell")
        popupTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);

        opaqueView.backgroundColor = UIColor(red: CGFloat(0.4), green: CGFloat(0.4), blue: CGFloat(0.4), alpha: CGFloat(0.5))
        opaqueView.isHidden = true
        
        navigationController!.view.addSubview(opaqueView)
        tabBarController!.view.addSubview(popupTableView)
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        self.opaqueView.addGestureRecognizer(gesture)
        
        opaqueView.isHidden = true
        
        Alamofire.request(Urls.sub_info.rawValue, method: .get, parameters: nil, encoding:  URLEncoding.queryString).responseJSON() { response in
            let html = String(data: response.data!, encoding: .utf8)!
            
            let doc = try? SwiftSoup.parse(html)
            let td = try? doc!.select("td[width='9']").first()!.parent()!.parent()!.children()
            
            for el in td! {
                let title = try? el.child(1).text()
                let lecture = try? Lecture(title: title!, info: el.child(2).text(), code: "")
                self.mainDelegate.lectures.append(lecture!)
            }

            self.mainTableView.dataSource = self.mainDelegate
            self.mainTableView.delegate = self.mainDelegate
            self.mainTableView.reloadData()

            self.mainDelegate.parentView = self.view
            self.mainDelegate.opaqueView = self.opaqueView
            self.mainDelegate.tabBar = self.tabBarController!.tabBar
            self.mainDelegate.popupTableView = self.popupTableView
            
            self.indicatorView.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
