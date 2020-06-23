//
//  NameFormField.swift
//  Recur
//
//  Created by Hana on 9/24/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import UIKit

class NameFormField: UIStackView {
    
    let textField = NameTextField()
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
