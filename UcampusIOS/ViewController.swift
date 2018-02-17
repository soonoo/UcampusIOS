//
//  ViewController.swift
//  UcampusIOS
//
//  Created by 홍순우 on 2018. 2. 15..
//  Copyright © 2018년 홍순우. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // make login button border radius
        loginButton.layer.cornerRadius = 6
        loginButton.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.setAnimationRepeatAutoreverses(true)
        UIView.animate(withDuration: 100, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.bgImageView.center.x -= (self.bgImageView.image!.size.width - self.view.bounds.width)
        }, completion: nil)
    }
    
    @IBAction func tryLogin(_ sender: UIButton) {
        let url = "https://info.kw.ac.kr/webnote/login/login_proc.php"
        let params: Parameters = [
            "login_type": "2",
            "check_svc": "",
            "redirect_url": "http%3A%2F%2Finfo.kw.ac.kr%2F",
            "layout_opt": "",
            "gubun_code": "11",
            "p_language": "KOREAN",
            "member_no": "2014722023",
            "password": "c792b"
        ]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.httpBody).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
    }
}
