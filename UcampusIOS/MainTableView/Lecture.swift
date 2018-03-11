//
//  Lecture.swift
//  UcampusIOS
//
//  Created by 홍순우 on 2018. 2. 19..
//  Copyright © 2018년 홍순우. All rights reserved.
//

import UIKit

extension String {
    func substr(from: Int, to: Int) -> String {
        let start = self.index(startIndex, offsetBy: from)
        let end = self.index(startIndex, offsetBy: to + 1)

        return String(self[start..<end])
    }
}

struct Lecture {
    var title: String
    var info: String
    var code: String
    
    // 연도
    var year: String {
        return code.substr(from: 0, to: 3)
    }

    // 학기
    var semester: String {
        return code.substr(from: 4, to: 4)
    }
    
    // 수업 번호
    var classCode: String {
        return code.substr(from: 5, to: 8)
    }

    // 전공 번호
    var majorCode: String {
        return code.substr(from: 9, to: 12)
    }

    // 분반
    var division: String {
        return code.substr(from: 13, to: 14)
    }

    // 난도
    var difficulty: String {
        return code.substr(from: 15, to: 15)
    }

    var syllabusQuery: String {
        return "&this_year=" + year + "&hakgi=" + semester + "&open_major_code=" + majorCode + "&open_grade=" + difficulty + "&open_gwamok_no=" + classCode + "&bunban_no=" + division
    }

    var noticeQuery: String {
        return "&p_year=" + year + "&p_subj=U" + code + "&p_subjseq=" + semester + "&p_class=" + division
    }
    
    var noticePostQuery: String {
        return "&p_bdseq=98296&p_pageno=0&p_subj=U2018109227220013&p_year=2018&p_subjseq=1&p_class=01"
    }
    
    var referenceQuery: String {
        return "&p_subj=U" + code + "&p_year=" + year + "&p_subjseq=" + semester + "&p_class=" + division
    }

    init(title: String, info: String, code: String) {
        self.title = title
        self.info = info
        self.code = code
    }
}
