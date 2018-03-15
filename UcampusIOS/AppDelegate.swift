//
//  AppDelegate.swift
//  UcampusIOS
//
//  Created by 홍순우 on 2018. 2. 15..
//  Copyright © 2018년 홍순우. All rights reserved.
//

import UIKit
import AlamofireNetworkActivityIndicator
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // displays network indicator in status bar
        NetworkActivityIndicatorManager.shared.isEnabled = true
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // save cookies before when app enters background state
        let cookies = HTTPCookieStorage.shared.cookies ?? []
        let db = UserDefaults.standard
        db.set(NSKeyedArchiver.archivedData(withRootObject: cookies), forKey: "session")
        
        for cookie in cookies {
            HTTPCookieStorage.shared.deleteCookie(cookie)
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // load cookies from UserDefaults when app is back to foreground
        let data = UserDefaults.standard.object(forKey: "session") as! Data
        let cookies = NSKeyedUnarchiver.unarchiveObject(with: data) as! [HTTPCookie]
        
        for cookie in cookies {
            HTTPCookieStorage.shared.setCookie(cookie)
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}

