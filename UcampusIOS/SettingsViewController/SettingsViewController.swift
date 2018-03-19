//
//  SettingsViewController.swift
//  UcampusIOS
//
//  Created by 홍순우 on 2018. 3. 10..
//  Copyright © 2018년 홍순우. All rights reserved.
//

import UIKit
import KeychainSwift

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let titles = [["사용 안내", "라이선스 정보", ],
                  ["로그아웃"]]
    
    @IBOutlet weak var settingsTableView: UITableView!

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                performSegue(withIdentifier: "showGuide", sender: nil)
            case 1:
                performSegue(withIdentifier: "showLicense", sender: nil)
            default:
                return
            }
        } else {
            switch indexPath.row {
            case 0:
                let cookies = HTTPCookieStorage.shared.cookies ?? []
                
                for cookie in cookies {
                    HTTPCookieStorage.shared.deleteCookie(cookie)
                }
                let keyChain = KeychainSwift()
                keyChain.delete("login_id")
                keyChain.delete("login_pw")
                self.dismiss(animated: true, completion: nil)
            default:
                return
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "SettingsTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! SettingsTableViewCell
        cell.titleLabel.text = titles[indexPath.section][indexPath.row]
        if indexPath.section == 1 {
            cell.titleLabel.textColor = .red
        }
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
