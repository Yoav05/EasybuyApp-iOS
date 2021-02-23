//
//  DetailSearchViewController.swift
//  Easybuy
//
//  Created by Yoav on 16/05/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

import UIKit

protocol DetailSearchViewControllerProtocol: AnyObject {
    func setTitle(title: String)
}

class DetailSearchViewController: UIViewController {
    
    private let presenter: DetailSearchPresenterProtocol

    private let itemCellId = "ItemCell"

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: itemCellId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 70
        return tableView
    }()

    init(presenter: DetailSearchPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: Design.Fonts.largeTitleRegularFont];
        presenter.setTitle()
        setupLayout()
    }

    private func setupLayout() {
        [tableView].forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subview)
        }

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension DetailSearchViewController: DetailSearchViewControllerProtocol {
    func setTitle(title: String) {
        self.title = title
    }
}

extension DetailSearchViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.searchItems?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCellId, for: indexPath)
        guard let items = presenter.searchItems else { return cell }
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        return cell
    }

}
