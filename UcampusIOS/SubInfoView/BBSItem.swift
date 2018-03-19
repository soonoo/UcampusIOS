//
//  Reference.swift
//  UcampusIOS
//
//  Created by 홍순우 on 2018. 3. 8..
//  Copyright © 2018년 홍순우. All rights reserved.
//

import Foundation

struct BBSItem {
    var title: String
    var date: String
    var postCode: String
    
    init(title: String, date: String, postCode: String) {
        self.title = title
        self.date = date
        self.postCode = postCode
    }
}
