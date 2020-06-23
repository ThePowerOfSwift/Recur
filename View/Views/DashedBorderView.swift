//
//  DashedBorderView.swift
//  Recur
//
//  Created by Allen Miao on 8/28/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import UIKit

class DashedBorderView: UIView {

    private let border = CAShapeLayer()
    private static let cornerRadius: CGFloat = 10

    var borderColor: UIColor = .codeblockBlue {
        didSet {
            border.strokeColor = borderColor.cgColor
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

    override func layoutSubviews() {
        super.layoutSubviews()
        border.path = UIBezierPath(roundedRect: self.bounds, cornerRadius:  DashedBorderView.cornerRadius).cgPath
        border.frame = self.bounds
    }

    private func setupUI() {
        backgroundColor = .codeblockGrey
        layer.cornerRadius = DashedBorderView.cornerRadius
        border.lineDashPattern = [4, 4]
        border.lineWidth = 2.0
        border.fillColor = nil
        border.frame = self.bounds
        self.layer.addSublayer(border)
    }
}
