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
    
    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var constraintBetweenTextFields: NSLayoutConstraint!
    @IBOutlet weak var bgImageLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoTextField: UILabel!
    
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    
    var isTextFieldVisible = false
    
    var buttonAnimatedDistance: CGFloat = 0.0
    var logoAnimatedDistance: CGFloat = 200.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // make login button border radius
        loginButton.layer.cornerRadius = 6
        loginButton.clipsToBounds = true
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // make status bar text color default
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
    func showTextField() {
        self.logoTopConstraint.constant -= self.logoAnimatedDistance
        self.loginButtonBottomConstraint.constant += self.buttonAnimatedDistance
    }
    
    func hideTextField() {
        self.logoTopConstraint.constant += self.logoAnimatedDistance
        self.loginButtonBottomConstraint.constant -= self.buttonAnimatedDistance
    }
    
    func animate() {
        self.idTextField.isHidden = !self.idTextField.isHidden
        self.pwTextField.isHidden = !self.pwTextField.isHidden
        
        if self.isTextFieldVisible {
            self.loginButton.setTitle("시작하기", for: .normal)
            self.loginButton.layoutIfNeeded()
            hideTextField()
            self.view.endEditing(true)
        } else {
            self.loginButton.setTitle("로그인", for: .normal)
            self.loginButton.layoutIfNeeded()
            showTextField()
            self.idTextField.becomeFirstResponder()
        }
        
        UIView.animate(withDuration: 1.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: [], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        self.isTextFieldVisible = !self.isTextFieldVisible
    }
    
    @IBAction func hideKeyboard(_ sender: UIButton) {
        if self.isTextFieldVisible {
            animate()
        }
    }
    
    @IBAction func tryLogin(_ sender: UIButton) {
        animate()
        
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
        
//        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.httpBody).responseJSON { response in
//            print("Request: \(String(describing: response.request))")   // original url request
//            print("Response: \(String(describing: response.response))") // http url response
//            print("Result: \(response.result)")                         // response serialization result
//
//            if let json = response.result.value {
//                print("JSON: \(json)") // serialized json response
//            }
//
//            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                print("Data: \(utf8Text)") // original server data as UTF8 string
//            }
//        }
    }
    
}
