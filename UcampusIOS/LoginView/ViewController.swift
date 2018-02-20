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
    @IBOutlet weak var logoTextField: UILabel!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var loginIndicator: UIActivityIndicatorView!

    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var constraintBetweenTextFields: NSLayoutConstraint!
    @IBOutlet weak var bgImageLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginButtonBottomConstraint: NSLayoutConstraint!
    
    var isTextFieldVisible = false
    
    var buttonAnimatedDistance: CGFloat = 0.0
    var logoAnimatedDistance: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.bgImageLeadingConstraint.constant -= (self.bgImageView.image!.size.width - self.view.bounds.width)
        UIView.animate(withDuration: 150, delay: 0, options: [.repeat, .autoreverse, .curveLinear], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        self.buttonAnimatedDistance = self.loginButton.center.y - self.idTextField.bounds.height*2 - UIApplication.shared.statusBarFrame.height - loginButtonTopConstraint.constant - constraintBetweenTextFields.constant - self.loginButton.bounds.height/2 - 40
        self.logoAnimatedDistance = self.logoTextField.center.y + (self.logoTextField.bounds.height/2)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // make status bar text color default
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
    func toggleTextField() {
        self.logoAnimatedDistance = -self.logoAnimatedDistance
        self.buttonAnimatedDistance = -self.buttonAnimatedDistance
        
        UIView.animate(withDuration: 0.3, animations: {
            self.logoTopConstraint.constant += self.logoAnimatedDistance
            self.loginButtonBottomConstraint.constant -= self.buttonAnimatedDistance
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func animate() {
        self.idTextField.isHidden = !self.idTextField.isHidden
        self.pwTextField.isHidden = !self.pwTextField.isHidden
        self.logoTextField.isHidden = !self.logoTextField.isHidden
        
        toggleTextField()
        
        if self.isTextFieldVisible {
            self.loginButton.setTitle("시작하기", for: .normal)
            self.view.endEditing(true)
        } else {
            self.loginButton.setTitle("로그인", for: .normal)
            self.idTextField.becomeFirstResponder()
        }
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
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let tabBarController = storyBoard.instantiateViewController(withIdentifier: "tabBarController") as! TabBarController
            self.present(tabBarController, animated: true, completion: nil)
        }
    }
    
    func login() {
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
        
        Alamofire.request(Urls.login.rawValue, method: .post, parameters: params, encoding: URLEncoding.httpBody).response() { response in
            self.getSessionCookie()
        }
    }
    
    // triggered on view touch
    @IBAction func hideKeyboard(_ sender: UIButton) {
        if self.isTextFieldVisible {
            animate()
        }
    }
    
    // triggered on login button click
    @IBAction func tryLogin(_ sender: UIButton) {
        if !self.isTextFieldVisible {
            animate()
            return
        }
        loginButton.setTitle("", for: .normal)
        loginIndicator.isHidden = false
        login()
    }
}
