//
//  LessonVC.swift
//  Recur
//
//  Created by Wenyuan Bao on 8/9/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import UIKit

class LessonVC: UIViewController {

    private let lesson: Lesson
    let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    private var currPageIndex = 0

    init(lesson: Lesson) {
        self.lesson = lesson
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        add(pageVC, to: view)
        if let firstPage = lesson.pages.firstObject as? Page {
            let firstVC = PageVC(page: firstPage)
            pageVC.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
            setProgressBarProgress(pageVC: firstVC)
        }
    }

    func goToCheckpoint(checkpoint: Checkpoint) {
        loadViewIfNeeded()
        guard let checkpointPage = Page.fetch(with: checkpoint.startPageId) else { return }
        currPageIndex = lesson.pages.index(of: checkpointPage)
        let vc = PageVC(page: checkpointPage)
        pageVC.setViewControllers([vc], direction: .forward, animated: false, completion: nil)
        setProgressBarProgress(pageVC: vc)
    }

    // MARK: - Private

    private func setProgressBarProgress(pageVC: PageVC) {
        guard lesson.pages.count > 0 else { return }
        let progress = Float(currPageIndex + 1) / Float(lesson.pages.count)
        pageVC.headerView.progressBar.setProgress(progress, animated: false)
    }
}
