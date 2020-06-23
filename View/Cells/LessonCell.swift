//
//  LessonCell.swift
//  Recur
//
//  Created by John Ababseh on 7/25/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import UIKit
import Stevia

class LessonCell: UITableViewCell {

    let iconImage = UIImageView()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .mediumSubtitle
        return label
    }()

    let percentLabel: UILabel = {
        let label = UILabel()
        label.font = .regularSubtitle
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    func configure(with lesson: Lesson) {
        self.nameLabel.text = lesson.title
    }

    // MARK: - Private

    private func setupUI() {
        sv(
            iconImage,
            nameLabel,
            percentLabel
        )
        iconImage.width(24).heightEqualsWidth().right(9).top(12)
        nameLabel.left(35)
        nameLabel.CenterY == iconImage.CenterY
        percentLabel.right(9)
        percentLabel.CenterY == iconImage.CenterY
        percentLabel.isHidden = true
        iconImage.isHidden = true
    }
}
