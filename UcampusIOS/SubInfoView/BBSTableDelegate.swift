//
//  BBSTableDelegate.swift
//  UcampusIOS
//
//  Created by 홍순우 on 2018. 3. 20..
//  Copyright © 2018년 홍순우. All rights reserved.
//

import UIKit

class BBSTableDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    var container: SubInfoContainerController!
    var rowNumber: Int!
    var postLinks = [BBSItem]()
    var pages = [String]()
    var controller: UIViewController!
    var segue: String!

    init(container: SubInfoContainerController, controller: UIViewController, segue: String) {
        self.container = container
        self.controller = controller
        self.segue = segue
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
        cell.separatorInset = .zero
        cell.layoutMargins = .zero
        cell.titleLabel.text = postLinks[indexPath.row].title
        cell.descriptionLabel.text = postLinks[indexPath.row].date
        cell.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 82)
        return cell
    }
    
    // triggered on click
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        rowNumber = indexPath.row
        controller.performSegue(withIdentifier: segue, sender: nil)
    }
}

