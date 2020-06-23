//
//  NameTextField.swift
//  Recur
//
//  Created by Hana on 9/24/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import UIKit
import Stevia

class NameTextField: UIControl {

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .textFieldTitleFont
        return label
    }()

    let inputTextField: UITextField = {
        let textfield = PaddedTextField(UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 0))
        textfield.layer.borderColor = UIColor.inactive.cgColor
        textfield.layer.borderWidth = 2
        textfield.layer.cornerRadius = 21.5
        textfield.backgroundColor = .clear
        textfield.font = .textFieldFont
        return textfield
    }()

    weak var delegate: UITextFieldDelegate? {
        get {
            return inputTextField.delegate
        }
        set {
            inputTextField.delegate = newValue
        }
    }

    var titleText: String {
        get {
            return nameLabel.text ?? ""
        }
        set {
            nameLabel.text = newValue
        }
    }

    var inputText: String {
        get {
            return inputTextField.text ?? ""
        }
        set {
            inputTextField.text = newValue
        }
    }

    var color = UIColor.darkGray {
        didSet {
            nameLabel.textColor = color
            inputTextField.textColor = color
        }
    }

    var error = false {
        didSet {
            if error {
                inputTextField.textColor = .recurFalse
                inputTextField.layer.borderColor = UIColor.recurFalse.cgColor
                inputTextField.backgroundColor = .clear
            } else {
                inputTextField.textColor = color
                inputTextField.layer.borderColor = UIColor.recurBlue.cgColor
                inputTextField.backgroundColor = .white
            }
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

    func resetColor() {
        if (inputTextField.text == nil || inputTextField.text == "") {
            inputTextField.layer.borderColor = UIColor.inactive.cgColor
            inputTextField.backgroundColor = .clear
            inputTextField.font = .textFieldFont
        } else {
            inputTextField.textColor = color
            inputTextField.layer.borderColor = UIColor.recurBlue.cgColor
            inputTextField.backgroundColor = .white
        }
    }

    private func commonInit() {
        setupUILayoutWithTextFields()
        inputTextField.delegate = delegate
        addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }

    override func becomeFirstResponder() -> Bool {
        return inputTextField.becomeFirstResponder()
    }

    override func resignFirstResponder() -> Bool {
        return inputTextField.resignFirstResponder()
    }
    
    override func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        return inputTextField.addTarget(target, action: action, for: controlEvents)
    }

    // MARK: - Private

    private func setupUILayoutWithTextFields() {
        sv(
            nameLabel,
            inputTextField
        )
        nameLabel.height(14).top(0).left(10).right(10)
        nameLabel.centerHorizontally()
        inputTextField.Top == nameLabel.Bottom + 5
        inputTextField.height(43).bottom(0).left(10).right(10)
    }

    @objc private func tapped() {
        inputTextField.becomeFirstResponder()
    }
}

