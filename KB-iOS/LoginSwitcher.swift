//
//  LoginSwitcher.swift
//  KB-iOS
//
//  Created by Denny on 2020/08/25.
//  Copyright © 2020 KakaoTalk. All rights reserved.
//

import UIKit

class LoginSwitcher {
    static func goToMainVC() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var navigationVC : UINavigationController?
        navigationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainNavigation") as! NavigationViewController
        appDelegate.window?.rootViewController = navigationVC
    }
}
