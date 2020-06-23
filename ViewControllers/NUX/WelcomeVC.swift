//
//  WelcomeVC.swift
//  Recur
//
//  Created by Leslie Ho on 6/25/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {

    @IBOutlet weak var backgroundImage: RotatingView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var gradientImage: UIImageView!
    @IBOutlet weak var loginViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginViewHeightConstraint: NSLayoutConstraint!

    private let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    private let socialLoginVC = LoginPageVC()
    private let emailLoginVC = EmailLoginVC()

    override func viewDidLoad() {
        super.viewDidLoad()
        logoImage.image = #imageLiteral(resourceName: "light_recur_owl")
        gradientImage.image = #imageLiteral(resourceName: "Gradient")
        socialLoginVC.delegate = self
        emailLoginVC.delegate = self
        add(pageVC, to: loginView)
        pageVC.setViewControllers([socialLoginVC], direction: .forward, animated: false, completion: nil)
        backgroundImage.startRotating()
        registerKeyboardHandlers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if logoImage.frame.height > 150 {
            logoImage.image = #imageLiteral(resourceName: "light_recur_owl")
        } else if logoImage.frame.height <= 150, logoImage.frame.height > 30 {
            logoImage.image = #imageLiteral(resourceName: "recur-icon.png")
        } else {
            logoImage.image = #imageLiteral(resourceName: "recur-mini-icon.png")
        }
    }

    private func registerKeyboardHandlers() {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(notifications: NSNotification) {
        if let userinfo = notifications.userInfo, let frame = userinfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardFrame = frame.cgRectValue
            loginViewBottomConstraint.constant = keyboardFrame.height
            view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        loginViewBottomConstraint.constant = 0
        view.layoutIfNeeded()
    }
}

extension WelcomeVC: LoginPageVCDelegate {
    func emailLoginDidSelect() {
        pageVC.setViewControllers([emailLoginVC], direction: .forward, animated: true, completion: nil)
    }
}

extension WelcomeVC: EmailLoginVCDelegate {
    func emailVCSize(_ vc: EmailLoginVC, hasChanged size: CGSize) {
        loginViewHeightConstraint.constant = size.height
    }
}
