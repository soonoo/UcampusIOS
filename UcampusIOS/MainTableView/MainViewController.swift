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

class MainViewController: UIViewController, MainTableRowSelectionNotifier, PopupTableRowSelectionNotifier {
    
    @IBOutlet weak var mainTableTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var mainTableView: UITableView!

    var lectures = [Lecture]()
    var popupTableView: UITableView!
    var opaqueView: UIView!
    var popupTableHeaderView: PopupTableHeaderView!
    var popupTableHeaderViewHeight = CGFloat(70.0)
    var popupTableHeight = CGFloat(150.0)
    
    var currentSubIndex: Int!
    var currentPopupIndex: Int!

    let mainDelegate = LectureTableViewController()
    let popupDelegate = PopupTableDelegate()

    @objc func checkAction(sender : UITapGestureRecognizer) {
        mainTableView.isUserInteractionEnabled = true
        
        UIView.animate(withDuration: 0.2, animations: {
            let currentRect = self.popupTableView.frame
            self.opaqueView.alpha = CGFloat(0.0)
            self.popupTableView.frame = CGRect(x: currentRect.origin.x, y: currentRect.origin.y + 220, width: currentRect.size.width, height: currentRect.size.height)
            self.popupTableHeaderView.frame = CGRect(x: currentRect.origin.x, y: UIScreen.main.bounds.height, width: currentRect.size.width, height: self.popupTableHeaderViewHeight)
        }, completion: {(finshied: Bool) in
            self.opaqueView.isHidden = !self.opaqueView.isHidden
        })
    }

    func notifyMainTableSelection(row index: Int) {
        currentSubIndex = index
    }

    func notifyPopupTableSelection(row index: Int) {
        currentPopupIndex = index
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.isExclusiveTouch = true
        mainTableView.isMultipleTouchEnabled = false
        mainDelegate.rowSelectionDelegate = self

        // init popup table header view
        popupTableHeaderView = PopupTableHeaderView(frame: CGRect(x: CGFloat(0), y: UIScreen.main.bounds.height, width: CGFloat(view.frame.width), height: popupTableHeaderViewHeight))

        // init popup table view
        let popupTableHeight = 150
        popupTableView = UITableView(frame: CGRect(x: CGFloat(0), y: UIScreen.main.bounds.height + popupTableHeaderViewHeight, width: CGFloat(view.frame.width), height: CGFloat(popupTableHeight)))
        popupTableView.dataSource = popupDelegate
        popupTableView.register(PopupTableViewCell.self, forCellReuseIdentifier: "popupCell")
        popupTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);

        // init opaque view
        opaqueView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        opaqueView.backgroundColor = UIColor(red: CGFloat(0.4), green: CGFloat(0.4), blue: CGFloat(0.4), alpha: CGFloat(0.7))
        opaqueView.isHidden = true
        opaqueView.alpha = CGFloat(0.0)

        let gesture = UITapGestureRecognizer(target: self, action:  #selector(checkAction))
        opaqueView.addGestureRecognizer(gesture)

        popupDelegate.controller = self
        popupDelegate.rowSelectionDelegate = self
        popupTableView.delegate = popupDelegate

        self.mainTableView.dataSource = self.mainDelegate
        self.mainTableView.delegate = self.mainDelegate
        
        self.mainDelegate.popupTableHeaderView = self.popupTableHeaderView
        self.mainDelegate.opaqueView = self.opaqueView
        self.mainDelegate.popupTableView = self.popupTableView
        
        // add popup table and opaque view
        tabBarController!.view.addSubview(opaqueView)
        tabBarController!.view.addSubview(popupTableView)
        tabBarController!.view.addSubview(popupTableHeaderView)

        Alamofire.request(Urls.sub_info.rawValue, method: .get, parameters: nil, encoding:  URLEncoding.queryString).responseJSON() { response in
            
            if let html = String(data: response.data!, encoding: .utf8),
                let doc = try? SwiftSoup.parse(html),
                let tag = try? doc.select("td[width='9']"),
                let td = tag.first()?.parent()?.parent()?.children() {

                for el in td {
                    let title = try? el.child(1).text()
                    let info = try? el.child(2).text()
                    let code = try? el.child(3).child(0).attr("href").substr(from: 24, to: 39)
                    
                    let lecture = Lecture(title: title!, info: info!, code: code!)
                    self.lectures.append(lecture)
                }

                // init main table view
                
                self.mainDelegate.lectures += self.lectures
                self.mainTableView.reloadData()
                
                self.indicatorView.isHidden = true
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SyllabusViewController {
            destination.lecture = lectures[currentSubIndex]
        } else if let destination = segue.destination as? SubInfoContainerController {
            destination.lecture = lectures[currentSubIndex]
            destination.tabPosition = currentPopupIndex
        }
    }
}

protocol MainTableRowSelectionNotifier {
    func notifyMainTableSelection(row index: Int)
}

protocol PopupTableRowSelectionNotifier {
    func notifyPopupTableSelection(row index: Int)
}
