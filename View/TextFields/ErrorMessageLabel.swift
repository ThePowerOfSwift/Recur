//
//  ErrorMessageLabel.swift
//  Recur
//
//  Created by Wenyuan Bao & Dread Pirate Nic on 6/27/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import UIKit
import Stevia

class ErrorMessageLabel: UIView {

    let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .errorMessageFont
        return label
    }()
    
    let errorStatusIcon = UIImageView()

    var status: ErrorStatus {
        didSet {
            configure(with: status)
        }
    }

    init(_ errorMessage: ErrorMessage) {
        status = .invalid
        super.init(frame: .zero)
        messageLabel.text = errorMessage.text
        configure(with: errorMessage.status)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        status = .invalid
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        sv(
            messageLabel,
            errorStatusIcon
        )
        messageLabel.left(0).fillVertically()
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .left
        errorStatusIcon.width(10).right(0).fillVertically()
        errorStatusIcon.Left == messageLabel.Right
        errorStatusIcon.contentMode = .scaleAspectFit
    }

    private func configure(with status: ErrorStatus) {
        messageLabel.textColor = status == .valid ? .recurGreen : .recurFalse
        errorStatusIcon.image = status == .valid ? #imageLiteral(resourceName: "check-icon") : #imageLiteral(resourceName: "x-icon")
    }
}
