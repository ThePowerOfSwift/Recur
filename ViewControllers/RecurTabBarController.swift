//
//  RecurTabBarController.swift
//  Recur
//
//  Created by Leslie Ho on 7/11/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import UIKit

class RecurTabBarController: UITabBarController {

    static var shared = RecurTabBarController.setUpTabBarController()

    private var curriculumVC = UINavigationController(rootViewController: CurriculumVC())
    private let chatVC = ViewController()
    private let profileVC = LogoutVC()
    private let grayLineView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "tab_bar_border")
        return imageView
    }()

    private init() {
        super.init(nibName: nil, bundle: nil)
        setUpTabBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let controllers = [curriculumVC, chatVC, profileVC]
        self.viewControllers = controllers
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        grayLineView.frame = CGRect(x: 0, y: -4, width: view.frame.width, height: 4)
    }

    private static func setUpTabBarController() -> RecurTabBarController {
        let tab = RecurTabBarController()
        tab.addChild(tab.curriculumVC)
        tab.addChild(tab.chatVC)
        tab.addChild(tab.profileVC)

        tab.curriculumVC.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "courses-icon"), tag: 0)
        tab.chatVC.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "chat-icon"), tag: 1)
        tab.profileVC.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "profile-icon"), tag: 2)
        return tab
    }

    private func setUpTabBar() {
        self.tabBar.layer.addSublayer(grayLineView.layer)
        self.tabBar.barStyle = .black
        self.tabBar.unselectedItemTintColor = .inactive
        self.tabBar.itemSpacing = 50
        self.tabBar.itemWidth = 50
        self.tabBar.itemPositioning = .centered
        self.tabBar.tintColor = .recurBlue
        self.tabBar.barTintColor = .white
        self.selectedIndex = 0
    }
}
