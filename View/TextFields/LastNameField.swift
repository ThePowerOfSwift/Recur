//
//  LastNameField.swift
//  Recur
//
//  Created by Hana on 9/19/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import UIKit

class LastNameField: NameFormField {

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
        let lastNameErrorMessage = ErrorMessage(text: "Last name must be at least one character", status: .invalid)
        errorMessages.append(lastNameErrorMessage)
        self.isValid(showErrors: true)
    }
    
    private func configureTextFieldAttributes() {
        let lastName = Profile.currentProfile?.lastName ?? "Last Name"
        textField.titleText = "Last Name"
        textField.inputTextField.placeholder = lastName
        textField.inputTextField.keyboardType = .default
        textField.inputTextField.autocorrectionType = .no
        textField.inputTextField.autocapitalizationType = .words
        textField.color = .darkGray
    }
    
    override func isTextFieldInputValid() -> Bool {
        return textField.inputText.isValidNameLength
    }
}
