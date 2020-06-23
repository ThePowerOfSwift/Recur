//
//  LoginPageVC.swift
//  Recur
//
//  Created by Leslie Ho on 6/25/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import UIKit
import Stevia

protocol LoginPageVCDelegate: class {
    func emailLoginDidSelect()
}

class LoginPageVC: UIViewController {

    private lazy var loginPresenter = LoginPresenter(baseVC: self)

    private lazy var containerView = UIView(frame: view.bounds)
    weak var delegate: LoginPageVCDelegate?
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(frame: view.bounds)
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 18
        stack.alignment = .fill
        return stack
    }()

    private let facebookLoginButton: UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.setImage(#imageLiteral(resourceName: "facebook"), for: .normal)
        button.backgroundColor = .mainBlue
        button.setTitle("Continue with Facebook", for: .normal)
        button.tintColor = .white
        return button
    }()

    private let googleLoginButton: UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.setImage(#imageLiteral(resourceName: "google_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        button.backgroundColor = .white
        button.setTitle("Continue with Google", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        return button
    }()

    private let emailLoginButton: UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.setTitle("Continue with Email", for: .normal)
        button.setTitleColor(.mainBlue, for: .normal)
        button.titleLabel?.font = .semiboldTitle
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.sv(
            containerView.sv(
                stackView)
        )

        facebookLoginButton.configureAsLoginButton()
        googleLoginButton.configureAsLoginButton()

        facebookLoginButton.addTarget(self, action: #selector(facebookLoginPressed), for: .touchUpInside)
        googleLoginButton.addTarget(self, action: #selector(googleLoginPressed), for: .touchUpInside)
        emailLoginButton.addTarget(self, action: #selector(emailLoginPressed), for: .touchUpInside)

        setUpViews()
    }

    private func setUpViews() {
        containerView.centerInContainer().height(self.view.bounds.height/2).left(12).right(12)

        stackView.addArrangedSubview(facebookLoginButton)
        stackView.addArrangedSubview(googleLoginButton)
        stackView.addArrangedSubview(emailLoginButton)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 24, leading: 24, bottom: 24, trailing: 24)
        stackView.fillContainer()
    }

    @objc func facebookLoginPressed() {
        loginPresenter.signInWithFacebook()
    }

    @objc func googleLoginPressed() {
        loginPresenter.signInWithGoogle()
    }

    @objc func emailLoginPressed() {
        delegate?.emailLoginDidSelect()
    }
}
