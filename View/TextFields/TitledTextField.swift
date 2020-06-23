//
//  RecurTextField.swift
//  Recur
//
//  Created by Wenyuan Bao on 6/25/19.
//  Copyright © 2019 buildschool. All rights reserved.
//
import UIKit
import Stevia

class TitledTextField: UIControl {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .textFieldTitleFont
        return label
    }()

    let inputTextField: UITextField = {
        let textfield = PaddedTextField(UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18))
        textfield.layer.borderColor = UIColor.lightGray.cgColor
        textfield.layer.borderWidth = 0.7
        textfield.layer.cornerRadius = 5
        textfield.backgroundColor = .white
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

    var titleText: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }

    var inputText: String? {
        get {
            return inputTextField.text
        }
        set {
            inputTextField.text = newValue
        }
    }

    var isSecureTextEntry: Bool = false {
        didSet {
            inputTextField.isSecureTextEntry = isSecureTextEntry
            inputTextField.textContentType = .password
        }
    }

    var color = UIColor.mainBlue {
        didSet {
            titleLabel.textColor = color
            inputTextField.textColor = color
        }
    }

    var error = false {
        didSet {
            inputTextField.layer.borderWidth = 1.3
            if error {
                inputTextField.textColor = .recurFalse
                inputTextField.layer.borderColor = UIColor.recurFalse.cgColor
            } else {
                inputTextField.textColor = color
                inputTextField.layer.borderColor = UIColor.borderBlue.cgColor
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

    private func commonInit() {
        setupUI()
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
    
    private func setupUI() {
        sv(
            titleLabel,
            inputTextField
        )
        titleLabel.height(16).top(0).left(0)
        titleLabel.Right >= Right
        inputTextField.Top == titleLabel.Bottom + 5
        inputTextField.right(0).bottom(0)
        align(lefts: inputTextField, titleLabel)
    }

    @objc private func tapped() {
        inputTextField.becomeFirstResponder()
    }
}
