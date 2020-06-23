//
//  CodeblockViewModel.swift
//  Recur
//
//  Created by Allen Miao on 9/3/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import UIKit

class CodeblockViewModel: NSObject, ContentViewModelable {
    var contentText: String = ""
    var submittable: Bool = false

    init(codeblock: Codeblock) {
        self.contentText = codeblock.text ?? ""
    }

    func render() -> UIView {
        let container = CodeblockContainer()
        container.text = contentText
        return container
    }
}
