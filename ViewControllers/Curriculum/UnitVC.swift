//
//  UnitVC.swift
//  Recur
//
//  Created by John Ababseh on 7/8/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import UIKit

class UnitVC: UIViewController {

    private let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    private var unit: Unit
    private var lessonsArray = [Lesson]()
    private let contentInterator = ContentInteractor()

    init(unit: Unit) {
        self.unit = unit
        super.init(nibName: nil, bundle: nil)
        self.title = unit.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.constrainToSuperview()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 48
        tableView.backgroundColor = .white

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(popViewController))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }

    @objc private func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension UnitVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return unit.lessons.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueNonNibCell(cellClass: LessonCell.self)
        if let lesson = unit.lessons.object(at: indexPath.row) as? Lesson {
            cell.configure(with: lesson)
        }
        cell.selectionStyle = .none
        return cell
    }
}

extension UnitVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 71
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let lesson = unit.lessons.object(at: indexPath.row) as? Lesson else { return }
        contentInterator.fetchPages(lesson: lesson) { (error) in
            guard error == nil else { return }
            let lessonVC = LessonVC(lesson: lesson)
            self.navigationController?.pushViewController(lessonVC, animated: true)
            self.navigationController?.navigationBar.isHidden = true
            self.tabBarController?.tabBar.isHidden = true
        }
    }
}
