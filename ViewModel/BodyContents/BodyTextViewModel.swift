//
//  BodyTextViewModel.swift
//  Recur
//
//  Created by Wenyuan Bao on 7/25/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import UIKit

struct BodyTextViewModel: ContentViewModelable {

    var submittable: Bool = false
    var contentText: String
    var attributedContentText = NSMutableAttributedString(string: "")
    let regex = "(\\*{2}[\\w\\d\\p{P}\\p{S}\\h]+?\\*{2})|(`{1}[\\w\\d\\p{S}\\p{P}\\h]+?`{1})"

    init(contentText: String) {
        self.contentText = contentText
        self.attributedContentText = parseRichText(from: contentText)
    }

    func parseRichText(from text: String) -> NSMutableAttributedString {
        var attributedContentArray = text.split(usingRegex: regex).map{ NSMutableAttributedString(string: $0) }
        var matchingWords = text.regexMatches(usingRegex: regex)
        for i in 0..<matchingWords.count {
            let word = matchingWords[i]
            let range = word.fullRange()
            var attributedWord = NSMutableAttributedString(string: "")
            if word.hasPrefix("*") {
                attributedWord = formatBoldText(for: word, with: range)
            }
            if word.hasPrefix("`") {
                attributedWord = formatCodeText(for: word, with: range)
            }
            attributedContentArray.insert(attributedWord, at: (2 * i) + 1)
        }
        return attributedContentArray.reduce(into: NSMutableAttributedString(string: "")) { $0.append($1) }
    }

    func formatBoldText(for text: String, with range: NSRange) -> NSMutableAttributedString {
        let word = String(text.dropFirst(2).dropLast(2))
        return NSMutableAttributedString(string: word, attributes: [.font: UIFont.pageBodyTextBold])
    }

    func formatCodeText(for text: String, with range: NSRange) -> NSMutableAttributedString {
        let word = String(text.dropFirst().dropLast())
        return NSMutableAttributedString(string: word, attributes: [.font: UIFont(name: "Courier", size: 17) ?? UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor.recurBlue])
    }

    func render() -> UIView {
        let bodyLabel = UILabel.createLabel(textStyle: .pageBody)
        bodyLabel.attributedText = attributedContentText
        return bodyLabel
    }
}
