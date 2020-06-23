//
//  EmailLoginVC.swift
//  Recur
//
//  Created by Wenyuan Bao & Dread Pirate Nic on 6/27/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import UIKit
import Stevia

protocol EmailLoginVCDelegate: class {
    func emailVCSize(_ vc: EmailLoginVC, hasChanged size: CGSize)
}

class EmailLoginVC: UIViewController {
    
    lazy var loginPresenter = LoginPresenter(baseVC: self)
    weak var delegate: EmailLoginVCDelegate?

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: view.bounds)
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 18
        stackView.alignment = .fill
        return stackView
    }()

    private let emailField = EmailField()
    private let passwordField = PasswordField()
    private let loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .mainBlue
        button.setTitle("Create Account/Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.configureAsLoginButton()
        addSubviews()
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        loginPresenter.delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        stackView.frame = CGRect(x: 32, y: view.bounds.minY, width: view.bounds.width - 64, height: view.bounds.height)
    }

    private func addSubviews() {
        view.addSubview(stackView)
        emailField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.height(55)
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(loginButton)
        stackView.addArrangedSubview(UIView())
    }

    // MARK: - Private
    
    @objc private func loginButtonTapped() {
        let emailValid = emailField.isValid(showErrors: true)
        let passwordValid = passwordField.isValid(showErrors: true)
        let size = stackView.systemLayoutSizeFitting(width: view.frame.width)
        delegate?.emailVCSize(self, hasChanged: size)
        if let email = emailField.textField.inputText, let password = passwordField.textField.inputText, emailValid, passwordValid {
            loginPresenter.signupOrSignin(email: email, password: password)
        }
    }
}

extension EmailLoginVC: LoginPresenterDelegate {
    func loginPresenter(_ loginPresenter: LoginPresenter, error: Error) {
        passwordField.presentInvalidPasswordError()
    }
}
