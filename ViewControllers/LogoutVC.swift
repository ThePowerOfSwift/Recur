//
//  LogoutVC.swift
//  Recur
//
//  Created by Wenyuan Bao on 7/23/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import UIKit
import Alamofire
import Novagraph

class LogoutVC: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var tokenButton: UIButton!
    @IBOutlet weak var logOutLabel: UILabel!
    private let imageInteractor = ImageInteractor()

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(signout))
        logOutLabel.addGestureRecognizer(tap)
        tokenButton.addTarget(self, action: #selector(printToken), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        downloadProfilePhoto()
        setProfileNameLabel()
        setCornerRadiusForImage()
    }
    
    @objc private func signout() {
        LoginInteractor.shared.signout()
    }

    @objc private func printToken() {
        CognitoService.shared.currentAccessToken { (token, error) in
            if let token = token {
                UIPasteboard.general.string = token
                NSLog("token:\n\(token)")
            }
            if let error = error {
                NSLog("error getting token: \(error.localizedDescription)")
            }
        }
    }

    private func setCornerRadiusForImage() {
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
    }

    private func downloadProfilePhoto() {
        imageInteractor.fetchPhoto { (photo, error) in
            guard let photoURL = photo?.iconURL else { return }
            guard let url = URL(string: photoURL) else { return }
            Alamofire.request(url).responseData { (response) in
                if let data = response.data {
                    if let profileImage = UIImage(data: data) {
                        self.profileImageView.image = profileImage
                    }
                }
            }
        }
    }

    private func setProfileNameLabel() {
        guard let profile = Profile.currentProfile else { return }
        profileNameLabel.text = profile.fullName
    }
}
