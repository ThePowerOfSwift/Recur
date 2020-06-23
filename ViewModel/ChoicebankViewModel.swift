//
//  ChoicebankViewModel.swift
//  Recur
//
//  Created by Leslie Ho on 8/9/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import UIKit

protocol ChoicebankViewModelable {
    var choicebank: [String] { get set }
}

struct ChoicebankViewModel: ChoicebankViewModelable {
    var choicebank: [String]

    init(choicebank: [String]) {
        self.choicebank = choicebank
    }
}
