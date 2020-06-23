//
//  BadgeButton.swift
//  Recur
//
//  Created by Wenyuan Bao on 7/15/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import UIKit
import Stevia

class BadgeButton: UIButton {

    private let notificationLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "SFCompactRounded-Bold", size: 12)
        label.backgroundColor = .notificationRed
        label.clipsToBounds = true
        return label
    }()
    
    var notificationCount: Int = 0 {
        didSet {
            notificationLabel.isHidden = notificationCount == 0
            notificationLabel.text = String(notificationCount)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        notificationLabel.layer.cornerRadius = notificationLabel.frame.height / 2
    }
    
    private func commonInit() {
        setImage(#imageLiteral(resourceName: "chat-icon"), for: .normal)
        guard let imageView = imageView else { return }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        sv(notificationLabel)
        imageView.height(28).width(27)
        notificationLabel.CenterX == imageView.Right
        notificationLabel.top(0).width(17).height(16)
        notificationLabel.isHidden = true
    }
}
