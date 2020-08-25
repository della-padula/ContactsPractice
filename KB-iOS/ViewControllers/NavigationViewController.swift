//
//  NavigationViewController.swift
//  KB-iOS
//
//  Created by Denny on 2020/08/25.
//  Copyright © 2020 KakaoTalk. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        interactivePopGestureRecognizer?.delegate = self
    }
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
