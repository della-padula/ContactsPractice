//
//  PhoneTableViewCell.swift
//  KB-iOS
//
//  Created by Denny on 2020/08/25.
//  Copyright © 2020 KakaoTalk. All rights reserved.
//

import UIKit

class PhoneTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    public var item: UserModel? {
        didSet {
            titleLabel.text = "\(item?.name ?? "") / \(item?.team ?? "")"
            phoneLabel.text = item?.phoneNumber
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onClickCall(_ sender: Any) {
        if let phoneNumber = item?.phoneNumber, let number = URL(string: "tel://" + phoneNumber) {
            UIApplication.shared.open(number)
        }
    }
    
}
