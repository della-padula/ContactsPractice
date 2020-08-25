//
//  PhoneBookViewController.swift
//  KB-iOS
//
//  Created by Denny on 2020/08/25.
//  Copyright © 2020 KakaoTalk. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

struct UserModel {
    var name: String
    var team: String
    var phoneNumber: String
    var job: String?
}

enum TabType {
    case name
    case job
    
    func parameterName() -> String {
        switch self {
        case .name:
            return "USER_NM"
        case .job:
            return "USER_JOB"
        }
    }
    
    func url() -> String {
        switch self {
        case .name:
            return "http://3.131.52.2:3000/getPersonInfo_byName"
        case .job:
            return "http://3.131.52.2:3000/getPersonInfo_byJob"
        }
    }
}

class PhoneBookViewController: UIViewController {
    private var fetchedUserList: [UserModel] = [UserModel]()
    
    private var selectedType: TabType = .name {
        didSet {
            if selectedType == .name {
                searchTextField.placeholder = "담당자명 입력"
                nameTabButton.setTitleColor(UIColor(hex: "#1F1F20", alpha: 1.0), for: .normal)
                jobTabButton.setTitleColor(UIColor(hex: "#B6B6B6", alpha: 1.0), for: .normal)
                
                nameTabButtonBottomBar.backgroundColor = UIColor(hex: "#F2BF41", alpha: 1.0)
                nameTabButtonBottomBar.snp.remakeConstraints { make in
                    make.left.right.bottom.equalToSuperview()
                    make.height.equalTo(4)
                }
                
                jobTabButtonBottomBar.backgroundColor = UIColor(hex: "#DDDDDD", alpha: 1.0)
                jobTabButtonBottomBar.snp.remakeConstraints { make in
                    make.left.right.bottom.equalToSuperview()
                    make.height.equalTo(1)
                }
            } else {
                searchTextField.placeholder = "업무 입력"
                jobTabButton.setTitleColor(UIColor(hex: "#1F1F20", alpha: 1.0), for: .normal)
                nameTabButton.setTitleColor(UIColor(hex: "#B6B6B6", alpha: 1.0), for: .normal)
                
                nameTabButtonBottomBar.backgroundColor = UIColor(hex: "#DDDDDD", alpha: 1.0)
                nameTabButtonBottomBar.snp.remakeConstraints { make in
                    make.left.right.bottom.equalToSuperview()
                    make.height.equalTo(1)
                }
                
                jobTabButtonBottomBar.backgroundColor = UIColor(hex: "#F2BF41", alpha: 1.0)
                jobTabButtonBottomBar.snp.remakeConstraints { make in
                    make.left.right.bottom.equalToSuperview()
                    make.height.equalTo(4)
                }
            }
        }
    }
    
    private var logoView: UIImageView = UIImageView()
    
    private var buttonContainerView: UIStackView = UIStackView()
    
    private var nameTabButtonContainerView: UIView = UIView()
    private var nameTabButtonBottomBar: UIView = UIView()
    private var nameTabButton: UIButton = UIButton()
    
    private var jobTabButtonContainerView: UIView = UIView()
    private var jobTabButtonBottomBar: UIView = UIView()
    private var jobTabButton: UIButton = UIButton()
    
    // MARK: Search Section
    private var searchStackView: UIStackView = UIStackView()
    private var searchTextField: UITextField = UITextField()
    private var searchButton: UIButton = UIButton()
    private var searchBottomBar: UIView = UIView()
    
    // MARK: List Section
    private var listTableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainLayout()
        self.listTableView.tableFooterView = UIView()
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        self.listTableView.register(UINib(nibName: "PhoneTableViewCell", bundle: nil), forCellReuseIdentifier: "phoneCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
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
        
        view.addSubview(buttonContainerView)
        buttonContainerView.axis = .horizontal
        buttonContainerView.distribution = .fillEqually
        buttonContainerView.addArrangedSubview(nameTabButtonContainerView)
        buttonContainerView.addArrangedSubview(jobTabButtonContainerView)
        
        buttonContainerView.snp.makeConstraints { make in
            make.top.equalTo(logoView).offset(32)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        nameTabButtonContainerView.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        nameTabButtonContainerView.addSubview(nameTabButton)
        nameTabButtonContainerView.addSubview(nameTabButtonBottomBar)
        
        nameTabButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        nameTabButtonBottomBar.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }
        
        jobTabButtonContainerView.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        jobTabButtonContainerView.addSubview(jobTabButton)
        jobTabButtonContainerView.addSubview(jobTabButtonBottomBar)
        
        jobTabButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        jobTabButtonBottomBar.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }
        
