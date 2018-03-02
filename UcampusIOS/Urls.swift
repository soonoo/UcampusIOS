//
//  Constants.swift
//  UcampusIOS
//
//  Created by 홍순우 on 2018. 2. 19..
//  Copyright © 2018년 홍순우. All rights reserved.
//

import Foundation

enum Urls: String {
    case login = "http://info.kw.ac.kr/webnote/login/login_proc.php"
    case session = "http://info2.kw.ac.kr/servlet/controller.homepage.MainServlet?p_gate=univ&p_process=main&p_page=learning&p_kwLoginType=cookie&gubun_code=11"
    case sub_info = "http://info2.kw.ac.kr/servlet/controller.homepage.KwuMainServlet?p_process=openStu&p_grcode=N000003"
    case time_table = "http://info.kw.ac.kr/webnote/schedule/schedule.php"
}
