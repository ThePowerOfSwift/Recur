//
//  Profile.swift
//  Recur
//
//  Created by John Ababseh on 6/28/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import Novagraph
import CoreData

@objc enum NuxCompletionStatus: Int16 {
    case needsNameAndPhoto = 0
    case needsPhoto = 1
    case complete = 2
}

enum ObservedProperty {
    case photoUrl, name
}

protocol ProfileObserver: class {
    func update(_ observedProperty: ObservedProperty)
}

@objc(Profile)
class Profile: Entity, FetchOrCreatable {
    static let apiName = "profile"

    typealias T = Profile

    static var currentProfile: Profile? = nil

    @NSManaged var email: String?
    @NSManaged var photoId: String?
    @NSManaged private var privateFirstName: String?
    @NSManaged private var privateLastName: String?
    @NSManaged private var privatePhotoUrl: String?

    var firstName: String {
        set {
            privateFirstName = newValue
            self.notify(.name)
        }
        get {
            return privateFirstName ?? ""
        }
    }
    var lastName: String {
        set {
            privateLastName = newValue
            self.notify(.name)
        }
        get {
            return privateLastName ?? ""
        }
    }

    var photoUrl: String {
        set {
            privatePhotoUrl = newValue
            self.notify(.photoUrl)
        }
        get {
            return privatePhotoUrl ?? ""
        }
    }

    struct Observation {
        weak var observer: ProfileObserver?
    }

    var observations = [ObjectIdentifier : Observation]()

    var fullName: String? {
        get {
            var name = ""
            if let firstName = privateFirstName {
                name += firstName
            }
            if let lastName = privateLastName {
                name += name.isEmpty ? lastName : " \(lastName)"
            }
            return name
        }
    }

    func attachObserver(_ observer : ProfileObserver){
        let id = ObjectIdentifier(observer)
        observations[id] = Observation(observer: observer)
    }

    private func notify(_ observedProperty: ObservedProperty){
        for (id, observation) in observations {
            guard let observer = observation.observer else {
                observations.removeValue(forKey: id)
                continue
            }
            observer.update(observedProperty)
        }
    }

    func removeObserver(observer : ProfileObserver) {
        let id = ObjectIdentifier(observer)
        observations.removeValue(forKey: id)
    }

    override func parse(data: [String: Any]) {
        super.parse(data: data)
        if let dataDict = data["data"] as? [String: Any] {
            if let firstName = dataDict["first_name"] as? String {
                self.firstName = firstName
            }
            if let lastName = dataDict["last_name"] as? String {
                self.lastName = lastName
            }
            if let email = dataDict["email"] as? String {
                self.email = email
            }
            if let photoId = dataDict["photo_id"] as? String {
                self.photoId = photoId
            }
        }
    }

    func makeDict() -> [String: Any] {
        var dict = [String: Any]()
        if let firstName = self.privateFirstName {
            dict["first_name"] = firstName
        }
        if let lastName = self.privateLastName {
            dict["last_name"] = lastName
        }
        if let email = self.email {
            dict["email"] = email
        }
        if let photoId = self.photoId {
            dict["photo_id"] = photoId
        }
        return dict
    }

    var isCurrentProfile: Bool {
        guard let currentProfile = Profile.currentProfile else { return false }
        return currentProfile == self
    }
    
    func getNuxStatus() -> NuxCompletionStatus {
        let needsProfilePhoto = photoId == nil
        let needsName = privateFirstName == nil || privateLastName == nil
        let nuxStatus: NuxCompletionStatus
        if  !needsName && !needsProfilePhoto {
            nuxStatus = NuxCompletionStatus.complete
        } else if !needsName {
            nuxStatus = NuxCompletionStatus.needsPhoto
        } else {
            nuxStatus = NuxCompletionStatus.needsNameAndPhoto
        }
        return nuxStatus
    }
    
    func updateProfile() {
        guard let profile = Profile.currentProfile else { return }
        LoginInteractor.shared.createOrUpdateViewer(profile: profile, completionHandler: { (_, error) in
        })
    }
}
