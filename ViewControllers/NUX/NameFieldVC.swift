//
//  NameFieldVC.swift
//  Recur
//
//  Created by Hana on 9/24/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import UIKit
import Stevia

class NameFieldVC: UIViewController {

    let firstNameField = FirstNameField()
    let lastNameField = LastNameField()

    override func viewDidLoad() {
        super.viewDidLoad()
        Profile.currentProfile?.attachObserver(self)
        addAndSetupSubviews()
        getProfileName()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
                            
    }

    private func getProfileName() {
        if let profile = Profile.currentProfile {
            firstNameField.text = profile.firstName
            lastNameField.text = profile.lastName
        }
    }

    private func addAndSetupSubviews() {

        view.sv(
            firstNameField,
            lastNameField
        )
        firstNameField.Bottom == lastNameField.Top - 10
        firstNameField.top(0)
        firstNameField.centerHorizontally()
        lastNameField.centerHorizontally()
    }
    
    @objc func nextButtonPressed() {
        updateProfileName()
        let profilePhotoVC = ProfilePhotoVC()
        navigationController?.pushViewController(profilePhotoVC, animated: true)
    }
    
    private func updateProfileName() {
        if let profile = Profile.currentProfile {
            profile.firstName = firstNameField.textField.inputText
            profile.lastName = lastNameField.textField.inputText
            LoginInteractor.shared.updateUserProfile(completionHandler: {error, message in })
        }
    }
}

extension NameFieldVC: ProfileObserver {

    func update(_ observedProperty: ObservedProperty) {
        if observedProperty == .name {
            getProfileName()
        }
    }
}
