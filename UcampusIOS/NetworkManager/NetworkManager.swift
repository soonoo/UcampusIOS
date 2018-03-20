//
//  NetworkManager.swift
//  UcampusIOS
//
//  Created by 홍순우 on 2018. 3. 19..
//  Copyright © 2018년 홍순우. All rights reserved.
//

import Foundation
import Alamofire
import SwiftSoup

class NetworkManager {
    static func reloadSession(url: String, callback: @escaping (_ response: DefaultDataResponse) -> ()) {
        Alamofire.request(Urls.session.rawValue).response() { response in
            Alamofire.request(url).response() { response in
                callback(response)
            }
        }
    }
}
