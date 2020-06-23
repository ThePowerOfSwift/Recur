//
//  CodeblockContainer.swift
//  Recur
//
//  Created by Allen Miao on 8/27/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import Foundation
import Highlightr
import Stevia

class CodeblockContainer: UIView {

    var codeblock: Codeblock? = nil

    var textLabel: UILabel = {
        let label = UILabel.createLabel(textStyle: .codeBlock)
        label.backgroundColor = .clear
        return label
    }()

    var text: String {
        get {
            return textLabel.text ?? ""
        }
        set {
            let highlightr = Highlightr()
            highlightr?.setTheme(to: "atom-one-dark")
            textLabel.attributedText = highlightr?.highlight(newValue)
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

    // MARK: - Private

    private func setupUI() {
        sv(textLabel)
        textLabel.top(21).left(21).bottom(21)
        layer.cornerRadius = 4.0
        backgroundColor = .mainDark
    }
}
