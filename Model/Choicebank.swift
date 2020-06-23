//
//  Choicebank.swift
//  Recur
//
//  Created by Leslie Ho on 8/9/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import CoreData
import Novagraph

@objc(Choicebank)
class Choicebank: Entity, FetchOrCreatable {
    static let apiName = "choicebank"

    typealias T = Choicebank

    @NSManaged var page: Page?

    var choices: [String] = []

    override func parse(data: [String : Any]) {
        if let dataDict = data["choices"] as? [[String: String]] {
            for choicesDict in dataDict {
                if let text = choicesDict["text"] {
                    choices.append(text)
                }
            }
        }
    }
}
