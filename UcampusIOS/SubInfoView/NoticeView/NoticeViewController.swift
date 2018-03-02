//
//  NoticeViewController.swift
//  UcampusIOS
//
//  Created by 홍순우 on 2018. 3. 1..
//  Copyright © 2018년 홍순우. All rights reserved.
//

import UIKit

class NoticeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var noticeTableView: UITableView!
    var list = [String]()
    var container: SubInfoContainerController!

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("will begin dragging")
        //container.view.gestureRecognizers?.removeAll()
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("end decele")
        container.isScrolling = false
        container.view.addGestureRecognizer(container.g1)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 17
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "NoticeTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! NoticeTableViewCell
        cell.titleLabel.text = "hello"
        cell.descriptionLabel.text = "hi"
        return  cell
    }
    
    // triggered on click
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("click")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(container)
        noticeTableView.delegate = self
        noticeTableView.dataSource = self
        list = ["hello", "hello", "hello", "hello", "hello", "hello"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidAppear(_ animated: Bool) {
        container = parent! as! SubInfoContainerController
        print(container)
    }
}
