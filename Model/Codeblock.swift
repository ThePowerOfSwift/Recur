//
//  Codeblock.swift
//  Recur
//
//  Created by Allen Miao on 8/28/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import Foundation

class Codeblock: NSObject {

    var text: String?
    var outputText: String?

    func parse(data: [String: Any]) {
        if let text = data["text"] as? String {
            self.text = text
        }
        if let output = data["run_outputs"] as? [String: Any],
            let outputText = output["text"] as? String {
            self.outputText = outputText
        }
    }
}
