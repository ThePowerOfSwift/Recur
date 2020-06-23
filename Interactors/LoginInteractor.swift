//
//  LoginInteractor.swift
//  Recur
//
//  Created by John Ababseh on 6/27/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import UIKit
import Novagraph
import AWSCognito
import AWSCognitoAuth
import AWSCognitoIdentityProvider
import FBSDKLoginKit
import GoogleSignIn

class LoginInteractor: Interactor {

    static let shared = LoginInteractor()

    func signUp(email: String, password: String, completionHandler: @escaping (String?, Error?) -> Void) {
        var attributes = [AWSCognitoIdentityUserAttributeType]()
        let email = email
        let md5Attribute = AWSCognitoIdentityUserAttributeType()!
        md5Attribute.name = "email"
        md5Attribute.value = email
        attributes.append(md5Attribute)
        CognitoUserPoolService.shared.pool.signUp(email.emailmd5, password: password, userAttributes: attributes, validationData: nil).continueWith { (response) -> Any? in
            if let error = response.error {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return nil
            }
            self.signIn(email: email, password: password, completionHandler: { (token, error) in
                DispatchQueue.main.async {
                    completionHandler(token, error)
                }
            })
            return nil
        }
    }

    func signIn(email: String, password: String, completionHandler: ((String?, Error?) -> Void)? = nil) {
        let user = CognitoUserPoolService.shared.pool.getUser(email)
        user.getSession(email, password: password, validationData: nil).continueWith { (task) -> Any? in
            if task.error == nil {
                CognitoService.shared.signInToIdentityPool(completionHandler: { (token, error) in
                    DispatchQueue.main.async {
                        completionHandler?(token, error)
                    }
                })
            } else {
                DispatchQueue.main.async {
                    completionHandler?(nil, task.error)
                }
            }
            return nil
        }
    }

    func signInWithFacebook(_ baseVC: UIViewController, completionHandler: @escaping ((Bool, Error?) -> Void)) {
        let manager = LoginManager()
        manager.logIn(permissions: ["public_profile"], from: baseVC) { (result, error) in
            completionHandler(result?.token != nil, error)
        }
    }

    func signInToIdentityPool(completionHandler: @escaping ((String?, Error?) -> Void)) {
        CognitoService.shared.signInToIdentityPool { (tokenString, error) in
            guard tokenString != nil else {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }
            DispatchQueue.main.async {
                completionHandler(tokenString, error)
            }
        }
    }
    
    func signout() {
        CognitoUserPoolService.shared.pool.currentUser()?.signOutAndClearLastKnownUser()
        CognitoService.shared.signout()
        if AccessToken.current != nil {
            LoginManager().logOut()
        }
        GIDSignIn.sharedInstance()?.signOut()
        Profile.currentProfile = nil
        CoreDataManager.resetStore()
        LoginPresenter.transitionToWelcome()
    }

    func fetchOrCreateViewer(completionHandler:@escaping ((Profile?, Error?) -> Void)) {
        fetchViewer { (viewer, error) in
            if let viewer = viewer {
                completionHandler(viewer, error)
            } else {
                let viewer = Profile.createNew()
                self.createOrUpdateViewer(profile: viewer, completionHandler: { (profile, error) in
                    completionHandler(profile, error)
                })
            }
        }
    }
    
    func updateUserProfile(completionHandler:@escaping ((Profile?, Error?) -> Void)) {
        fetchViewer { (viewer, error) in
            if let viewer = viewer {
                completionHandler(viewer, error)
                self.createOrUpdateViewer(profile: viewer, completionHandler: { (profile, error) in
                    completionHandler(profile, error)
                })
            }
        }
    }

    func createOrUpdateViewer(profile: Profile, completionHandler: @escaping ((Profile?, Error?) -> Void)) {
        let params = ["data": profile.makeDict()] as [String: Any]
        let request = NovaRequest(method: .post, path: "viewer", params: params)
        Novanet.shared.send(request: request) { (data, error) in
            let profiles = self.fetchOrCreateObjects(from: data) as? [Profile]
            guard profiles?.count == 1, let profile = profiles?.first else {
                completionHandler(nil, error)
                return
            }
            Profile.currentProfile = profile
            DispatchQueue.main.async {
                completionHandler(Profile.currentProfile, error)
            }
        }
    }
    
    func fetchViewer(completionHandler:@escaping ((Profile?, Error?) -> Void)) {
        let params = ["query": "query execute { viewer }"]
        let request = NovaRequest(method: .post, path: "graph/get", params: params)
        Novanet.shared.send(request: request) { (data, error) in
            let profiles = self.fetchOrCreateObjects(from: data) as? [Profile]
            guard profiles?.count == 1, let profile = profiles?.first else {
                completionHandler(nil, error)
                return
            }
            Profile.currentProfile = profile
            DispatchQueue.main.async {
                completionHandler(Profile.currentProfile, error)
            }
        }
    }
}
