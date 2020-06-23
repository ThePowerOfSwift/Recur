//
//  EmailField.swift
//  Recur
//
//  Created by Bao Wenyuan & Dread Pirate Nic on 7/3/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import UIKit

class EmailField: FormField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        setupTextField()
        let emailErrorMessage = ErrorMessage(text: "Not a valid email", status: .invalid)
        errorMessages.append(emailErrorMessage)
    }

    private func setupTextField() {
        textField.titleText = "Email"
        textField.inputTextField.keyboardType = .emailAddress
        textField.inputTextField.autocorrectionType = .no
        textField.inputTextField.autocapitalizationType = .none
        textField.color = .mainBlue
    }

    override func isTextFieldInputValid() -> Bool {
        if let inputText = textField.inputText {
            return inputText.isValidEmail
        }
        return false
    }
}
