//
//  ProfileNameVC.swift
//  Recur
//
//  Created by Hana on 9/18/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import UIKit
import Stevia

class ProfileNameVC: UIViewController {

    @IBOutlet weak var rotatingView: RotatingView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var topMessageLabel: UILabel!
    @IBOutlet weak var bottomMessageLabel: UILabel!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nextButton: NUXButton!
    @IBOutlet weak var nextButtonBottomConstraint: NSLayoutConstraint!
    
    private let nameFieldVC = NameFieldVC()
    private var activeTextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        rotatingView.startRotating()
        logoImage.image = #imageLiteral(resourceName: "recur-icon")
        add(nameFieldVC, to: nameView)
        configureLogoAndLabels()
        configureMessageLabels()
        configureNextButton()
        configureNameFields()
        registerKeyboardHandlers()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        resetFields()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func nextButtonPressed() {
        updateProfileName()
        let profilePhotoVC = ProfilePhotoVC()
        navigationController?.pushViewController(profilePhotoVC, animated: true)
    }
    
    private func configureMessageLabels() {
        topMessageLabel.font = .boldHeader
        bottomMessageLabel.font = .boldSubtitle
        topMessageLabel.centerHorizontally()
        bottomMessageLabel.centerHorizontally()
        topMessageLabel.top(230)
        bottomMessageLabel.top(260)
    }
    private func configureLogoAndLabels() {
        logoImage.centerHorizontally()
        logoImage.Top == view.Top + 80
    }

    private func resetFields() {
        nameFieldVC.firstNameField.textField.resetColor()
        nameFieldVC.lastNameField.textField.resetColor()
        nextButton.isEnabled = !nameFieldVC.firstNameField.textField.inputText.isEmpty && !nameFieldVC.lastNameField.textField.inputText.isEmpty
    }
    
    private func configureNextButton() {
        nextButton.titleLabel?.font = UIFont(name:"SFCompactRounded-Bold", size: 20)
        nextButton.isEnabled = false
        nextButton.centerHorizontally()
        nextButton.bottom(44)
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
    }
    
    private func configureNameFields() {
        nameFieldVC.firstNameField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        nameFieldVC.lastNameField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    private func updateProfileName() {
        let firstNameField = nameFieldVC.firstNameField
        let firstNameValue = firstNameField.textField.inputText
        let lastNameField = nameFieldVC.lastNameField
        let lastNameValue = lastNameField.textField.inputText

        Profile.currentProfile?.firstName = firstNameValue
        Profile.currentProfile?.lastName = lastNameValue
        LoginInteractor.shared.updateUserProfile(completionHandler: {profile, error in })
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        nextButton.isEnabled = !nameFieldVC.firstNameField.textField.inputText.isEmpty && !nameFieldVC.lastNameField.textField.inputText.isEmpty
    }
    
    private func registerKeyboardHandlers() {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(notifications: NSNotification) {
        if let userinfo = notifications.userInfo, let frame = userinfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardFrame = frame.cgRectValue
            nextButtonBottomConstraint.constant = keyboardFrame.height  - 150
            self.view.frame.origin.y = -170
            view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        nextButtonBottomConstraint.constant = 25
        self.view.frame.origin.y = 0
        view.layoutIfNeeded()
    }

}
