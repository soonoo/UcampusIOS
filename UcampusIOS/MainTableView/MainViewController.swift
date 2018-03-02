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

class MainViewController: UIViewController {
    @IBOutlet weak var mainTableTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var mainTableView: UITableView!

    var lectures = [Lecture]()
    var popupTableView: UITableView!
    var opaqueView: UIView!
    var popupTableHeaderView: PopupTableHeaderView!

    let mainDelegate = LectureTableViewController()
    let popupDelegate = PopupTableDelegate()

    @objc func checkAction(sender : UITapGestureRecognizer) {
        popupTableHeaderView.isHidden = true
        mainTableView.isUserInteractionEnabled = true
        
        UIView.animate(withDuration: 0.2, animations: {
            let currentRect = self.popupTableView.frame
            self.opaqueView.alpha = CGFloat(0.0)
            self.popupTableView.frame = CGRect(x: currentRect.origin.x, y: currentRect.origin.y + 200, width: currentRect.size.width, height: currentRect.size.height)
            self.popupTableHeaderView.frame = CGRect(x: currentRect.origin.x, y: UIScreen.main.bounds.height - 70, width: currentRect.size.width, height: 70)
        }, completion: {(finshied: Bool) in
            self.opaqueView.isHidden = !self.opaqueView.isHidden
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.isExclusiveTouch = true
        mainTableView.isMultipleTouchEnabled = false
        
        // init popup table header view
        popupTableHeaderView = PopupTableHeaderView(frame: CGRect(x: CGFloat(0), y: UIScreen.main.bounds.height - 70, width: CGFloat(view.frame.width), height: CGFloat(70)))
        popupTableHeaderView.isHidden = true

        // init popup table view
        let popupTableHeight = 200
        popupTableView = UITableView(frame: CGRect(x: CGFloat(0), y: UIScreen.main.bounds.height, width: CGFloat(view.frame.width), height: CGFloat(popupTableHeight)))
        popupTableView.dataSource = popupDelegate
        popupTableView.register(PopupTableViewCell.self, forCellReuseIdentifier: "popupCell")
        popupTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);

        // init opaque view
        opaqueView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        opaqueView.backgroundColor = UIColor(red: CGFloat(0.4), green: CGFloat(0.4), blue: CGFloat(0.4), alpha: CGFloat(0.7))
        opaqueView.isHidden = true
        opaqueView.alpha = CGFloat(0.0)

        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        opaqueView.addGestureRecognizer(gesture)

        popupDelegate.mainTableView = mainTableView
        popupDelegate.popupTableHeaderView = popupTableHeaderView
        popupDelegate.opaqueView = opaqueView
        popupDelegate.navigationController = navigationController!
        popupTableView.delegate = popupDelegate
        
        // add popup table and opaque view
        tabBarController!.view.addSubview(opaqueView)
        tabBarController!.view.addSubview(popupTableView)
        tabBarController!.view.addSubview(popupTableHeaderView)

        Alamofire.request(Urls.sub_info.rawValue, method: .get, parameters: nil, encoding:  URLEncoding.queryString).responseJSON() { response in
            let html = String(data: response.data!, encoding: .utf8)!

            let doc = try? SwiftSoup.parse(html)
            let td = try? doc!.select("td[width='9']").first()!.parent()!.parent()!.children()

            for el in td! {
                let title = try? el.child(1).text()
                let lecture = try? Lecture(title: title!, info: el.child(2).text(), code: "")
                self.lectures.append(lecture!)
            }
            
            // init main table view
            self.mainTableView.dataSource = self.mainDelegate
            self.mainTableView.delegate = self.mainDelegate

            self.mainDelegate.lectures += self.lectures
            self.mainDelegate.popupTableHeaderView = self.popupTableHeaderView
            self.mainDelegate.opaqueView = self.opaqueView
            self.mainDelegate.popupTableView = self.popupTableView
            self.mainTableView.reloadData()
            
            self.indicatorView.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
