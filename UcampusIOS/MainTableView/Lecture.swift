//
//  Lecture.swift
//  UcampusIOS
//
//  Created by 홍순우 on 2018. 2. 19..
//  Copyright © 2018년 홍순우. All rights reserved.
//

import UIKit

class Lecture {
    var title: String
    var lectureInfo: String
    var lectureCode: String
    
    init(title: String, info lectureInfo: String, code lectureCode: String) {
        self.title = title
        self.lectureInfo = lectureInfo
        self.lectureCode = lectureCode
    }
}
