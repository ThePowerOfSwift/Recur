//
//  FormField.swift
//  Recur
//
//  Created by Wenyuan Bao & Dread Pirate Nic on 7/11/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import UIKit

class FormField: UIStackView {
    
    let textField = TitledTextField()
    let errorView = ErrorMessagesStack()
    
    var errorMessages = [ErrorMessage]() {
        didSet {
            errorView.configure(with: errorMessages)
        }
    }
    var shouldShowErrors = false
    
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
        spacing = 4
        textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        addArrangedSubview(textField)
        addArrangedSubview(errorView)
        errorView.isHidden = true
    }
    
    func isValid(showErrors: Bool) -> Bool {
        shouldShowErrors = showErrors
        if !isTextFieldInputValid(), shouldShowErrors {
            presentErrors()
        }
        return isTextFieldInputValid()
    }
    
    func isTextFieldInputValid() -> Bool {
        return true
    }
    
    func presentErrors() {
        errorView.isHidden = isTextFieldInputValid()
        textField.error = !isTextFieldInputValid()
    }

    @objc private func textFieldChanged() {
        if shouldShowErrors {
            presentErrors()
        }
    }
}