        nameTabButton.setTitle("담당자", for: .normal)
        nameTabButton.backgroundColor = .white
        nameTabButton.titleLabel?.font = .font15PBold
        nameTabButton.addTarget(self, action: #selector(onClickNameTabButton(sender:)), for: .touchUpInside)
        
        jobTabButton.setTitle("업무", for: .normal)
        jobTabButton.backgroundColor = .white
        jobTabButton.titleLabel?.font = .font15PBold
        jobTabButton.addTarget(self, action: #selector(onClickJobTabButton(sender:)), for: .touchUpInside)
        
        selectedType = .name
        
        view.addSubview(searchStackView)
        searchStackView.snp.makeConstraints { make in
            make.top.equalTo(buttonContainerView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        searchStackView.addArrangedSubview(searchTextField)
        searchStackView.addArrangedSubview(searchButton)
        
        searchTextField.addTarget(self, action: #selector(onEditSearchField(sender:)), for: .editingDidBegin)
        searchTextField.addTarget(self, action: #selector(onEditClosedSearchField(sender:)), for: .editingDidEndOnExit)
        
        searchStackView.snp.makeConstraints { make in
            make.height.equalTo(36)
        }
        
        searchButton.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.width.equalTo(36)
        }
        
        searchButton.setImage(UIImage(named:"search"), for: .normal)
        
        view.addSubview(searchBottomBar)
        searchBottomBar.snp.makeConstraints { make in
            make.top.equalTo(searchStackView.snp.bottom)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(1)
        }
        
        searchBottomBar.backgroundColor = UIColor(hex: "#DDDDDD", alpha: 1.0)
        
        view.addSubview(listTableView)
        listTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBottomBar.snp.bottom).offset(16)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
        }
        
        searchButton.addTarget(self, action: #selector(onClickSearchButton(sender:)), for: .touchUpInside)
        
    }
    
    @objc
    private func onEditSearchField(sender: UITextField) {
        searchBottomBar.backgroundColor = UIColor(hex: "#1F1F20", alpha: 1.0)
    }
    
    @objc
    private func onEditClosedSearchField(sender: UITextField) {
        searchBottomBar.backgroundColor = UIColor(hex: "#DDDDDD", alpha: 1.0)
    }
    
    @objc
    private func onClickNameTabButton(sender: UIButton) {
        selectedType = .name
    }
    
    @objc
    private func onClickJobTabButton(sender: UIButton) {
        selectedType = .job
    }
    
    @objc
    private func onClickSearchButton(sender: UIButton) {
        if let token = KBProperty.token, let keyword = searchTextField.text {
            fetchedUserList.removeAll()
            
            let parameters: [String: Any] = [
                selectedType.parameterName(): keyword,
                "PAGE_NUM": "0"
            ]
            
            let headers: HTTPHeaders = [
                "Authorization": "Barear \(token)"
            ]
            
            AF.request(selectedType.url(), method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        for jsonObject in json["contents"].arrayValue {
//                            print(jsonObject["DEPT_NM"])
//                            print(jsonObject["USER_NM"])
//                            print(jsonObject["USER_HP"])
//                            print(jsonObject["USER_CD"])
                            self.fetchedUserList.append(UserModel(name: jsonObject["USER_NM"].stringValue, team: jsonObject["DEPT_NM"].stringValue, phoneNumber: jsonObject["USER_HP"].stringValue, job: jsonObject["USER_JOB"].stringValue))
                        }
                        self.listTableView.reloadData()
                    default: return
                    }
            }
            
        }
    }
}

extension PhoneBookViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedUserList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "phoneCell", for: indexPath) as? PhoneTableViewCell {
            cell.item = fetchedUserList[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
}
