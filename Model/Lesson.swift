//
//  Lesson.swift
//  Recur
//
//  Created by John Ababseh on 7/9/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import CoreData
import Novagraph

@objc(Lesson)
class Lesson: Entity, FetchOrCreatable {
    static let apiName = "lesson"

    typealias T = Lesson

    @NSManaged var title: String
    @NSManaged var descriptionString: String
    @NSManaged var unit: Unit
    @NSManaged var pages: NSMutableOrderedSet
    @NSManaged var checkpoints: NSMutableOrderedSet
    @NSManaged var order: Int16

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

    func sortPages() {
        let sortDescriptor = NSSortDescriptor(key: nil, ascending: true, comparator: { (page1, page2) -> ComparisonResult in
            guard let p1 = page1 as? Page ,
                let p2 = page2 as? Page else { return .orderedSame }
            if p1.order < p2.order { return .orderedAscending }
            else if p1.order > p2.order { return .orderedDescending }
            else { return .orderedSame }
        })
        self.pages.sort(using: [sortDescriptor])
    }

    func nextLesson() -> Lesson? {
        let nextIndex = unit.lessons.index(of: self) + 1
        guard nextIndex < unit.lessons.count else { return nil }
        return unit.lessons[nextIndex] as? Lesson
    }
}
