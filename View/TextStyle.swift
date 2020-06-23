//
//  TextStyle.swift
//  Recur
//
//  Created by Wenyuan Bao on 7/24/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import UIKit

enum TextStyle {
    case pageTitle, pageBody, codeBlock
    
    func font() -> UIFont {
        switch self {
        case .pageTitle:
            return .titleText
        case .pageBody:
            return .pageBodyText
        case .codeBlock:
            return .standardBody
        }
    }
    
    func textColor() -> UIColor {
        switch self {
        case .pageTitle:
            return .darkGray
        case .pageBody:
            return .darkGray
        case .codeBlock:
            return .white
        }
    }
    
    func backgroundColor() -> UIColor? {
        switch self {
        case .pageTitle:
            return .white
        case .pageBody:
            return .white
        case .codeBlock:
            return .darkGray
        }
    }
}
