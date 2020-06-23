//
//  HeaderView.swift
//  Recur
//
//  Created by Wenyuan Bao on 7/15/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import UIKit
import Stevia

protocol HeaderViewDelegate: class {
    func backButtonPressed()
    func chatButtonPressed()
}

class HeaderView: UIView {

    let backButton = UIButton()
    let rightButton = BadgeButton()

    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .titleText
        titleLabel.textColor = .darkGray
        titleLabel.textAlignment = .center
        return titleLabel
    }()

    let progressBar: UIProgressView = {
        let progress = UIProgressView()
        progress.progressTintColor = .recurBlue
        progress.trackTintColor = .veryLightGray
        progress.clipsToBounds = true
        return progress
    }()
    
    weak var delegate: HeaderViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        progressBar.layer.cornerRadius = progressBar.frame.height / 2
    }
    
    // MARK: - Private

    private func commonInit() {
        backButton.setImage(#imageLiteral(resourceName: "back-icon.png"), for: .normal)
        titleLabel.text = "Functions"
        
        // Update progress and notification
        rightButton.notificationCount = 0
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightButtonPressed), for: .touchUpInside)
        setupUI()
    }

    private func setupUI() {
        sv(
            backButton,
            titleLabel,
            rightButton,
            progressBar
        )
        backButton.top(16).left(13)
        titleLabel.centerHorizontally()
        titleLabel.CenterY == backButton.CenterY
        titleLabel.Left >= backButton.Right + 6
        rightButton.height(28).width(37.5).right(6)
        rightButton.Left >= titleLabel.Right + 6
        rightButton.CenterY == backButton.CenterY
        progressBar.height(7).bottom(0)
        align(rights: progressBar, rightButton)
        align(lefts: progressBar, backButton)
    }

    @objc private func backButtonPressed() {
        delegate?.backButtonPressed()
    }

    @objc private func rightButtonPressed() {
        delegate?.chatButtonPressed()
    }
}
