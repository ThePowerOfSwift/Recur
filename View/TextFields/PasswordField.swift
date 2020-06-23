//
//  PasswordField.swift
//  Recur
//
//  Created by Bao Wenyuan & Dread Pirate Nic on 7/3/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import UIKit

class PasswordField: FormField {

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
    }
    
    private func setupTextField() {
        textField.titleText = "Password"
        textField.isSecureTextEntry = true
        textField.color = .mainBlue
    }

    override func isTextFieldInputValid() -> Bool {
        if let inputText = textField.inputText {
            return inputText.isValidPassword
        }
        return false
    }
    
    override func presentErrors() {
        super.presentErrors()
        if let inputText = textField.inputText {
            let charCountErrorMessage = ErrorMessage(text: "Must contain 8 characters", status: inputText.isValidLength ? .valid : .invalid)
            let upperCaseErrorMessage = ErrorMessage(text: "Must contain 1 uppercase character", status: inputText.containsAtLeastOneUppercased ? .valid : .invalid)
            let numericCharErrorMessage = ErrorMessage(text: "Must contain 1 numeric character", status: inputText.containsAtLeastOneNumeric ? .valid : .invalid)
            errorMessages = [charCountErrorMessage, upperCaseErrorMessage, numericCharErrorMessage]
        }
    }

    func presentInvalidPasswordError() {
        errorView.isHidden = false
        let passwordInvalidMessage = ErrorMessage(text: "Invalid Password", status: .invalid)
        errorMessages = [passwordInvalidMessage]
    }
}
