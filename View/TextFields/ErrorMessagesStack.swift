//
//  ErrorMessageView.swift
//  Recur
//
//  Created by Wenyuan Bao & Dread Pirate Nic on 6/27/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import UIKit

struct ErrorMessage {
    var text: String
    var status: ErrorStatus
}

enum ErrorStatus {
    case valid, invalid
}

class ErrorMessagesStack: UIStackView {
    var errorMessages: [ErrorMessage] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        axis = .vertical
        spacing = 3
    }

    func configure(with errorMessages: [ErrorMessage]) {
        if arrangedSubviews.count > 0 { arrangedSubviews.forEach({$0.removeFromSuperview()}) }
        self.errorMessages = errorMessages
        for errorMessage in errorMessages {
            let errorMessageLabel = ErrorMessageLabel(errorMessage)
            addArrangedSubview(errorMessageLabel)
        }
    }
}
