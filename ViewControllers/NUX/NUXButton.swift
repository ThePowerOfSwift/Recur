//
//  NUXButton.swift
//  Recur
//
//  Created by Hana on 9/24/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import UIKit
import Stevia

class NUXButton: UIButton {

    override var isEnabled: Bool {
        didSet {
            if !isEnabled {
                backgroundColor = .inactive
            } else {
                backgroundColor = .recurBlue
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    private func setupButton() {
        contentHorizontalAlignment = .center
        isEnabled = true
        titleLabel?.font = .buttonText
        layer.cornerRadius = 20
        titleLabel?.numberOfLines = 0
        titleLabel?.sizeToFit()
        setTitleColor(.white, for: .normal)
        width(230).height(40)
    }
}
