//
//  PageContentViewModel.swift
//  Recur
//
//  Created by Wenyuan Bao on 7/24/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import UIKit

protocol ContentViewModelable {
    var contentText: String { get }
    var submittable: Bool { get }
    func render() -> UIView
}

protocol ContentPageViewModelable {
    var title: String { get }
    var submittable: Bool { get }
    var bodyViews: [UIView] { get }
}

struct ContentPageViewModel: ContentPageViewModelable {
    let title: String
    var submittable: Bool
    var bodyViews: [UIView] = []
    let bodyContents: [ContentViewModelable]
    let choicebank: [String]
    
    init(page: Page, submittable: Bool = false) {
        title = page.title
        bodyContents = page.bodyContents
        choicebank = page.choicebanks
        self.submittable = submittable
        for content in bodyContents {
            if content.submittable {
                self.submittable = true
            }
            bodyViews.append(content.render())
        }
    }
}
