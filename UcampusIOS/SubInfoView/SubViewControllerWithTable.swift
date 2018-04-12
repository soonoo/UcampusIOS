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
    var delegate: BBSTableDelegate! { get set }

    func getPostCode(from text: String) -> String?
}

extension SubViewControllerWithTable {
    func getPostCode(from text: String) -> String? {
        guard let fromIndex = text.index(of: "(") else { return nil }
        guard let toIndex = text.index(of: ",") else { return nil }
        let start = text.distance(from: text.startIndex, to: fromIndex) + 2
        let end = text.distance(from: text.startIndex, to: toIndex) - 2

        let result: String? = text.substr(from: start, to: end)

        return result
    }
}
