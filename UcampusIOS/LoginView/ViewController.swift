//
//  ViewController.swift
//  UcampusIOS
//
//  Created by 홍순우 on 2018. 2. 15..
//  Copyright © 2018년 홍순우. All rights reserved.
//

import UIKit
import Alamofire
import KeychainSwift

class ViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var loginIndicator: UIActivityIndicatorView!

    @IBOutlet weak var loginButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var constraintBetweenTextFields: NSLayoutConstraint!
    @IBOutlet weak var loginButtonBottomConstraint: NSLayoutConstraint!
    
    var isTextFieldVisible = false
    var autoLogin = false
    var buttonAnimatedDistance: CGFloat = 0.0
    var loginInProcess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let keyChain = KeychainSwift()
        if let id = keyChain.get("login_id") ,
            let pw = keyChain.get("login_pw") {
            autoLogin = true
            idTextField.text = id
            pwTextField.text = pw
            loginButton.isHidden = true
            login()
        }

        // make login button border radius
        loginButton.layer.cornerRadius = 6
        loginButton.clipsToBounds = true
        loginIndicator.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // make status bar text color white
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.buttonAnimatedDistance = self.loginButton.center.y - self.idTextField.bounds.height*2 - UIApplication.shared.statusBarFrame.height - loginButtonTopConstraint.constant - constraintBetweenTextFields.constant - self.loginButton.bounds.height/2 - 40
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // make status bar text color default
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
    func toggleTextField() {
        self.buttonAnimatedDistance *= -1

        self.loginButtonBottomConstraint.constant -= self.buttonAnimatedDistance
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func animate() {
        logoImageView.isHidden = !logoImageView.isHidden
        toggleTextField()
        
        if self.isTextFieldVisible {
            self.loginButton.setTitle("시작하기", for: .normal)
            self.view.endEditing(true)
        } else {
            self.loginButton.setTitle("로그인", for: .normal)
            self.idTextField.becomeFirstResponder()
        }
        
        self.idTextField.isHidden = !self.idTextField.isHidden
        self.pwTextField.isHidden = !self.pwTextField.isHidden
        
        self.isTextFieldVisible = !self.isTextFieldVisible
    }

    func deleteAllCookies() {
        let cookieStorage = HTTPCookieStorage.shared
        if let url = URL(string: "https://info2.kw.ac.kr"), let cookies = cookieStorage.cookies(for: url) {
            for cookie in cookies {
                cookieStorage.deleteCookie(cookie)
            }
        }
    }

    func getSessionCookie() {
        Alamofire.request(Urls.session.rawValue, method: .get, parameters: nil, encoding: URLEncoding.queryString).response() { response in
            self.loginIndicator.isHidden = true

            self.loginButton.setTitle("로그인", for: .normal)
            self.loginInProcess = false

            let keychain = KeychainSwift()
            keychain.set(self.idTextField.text!, forKey: "login_id")
            keychain.set(self.pwTextField.text!, forKey: "login_pw")

            self.idTextField.text = ""
            self.pwTextField.text = ""

            if !self.autoLogin {
                self.animate()
            }
            self.performSegue(withIdentifier: "login", sender: self)
            self.loginButton.isHidden = false
            self.autoLogin = false
        }
    }
    
    func login() {
        loginInProcess = true
        let params: Parameters = [
            "login_type": "2",
            "check_svc": "",
            "redirect_url": "http%3A%2F%2Finfo.kw.ac.kr%2F",
            "layout_opt": "",
            "gubun_code": "11",
            "p_language": "KOREAN",
            "member_no": idTextField.text!,
            "password": pwTextField.text!
        ]
        
        Alamofire.request(Urls.login.rawValue, method: .post, parameters: params, encoding: URLEncoding.httpBody).response() { response in
            if let headerFields = response.response?.allHeaderFields as? [String: String],
                let URL = response.request?.url {
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: URL)
                for cookie in cookies {
                    if cookie.name == "member_no" && cookie.value == "deleted" {
                        self.loginInProcess = false
                        self.loginIndicator.isHidden = true
                        self.loginButton.setTitle("로그인", for: .normal)
                        return
                    }
                }
            }
            self.getSessionCookie()
        }
    }
    
    // triggered on view touch
    @IBAction func hideKeyboard(_ sender: UIButton) {
        if self.isTextFieldVisible && !loginInProcess {
            animate()
        }
    }
    
    // triggered on login button click
    @IBAction func tryLogin(_ sender: UIButton) {
        if !self.isTextFieldVisible {
            animate()
            return
        }

        if idTextField.text! != "" && pwTextField.text! != "" {
            loginButton.setTitle("", for: .normal)
            loginIndicator.isHidden = false
            login()
        }
    }
}
