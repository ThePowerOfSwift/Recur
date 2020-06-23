//
//  LabelHeaderView.swift
//  Recur
//
//  Created by John Ababseh on 7/11/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import UIKit
import Stevia

class LabelHeaderView: UIView {

    var lesson: Lesson? = nil
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .semiboldTitle
        return label
    }()

    var text: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    func configure(with vm: HeaderViewModelable) {
        self.text = vm.title
    }

    // MARK: - Private
    
    private func setupUI() {
        sv(titleLabel)
        titleLabel.top(21).left(21).bottom(21)
    }
}
