//
//  GoogleInteractor.swift
//  Recur
//
//  Created by Wenyuan Bao on 8/7/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import Foundation
import GoogleSignIn

class GoogleInteractor: Interactor {

    static let shared = GoogleInteractor()

    func updateCurrentProfileFromGoogle(completionHandler: @escaping ((Error?) -> Void)) {
        guard let profile = Profile.currentProfile else {
            completionHandler(nil)
            return
        }
        self.copyProfileFieldsFromGoogle()
        LoginInteractor.shared.createOrUpdateViewer(profile: profile, completionHandler: { (_, error) in
            completionHandler(error)
        })
    }
    
    func copyProfileFieldsFromGoogle() {
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            guard let profile = GIDSignIn.sharedInstance()?.currentUser?.profile else { return }
            Profile.currentProfile?.email = profile.email
            Profile.currentProfile?.firstName = profile.givenName
            Profile.currentProfile?.lastName = profile.familyName
            if profile.hasImage {
                if let imageURL = profile.imageURL(withDimension: 100) {
                    Profile.currentProfile?.photoUrl = "\(imageURL)"
                }
            }
        }
    }
}
