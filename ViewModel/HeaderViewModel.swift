//
//  HeaderViewModel.swift
//  Recur
//
//  Created by John Ababseh on 7/11/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import UIKit

protocol HeaderViewModelable {
    var title: String { get }
}

struct HeaderViewModel: HeaderViewModelable {
    var title: String

    init(unit: Unit) {
        title = unit.title
    }
}
