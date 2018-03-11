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

    case syllabus = "http://info.kw.ac.kr/webnote/lecture/h_lecture01_2.php?layout_opt=N&engineer_code=13&skin_opt=&fsel1_code=&fsel1_str=&fsel2_code=&fsel2_str=&fsel2=00_00&fsel3=&fsel4=00_00&hh=&sugang_opt=all&tmp_key=tmp__stu"

    case notice = "http://info2.kw.ac.kr/servlet/controller.learn.NoticeStuServlet?p_process=listPage&gubun_code=11&p_gate=univ&p_grcode=N000003&p_page=&p_process=&p_tutor_name="
    case notice_view = "http://info2.kw.ac.kr/servlet/controller.learn.NoticeStuServlet?p_process=view&p_grcode=N000003&p_skey=title&p_stext="

    case reference =  "http://info2.kw.ac.kr/servlet/controller.learn.AssPdsStuServlet?p_process=listPage&p_process=&p_gate=univ&p_grcode=N000003&gubun_code=11&p_tutor_name="
    case reference_view = "http://info2.kw.ac.kr/servlet/controller.learn.AssPdsStuServlet?p_process=view&p_grcode=N000003&p_skey=title&p_stext="
    
    case notice_download = "http://info2.kw.ac.kr/servlet/controller.library.DownloadServlet?"
}
