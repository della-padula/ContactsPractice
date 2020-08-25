//
//  SettingsViewController.swift
//  KB-iOS
//
//  Created by Denny on 2020/08/25.
//  Copyright © 2020 KakaoTalk. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "설정"
        self.navigationController?.isNavigationBarHidden = false
    }
    
    private func setupMainLayout() {
        
    }
    
}
