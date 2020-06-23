//
//  FirstNameField.swift
//  Recur
//
//  Created by Hana on 9/19/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import UIKit
import Stevia

class FirstNameField: NameFormField {

    var text: String {
        get {
            return textField.inputText
        }
        set {
            textField.inputText = newValue 
            textField.sendActions(for: .editingChanged)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        configureTextFieldAttributes()
        let firstNameErrorMessage = ErrorMessage(text: "First name must be at least one character", status: .invalid)
        errorMessages.append(firstNameErrorMessage)
        self.isValid(showErrors: true)
    }
    
    private func configureTextFieldAttributes() {
        let firstName = Profile.currentProfile?.firstName ?? "First Name"
        textField.titleText = "First Name"
        textField.inputTextField.placeholder = firstName
        textField.inputTextField.keyboardType = .default
        textField.inputTextField.autocorrectionType = .no
        textField.inputTextField.autocapitalizationType = .words
        textField.color = .darkGray
    }
    
    override func isTextFieldInputValid() -> Bool {
        return textField.inputText.isValidNameLength
    }
}
