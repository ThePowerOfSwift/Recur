//
//  AppDelegate.swift
//  Recur
//
//  Created by Sophie on 6/25/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import UIKit
import Novagraph
import GoogleSignIn
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let vc = ViewController()
        window = UIWindow()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()

        setupCoreData()
        setupGoogleSignin()
        setupCognito()

        NovaRequest.defaultDomain = "https://api.buildschool.io"
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        CognitoService.shared.currentAccessToken { (token, _) in
            DispatchQueue.main.async {
                if token != nil {
                    LoginInteractor.shared.fetchViewer(completionHandler: { (profile, error) in
                        if profile != nil, error == nil {
                            Profile.currentProfile = profile
                            LoginPresenter.transitionToLoggedIn()
                        }
                        return
                    })
                } else {
                    LoginPresenter.transitionToWelcome()
                }
            }
        }
        return true
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        var handled = ApplicationDelegate.shared.application(application,
                                                             open: url,
                                                             sourceApplication: sourceApplication,
                                                             annotation: annotation)
        if !handled {
            handled = GIDSignIn.sharedInstance()?.handle(url,
                                                         sourceApplication: sourceApplication,
                                                         annotation: annotation) ?? false
        }
        return handled
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = ApplicationDelegate.shared.application(app, open: url, options: options)
        return handled
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }

    // MARK: - Private

    private func setupCoreData() {
        CoreDataManager.containerName = "Recur"
        CoreDataManager.setUpCoreDataStack(retry: true)
    }

    private func setupGoogleSignin() {
        GIDSignIn.sharedInstance().clientID = "440266153340-l2akpj4og2bu2eh1bbv0qaudrm6l9ues.apps.googleusercontent.com"
    }

    private func setupCognito() {
        let serverConfig = currentServerConfiguration()
        IdentityProvider.setup(with: serverConfig)
        CognitoService.setup(with: IdentityProvider.shared, serverConfiguration: serverConfig)
        CognitoUserPoolService.setup(with: serverConfig)
    }
}
