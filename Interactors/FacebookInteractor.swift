//
//  FacebookInteractor.swift
//  Recur
//
//  Created by Wenyuan Bao on 8/5/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import UIKit
import Foundation
import FBSDKCoreKit
import FBSDKLoginKit

class FacebookInteractor: Interactor {
    
    static let shared = FacebookInteractor()

    static func hasFBToken() -> Bool {
        return AccessToken.current != nil
    }
    
    func updateCurrentProfileFromFB(completionHandler: @escaping ((Error?) -> Void)) {
        guard let profile = Profile.currentProfile else {
            completionHandler(nil)
            return
        }
        self.copyProfileFieldsFromFB { (error) in
            guard error != nil else {
                completionHandler(error)
                return
            }
            LoginInteractor.shared.createOrUpdateViewer(profile: profile, completionHandler: { (_, error) in
                completionHandler(error)
            })
        }
    }
    
    func copyProfileFieldsFromFB(completionHandler: @escaping ((Error?) -> Void)) {
        guard AccessToken.current != nil else { return }
        let request = GraphRequest(graphPath: "me",
                                   parameters: ["fields": "email,first_name,last_name,gender, picture.width(480).height(480)"])
        request.start(completionHandler: { (_, result, error) in
            if let data = result as? [String: Any] {
                if let firstName = data["first_name"] {
                    Profile.currentProfile?.firstName = firstName as? String ?? ""
                }
                if let lastName = data["last_name"] {
                    Profile.currentProfile?.lastName = lastName as? String ?? ""
                }
                if let email = data["email"] {
                    Profile.currentProfile?.email = email as? String
                }
                if let picture = data["picture"] as? [String: Any] {
                    if let imageData = picture["data"] as? [String: Any] {
                        if let url = imageData["url"] as? String {
                            Profile.currentProfile?.photoUrl = url
                        }
                    }

                }
            }
            completionHandler(error)
        })
    }
}
