//
//  ProfileViewController.swift
//  Easybuy
//
//  Created by Yoav on 02/05/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

import UIKit

protocol ProfileViewControllerProtocol: AnyObject {
    
}

class ProfileViewController: UIViewController {

    private let presenter: ProfilePresenterProtocol

    private let itemCellId = "ItemCell"

    init(presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: itemCellId)
        tableView.isUserInteractionEnabled = true
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = false
        title = "Профиль"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: Design.Fonts.largeTitleRegularFont];
    }

    private func setupLayout() {
        [tableView].forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subview)
        }
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func showExitAlert() {
        let alert = UIAlertController(title: "Вы уверены?", message: "Вы выйдите из аккаунта. Вы действительно хотите выйти?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Выйти", style: .destructive, handler: { [weak self] _ in
            self?.presenter.signOut()
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.tableViewDataSource.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.tableViewDataSource.sections[section].items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCellId, for: indexPath)
        switch presenter.tableViewDataSource.sections[indexPath.section].items[indexPath.row] {
        case .email(userEmail: let email):
            cell.textLabel?.text = email
            cell.isUserInteractionEnabled = false
        case .exit(let title):
            cell.textLabel?.text = title
            cell.textLabel?.textColor = .red
        case .appearance(let title):
            cell.textLabel?.text = title
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter.tableViewDataSource.sections[section].name
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch presenter.tableViewDataSource.sections[indexPath.section].items[indexPath.row] {
        case .exit:
            showExitAlert()
        case .appearance:
            break
        case .email:
            break
        }
    }
}

extension ProfileViewController: ProfileViewControllerProtocol {

}
