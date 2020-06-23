//
//  Curriculum.swift
//  Recur
//
//  Created by John Ababseh on 7/10/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import CoreData
import Novagraph

@objc(Curriculum)
class Curriculum: Entity, FetchOrCreatable {

    static let apiName = "curriculum"

    static let rootCurriculumId: String = "94a40200-42cf-11e8-8238-8ffbb57f2595"

    typealias T = Curriculum

    @NSManaged var title: String
    @NSManaged var descriptionString: String
    @NSManaged var units: NSMutableOrderedSet

    override func parse(data: [String: Any]) {
        super.parse(data: data)
        if let dataDict = data["data"] as? [String: Any] {
            if let title = dataDict["title"] as? String {
                self.title = title
            }
            if let description = dataDict["description"] as? String {
                self.descriptionString = description
            }
        }
    }
}
