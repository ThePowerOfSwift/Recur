//
//  Interactor.swift
//  Recur
//
//  Created by Allen Miao on 7/15/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import Foundation

enum EdgeType: String {

    case curriculumUnit = "curriculum/unit"
    case unitLesson = "unit/lesson"
    case lessonCheckpoint = "lesson/checkpoint"
    case lessonPage = "lesson/page"
}

class Interactor: NSObject {

    @discardableResult func fetchOrCreateObjects(from data: Any?) -> [Any] {
        var objects: [Any] = []
        guard let dict = data as? [String: Any], let objectsDict = dict["objects"] as? [String: Any] else { return [] }
        for (_, value) in objectsDict {
            guard let objectDict = value as? [String: Any] else { continue }
            guard let type = objectDict["type"] as? String else { continue }
            if type == "curriculum" {
                if let curriculum = Curriculum.fetchOrCreate(with: objectDict) {
                    objects.append(curriculum)
                }
            } else if type == "unit" {
                if let unit = Unit.fetchOrCreate(with: objectDict) {
                    objects.append(unit)
                }
            } else if type == "lesson" {
                if let lesson = Lesson.fetchOrCreate(with: objectDict) {
                    objects.append(lesson)
                }
            } else if type == "checkpoint" {
                if let checkpoint = Checkpoint.fetchOrCreate(with: objectDict) {
                    objects.append(checkpoint)
                }
            } else if type == "page" {
                if let profile = Page.fetchOrCreate(with: objectDict) {
                    objects.append(profile)
                }
            } else if type == "profile" {
                if let profile = Profile.fetchOrCreate(with: objectDict) {
                    objects.append(profile)
                }
            } else if type == "photo" {
                if let photo = Photo.fetchOrCreate(with: objectDict) {
                    objects.append(photo)
                }
            }
        }
        return objects
    }

    func processEdges(from data: Any?, shouldClearRelationship: Bool = false) {
        guard let dict = data as? [String: Any], let edges = dict["edges"] as? [[String: Any]] else { return }
        for edgeDict in edges {
            self.processEdge(dict: edgeDict)
        }
    }

    func processEdge(dict: [String: Any]) {
        guard let fromId = dict["from_id"] as? String else { return }
        guard let toId = dict["to_id"] as? String else { return }
        guard let type = dict["type"] as? String else { return }
        let data = dict["data"] as? String
        guard let edge = EdgeType(rawValue: type) else {
            return
        }
        switch edge {
        case .curriculumUnit:
            if let curriculum = Curriculum.fetch(with: fromId),
                let unit = Unit.fetch(with: toId) {
                curriculum.units.add(unit)
            }
        case .unitLesson:
            if let unit = Unit.fetch(with: fromId),
                let lesson = Lesson.fetch(with: toId) {
                unit.lessons.add(lesson)
                lesson.unit = unit
                if let data = data,
                    let orderString = data.regexMatches(usingRegex: "(\\d+)").first,
                    let order = Int16(orderString) {
                    lesson.order = order
                }
            }
        case .lessonCheckpoint:
            if let lesson = Lesson.fetch(with: fromId),
                let checkpoint = Checkpoint.fetch(with: toId) {
                lesson.checkpoints.add(checkpoint)
                checkpoint.lesson = lesson
            }
        case .lessonPage:
            if let lesson = Lesson.fetch(with: fromId),
                let page = Page.fetch(with: toId) {
                lesson.pages.add(page)
                page.lesson = lesson
                if let data = data,
                    let orderString = data.regexMatches(usingRegex: "(\\d+)").first,
                    let order = Int16(orderString) {
                    page.order = order
                }
            }
        }
    }
}
