//
//  ViewController.swift
//  KB-iOS
//
//  Created by Denny on 2020/08/25.
//  Copyright © 2020 KakaoTalk. All rights reserved.
//

import UIKit
import Alamofire
import SnapKit

class ViewController: UIViewController {

    private var containerStackView: UIStackView = UIStackView()
    private var logoView: UIImageView = UIImageView()
    
    private var loginTitleLabel: UILabel = UILabel()
    
    private var idLabel: UILabel = UILabel()
    private var idField: UITextField = UITextField()
    
    private var idSeparator: UIView = UIView()
    private var pwSeparator: UIView = UIView()
    
    private var pwLabel: UILabel = UILabel()
    private var pwField: UITextField = UITextField()
    
    private var loginButton: UIButton = UIButton()
    
    private var isIdActive: Bool = false {
        didSet {
            idSeparator.backgroundColor = isIdActive ? UIColor(hex: "#F2BF41", alpha: 1.0) : UIColor(hex: "#DDDDDD", alpha: 1.0)
        }
    }
    
    private var isPwActive: Bool = false {
        didSet {
            pwSeparator.backgroundColor = isPwActive ? UIColor(hex: "#F2BF41", alpha: 1.0) : UIColor(hex: "#DDDDDD", alpha: 1.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainLayout()
    }
    
    private func setupMainLayout() {
        view.addSubview(logoView)
        
        logoView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(120)
            make.height.equalTo(18)
        }
        
        logoView.contentMode = .scaleToFill
        logoView.image = UIImage(named: "horiLogo")
        
        view.addSubview(containerStackView)
        containerStackView.axis = .vertical
        containerStackView.addArrangedSubview(loginTitleLabel)
        containerStackView.addArrangedSubview(idLabel)
        containerStackView.addArrangedSubview(idField)
        containerStackView.addArrangedSubview(idSeparator)
        containerStackView.addArrangedSubview(pwLabel)
        containerStackView.addArrangedSubview(pwField)
        containerStackView.addArrangedSubview(pwSeparator)
        
        containerStackView.setCustomSpacing(40, after: loginTitleLabel)
        containerStackView.setCustomSpacing(20, after: idSeparator)
        containerStackView.setCustomSpacing(20, after: pwSeparator)
        
        containerStackView.snp.makeConstraints { make in
            make.top.equalTo(logoView.snp.bottom).offset(32)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        loginTitleLabel.font = .font26PBold
        loginTitleLabel.text = "로그인"
        
        idField.snp.makeConstraints { make in
            make.height.equalTo(36)
        }
        
        idLabel.text = "사번"
        idLabel.font = .font12PBold
        idLabel.textColor = UIColor(hex: "#B6B6B6", alpha: 1.0)
        
        idSeparator.backgroundColor = isIdActive ? UIColor(hex: "#F2BF41", alpha: 1.0) : UIColor(hex: "#DDDDDD", alpha: 1.0)
        idSeparator.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        
        pwField.snp.makeConstraints { make in
            make.height.equalTo(36)
        }
        
        pwField.textContentType = .password
        pwField.isSecureTextEntry = true
        
        pwSeparator.backgroundColor = isPwActive ? UIColor(hex: "#F2BF41", alpha: 1.0) : UIColor(hex: "#DDDDDD", alpha: 1.0)
        pwSeparator.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        
        idField.addTarget(self, action: #selector(changeField(sender:)), for: .editingChanged)
        pwField.addTarget(self, action: #selector(changeField(sender:)), for: .editingChanged)
        
        pwLabel.text = "PW"
        pwLabel.font = .font12PBold
        pwLabel.textColor = UIColor(hex: "#B6B6B6", alpha: 1.0)
        
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        loginButton.backgroundColor = UIColor(hex: "#ECECEC", alpha: 1.0)
        loginButton.layer.cornerRadius = 6
        loginButton.titleLabel?.font = .font15PBold
        loginButton.setTitle("로그인", for: .normal)
        loginButton.setTitleColor(UIColor(hex: "#1F1F20", alpha: 1.0), for: .normal)
        loginButton.addTarget(self, action: #selector(onClickLogin(sender:)), for: .touchUpInside)
    }
    
    private func requestPhoneList(completion : @escaping () -> Void) {
        
    }
    
    @objc
    private func onClickLogin(sender: UIButton) {
        let loginURL = "http://3.131.52.2:3000/loginEZ"
        let parameters: [String : Any] = [
            "uid" : idField.text ?? "",
            "password" : pwField.text ?? ""
        ]
        
        print("Request Login")
        
        AF.request(loginURL, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON(completionHandler: { response in
//                print(response)
                if let result = response.value as? [String: String] {
                    print(result["token"] ?? "")
                    KBProperty.token = result["token"]
                }
                LoginSwitcher.goToMainVC()
        })
    }
    
    @objc
    private func changeField(sender: UITextField) {
        if idField.text?.isEmpty ?? true || pwField.text?.isEmpty ?? true {
            // InActive
            loginButton.backgroundColor = UIColor(hex: "#ECECEC", alpha: 1.0)
        } else {
            // Active
            loginButton.backgroundColor = UIColor(hex: "#F6BE41", alpha: 1.0)
        }
    }

}
