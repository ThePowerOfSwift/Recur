//
//  Photo.swift
//  Recur
//
//  Created by Sophie on 9/17/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import UIKit
import Novagraph

@objc(Photo)
class Photo: Entity, FetchOrCreatable {
    static let apiName: String = "photo"

    typealias T = Photo

    @NSManaged var bannerURL: String
    @NSManaged var iconURL: String

    override func parse(data: [String: Any]) {
        super.parse(data: data)
        guard let dataDict = data["data"] as? [String: Any],
            let filesArray = dataDict["files"] as? [[String: Any]] else {
                return
        }

        guard !filesArray.isEmpty else { return }
        for (index, fileDict) in filesArray.enumerated() {
            guard let path = fileDict["path"] as? String else { continue }
            if index == 0 {
                bannerURL = path
            } else {
                iconURL = path
            }
        }
    }
}
