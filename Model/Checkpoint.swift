//
//  Checkpoint.swift
//  Recur
//
//  Created by Allen Miao on 8/1/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import CoreData
import Novagraph

@objc enum CompletionState: Int16 {
    case incomplete = 0
    case pending = 1
    case complete = 2
    case incorrect = 3
}

@objc(Checkpoint)
class Checkpoint: Entity, FetchOrCreatable {
    static let apiName = "checkpoint"

    typealias T = Checkpoint

    @NSManaged var name: String
    @NSManaged var label: String
    @NSManaged var pageId: String
    @NSManaged var startPageId: String
    @NSManaged var completionState: CompletionState
    @NSManaged var lesson: Lesson

    override func parse(data: [String: Any]) {
        super.parse(data: data)
        if let dataDict = data["data"] as? [String: Any] {
            if let name = dataDict["name"] as? String {
                self.name = name
            }
            if let label = dataDict["label"] as? String {
                self.label = label
            }
            if let pageId = dataDict["page_id"] as? String {
                self.pageId = pageId
            }
            if let startPageId = dataDict["start_page_id"] as? String {
                self.startPageId = startPageId
            }
        }
        if let viewerDataDict = data["viewer_data"] as? [String: Any] {
            if let complete = viewerDataDict["complete"] as? Int {
                self.completionState = CompletionState(rawValue: Int16(complete)) ?? .incomplete
            }
        }
    }
}
