//
//  LicenseViewController.swift
//  UcampusIOS
//
//  Created by 홍순우 on 2018. 3. 10..
//  Copyright © 2018년 홍순우. All rights reserved.
//

import UIKit

class LicenseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let textField = UITextView(frame: CGRect(x: 15, y: 15, width: view.frame.width - 30, height: view.frame.height - 30))
        textField.text = license
        textField.font = UIFont.systemFont(ofSize: 16.0)
        textField.showsVerticalScrollIndicator = false
        view.addSubview(textField)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
