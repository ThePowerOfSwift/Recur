//
//  Unit.swift
//  Recur
//
//  Created by John Ababseh on 7/9/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import CoreData
import Novagraph

@objc(Unit)
class Unit: Entity, FetchOrCreatable {
    static let apiName = "unit"

    typealias T = Unit

    @NSManaged var title: String
    @NSManaged var curriculum: Curriculum
    @NSManaged var lessons: NSMutableOrderedSet

    static var rootUnitId: String = "94b9ace0-42cf-11e8-8238-8ffbb57f2595"

    override func parse(data: [String: Any]) {
        super.parse(data: data)
        if let dataDict = data["data"] as? [String: Any] {
            if let title = dataDict["title"] as? String {
                self.title = title
            }
        }
    }

    func sortLessons() {
        let sortDescriptor = NSSortDescriptor(key: nil, ascending: true, comparator: { (lesson1, lesson2) -> ComparisonResult in
            guard let l1 = lesson1 as? Lesson ,
                let l2 = lesson2 as? Lesson else { return .orderedSame }
            if l1.order < l2.order { return .orderedAscending }
            else if l1.order > l2.order { return .orderedDescending }
            else { return .orderedSame }
        })
        self.lessons.sort(using: [sortDescriptor])
    }
}
