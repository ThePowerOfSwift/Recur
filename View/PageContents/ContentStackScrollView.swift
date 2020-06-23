//
//  ContentStackScrollView.swift
//  Recur
//
//  Created by Wenyuan Bao on 7/23/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import UIKit
import Stevia

class ContentStackScrollView: UIScrollView {

    var pageContentView: ContentPageViewModelable? = nil {
        didSet {
            configureViews()
        }
    }

    let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 12
        stackView.alignment = .fill
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        isDirectionalLockEnabled = true
        clipsToBounds = true
        sv(contentStackView)
        contentStackView.centerHorizontally().fillVertically(m: 12)
        contentStackView.Width == Width - 24
    }
    
    func configureViews() {
        guard let pageContentView = pageContentView else { return }
        let titleLabel = UILabel.createLabel(textStyle: .pageTitle)
        titleLabel.text = pageContentView.title
        contentStackView.addArrangedSubview(titleLabel)
        for view in pageContentView.bodyViews {
            contentStackView.addArrangedSubview(view)
        }
    }
}
