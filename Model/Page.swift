//
//  Page.swift
//  Recur
//
//  Created by Leslie Ho on 7/23/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import CoreData
import Novagraph

@objc(Page)
class Page: Entity, FetchOrCreatable {
    static let apiName = "page"
    
    typealias T = Page
    
    @NSManaged var title: String
    @NSManaged var rawBody: String
    @NSManaged var lesson: Lesson
    @NSManaged var choicebank: NSMutableOrderedSet
    @NSManaged var order: Int16

    var choicebanks: [String] = []
    var bodyContents: [ContentViewModelable] = []
    var codeblocks: [Codeblock] = []

    override func parse(data: [String: Any]) {
        super.parse(data: data)
        if let dataDict = data["data"] as? [String: Any] {
            if let title = dataDict["title"] as? String {
                self.title = title
            }
            if let blocks = dataDict["blocks"] as? [String: Any] {
                for (key, value) in blocks {
                    if key.contains("choicebank") {
                        if let data = value as? [String: Any] {
                            let choicebank = Choicebank.createNew()
                            choicebank.parse(data: data)
                            choicebanks += choicebank.choices
                        }
                    }
                    if key.contains("codeblock") {
                        if let data = value as? [String: Any] {
                            let codeblock = Codeblock()
                            codeblock.parse(data: data)
                            codeblocks.append(codeblock)
                        }
                    }
                }
            }
            if let text = dataDict["text"] as? String {
                rawBody = text
                bodyContents = parseBodyTexts(with: text)
            }
        }
    }

    private func parseBodyTexts(with rawBody: String) -> [ContentViewModelable] {
        let htmlTagRegex = "<(\\w+)>"
        var bodyContentTexts = rawBody.split(usingRegex: htmlTagRegex)
        let contents = rawBody.regexMatches(usingRegex: htmlTagRegex)
        for i in 0..<contents.count {
            bodyContentTexts.insert(contents[i], at: (2 * i) + 1)
        }
        bodyContentTexts = bodyContentTexts.filter { !$0.isEmpty }
        var bodyContents: [ContentViewModelable] = []
        var bodyCodeblocks = codeblocks
        for contentText in bodyContentTexts {
            if contentText.contains("codeblock_") {
                let codeblock = bodyCodeblocks.removeFirst()
                bodyContents.append(CodeblockViewModel(codeblock: codeblock))
            } else if contentText.contains("file_") {
                //TODO Prompt user to download the file in their computer
                continue
            } else if contentText.contains("submission_") {
            } else if contentText.contains("image_") {
            } else if contentText.contains("video_") {
            } else if contentText.contains("choicebank_") {
                // do nothing
                continue
            } else {
                bodyContents.append(BodyTextViewModel(contentText: contentText))
            }
        }
        return bodyContents
    }
}
