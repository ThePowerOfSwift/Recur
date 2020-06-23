//
//  CurriculumVC.swift
//  Recur
//
//  Created by Allen Miao on 8/21/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import UIKit

class CurriculumVC: UIViewController {

    private let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    private var curriculum: Curriculum?
    private var unitsArray = [Unit]()
    private let contentInterator = ContentInteractor()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.constrainToSuperview()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 48
        tableView.backgroundColor = .white
        fetchContent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }

    private func fetchContent() {
        contentInterator.fetchCurriculumContent { (error) in
            if let _ = error {
                return
            }
            if let curriculum = Curriculum.fetch(with: Curriculum.rootCurriculumId) {
                self.curriculum = curriculum
                self.navigationController?.navigationBar.topItem?.title = curriculum.title
                self.tableView.reloadData()
            }
        }
    }
}

extension CurriculumVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "UNITS"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return curriculum?.units.count ?? 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if let unit = curriculum?.units.object(at: indexPath.row) as? Unit {
            cell.textLabel?.text = unit.title
        }
        cell.selectionStyle = .none
        return cell
    }
}

extension CurriculumVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = LabelHeaderView()
        headerView.titleLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        headerView.titleLabel.font = .boldHeader
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 71
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let unit = curriculum?.units.object(at: indexPath.row) as? Unit else { return }
        contentInterator.fetchLessons(unit: unit) { (error) in
            guard error == nil else { return }
            let unitVC = UnitVC(unit: unit)
            self.navigationController?.pushViewController(unitVC, animated: true)
            self.navigationController?.navigationBar.isHidden = true
            self.tabBarController?.tabBar.isHidden = true
        }
    }
}
