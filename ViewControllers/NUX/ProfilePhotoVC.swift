//
//  ProfilePhotoVC.swift
//  Recur
//
//  Created by Maribel Montejano on 9/18/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import UIKit
import Stevia

class ProfilePhotoVC: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var rotatingView: RotatingView!
    @IBOutlet weak var addProfilePhotoLabel: UILabel!
    @IBOutlet weak var profilePhotoView: UIImageView!
    @IBOutlet weak var addPictureButton: UIButton!
    @IBOutlet weak var letsGoButton: UIButton!
    private let imageInteractor = ImageInteractor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Profile.currentProfile?.attachObserver(self)
        configureLabelAndButtons()
        setCornerRadiusForImage()
        getProfilePicture()
        rotatingView.startRotating()
    }
    
    @objc private func addPictureButtonPressed() {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        imagePickerVC.allowsEditing = true
        let actionSheet = UIAlertController(title: "Add Profile Picture", message: nil, preferredStyle: .actionSheet)
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { [weak self] action in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerVC.sourceType = .camera
            } else {
                imagePickerVC.sourceType = .photoLibrary
            }
            self?.present(imagePickerVC, animated: true, completion: nil)
        }
        let chooseFromLibrary = UIAlertAction(title: "Choose from Library", style: .default) { [weak self] action in
            imagePickerVC.sourceType = .photoLibrary
            self?.present(imagePickerVC, animated: true, completion: nil)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] action in
            self?.dismiss(animated: true, completion: nil)
        }
        actionSheet.addAction(takePhoto)
        actionSheet.addAction(chooseFromLibrary)
        actionSheet.addAction(cancelButton)
        present(actionSheet, animated: true) { [weak self] in
            self?.addPictureButton.setTitle("Change Profile Picture", for: .normal)
        }
    }

    private func setCornerRadiusForImage() {
        profilePhotoView.layer.cornerRadius = profilePhotoView.frame.height / 2
    }

    private func configureLabelAndButtons() {
        view.sv(logoImageView,
                addProfilePhotoLabel,
                profilePhotoView,
                addPictureButton,
                letsGoButton)
        logoImageView.centerHorizontally()
        logoImageView.top(60)
        addProfilePhotoLabel.textColor = .nuxGray
        addProfilePhotoLabel.top(170)
        addProfilePhotoLabel.centerHorizontally()
        addProfilePhotoLabel.font = .nuxTitle
        profilePhotoView.top(250)
        profilePhotoView.centerHorizontally()
        addPictureButton.setTitleColor(.recurBlue, for: .normal)
        addPictureButton.top(450)
        addPictureButton.titleLabel?.font = .nuxButtonText
        addPictureButton.centerHorizontally()
        letsGoButton.bottom(44)
        letsGoButton.isEnabled = false
        letsGoButton.setTitle("Let's Go!", for: .normal)
        letsGoButton.centerHorizontally()
        letsGoButton.titleLabel?.font = UIFont(name:"SFCompactRounded-Bold", size: 20)
        addPictureButton.addTarget(self, action: #selector(addPictureButtonPressed), for: .touchUpInside)
        letsGoButton.addTarget(self, action: #selector(letsGoButtonPressed), for: .touchUpInside)
    }

    private func getProfilePicture() {
        if let photoURLString = Profile.currentProfile?.photoUrl {
            if let photoURL = URL(string: photoURLString) {
                if let photoData = try? Data(contentsOf: photoURL) {
                    self.profilePhotoView.image = UIImage(data: photoData)
                    self.letsGoButton.isEnabled = true
                }
            }
        } else {
            self.profilePhotoView.image = UIImage(named: "default-profile-icon")
        }
    }

    @objc private func letsGoButtonPressed() {
        guard let image = profilePhotoView.image else { return }
        imageInteractor.uploadImage(image) { (photo, error) in
            if photo != nil, error == nil {
                LoginPresenter.transitionToLoggedIn()
            }
        }
    }
}

extension ProfilePhotoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if let profileImageViewSize = profilePhotoView.image?.size {
                let resizedImage = resizeImage(image: editedImage, newSize: profileImageViewSize)
                profilePhotoView.image = resizedImage
                letsGoButton.isEnabled = true
            }
        }
        dismiss(animated: true, completion: nil)
    }
}

extension ProfilePhotoVC {
    private func resizeImage(image: UIImage, newSize size: CGSize) -> UIImage? {
        if __CGSizeEqualToSize(image.size, size) {
            return image
        }
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension ProfilePhotoVC: ProfileObserver {
    func update(_ observedProperty: ObservedProperty) {
        if observedProperty == .photoUrl {
            getProfilePicture()
        }
    }
}
