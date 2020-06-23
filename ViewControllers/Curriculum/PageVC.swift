//
//  PageVC.swift
//  Recur
//
//  Created by Wenyuan Bao on 8/1/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import UIKit

class PageVC: UIViewController {

    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var contentStackView: ContentStackScrollView!
    let page: Page

    init(page: Page) {
        self.page = page
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let contentPageModel = ContentPageViewModel(page: page)
        headerView.titleLabel.text = page.lesson.title
        contentStackView.pageContentView = contentPageModel
        headerView.delegate = self
    }
}

extension PageVC: HeaderViewDelegate {
    func backButtonPressed() {
        let quitAlert = UIAlertController(title: "Are you sure you want to leave?", message: "You'll lose your progress from this lesson", preferredStyle: .alert)
        quitAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        quitAlert.addAction(UIAlertAction(title: "Quit", style: .default, handler: { (_) in
            self.navigationController?.popViewController(animated: true)
        }))
        present(quitAlert, animated: true, completion: nil)
    }

    func chatButtonPressed() {
        //TODO Open chat
    }
}
