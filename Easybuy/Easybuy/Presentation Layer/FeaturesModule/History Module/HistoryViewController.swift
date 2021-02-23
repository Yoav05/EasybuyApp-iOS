//
//  HistoryViewController.swift
//  Easybuy
//
//  Created by Yoav on 03/05/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

import UIKit

protocol HistoryViewControllerProtocol: AnyObject {
    func getItems()
}

final class HistoryViewController: UIViewController {

    private let presenter: HistoryPresenterProtocol
    
    private let itemCellId = "ItemCell"

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ReceiptTableViewCell.self, forCellReuseIdentifier: itemCellId)
        tableView.isUserInteractionEnabled = true
        tableView.refreshControl = refreshButton
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 70
        return tableView
    }()

    private lazy var refreshButton: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshButtonTapped), for: .valueChanged)
        return refresh
    }()

    private let historyPlaceHolder: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = Design.Fonts.largeBannerRegularFont
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Вы еще ничего не добавляли в историю"
        return label
    }()


    init(presenter: HistoryPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupLayout()
        presenter.getReceipts()
    }
    
    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "История покупок"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: Design.Fonts.largeTitleRegularFont];
    }

    private func setupLayout() {
        [tableView, historyPlaceHolder].forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subview)
        }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            historyPlaceHolder.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            historyPlaceHolder.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            historyPlaceHolder.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            historyPlaceHolder.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
        ])
    }
    
    @objc private func refreshButtonTapped() {
        historyPlaceHolder.isHidden = true
        presenter.getReceipts()
    }
}

extension HistoryViewController: HistoryViewControllerProtocol {
    func getItems() {
        tableView.reloadData()
        if presenter.receipts?.count ?? 0 > 0 {
            historyPlaceHolder.isHidden = true
        } else {
            historyPlaceHolder.isHidden = false
        }
        refreshButton.endRefreshing()
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if presenter.receipts?.count ?? 0 >= 1 {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: itemCellId, for: indexPath) as? ReceiptTableViewCell,
            let receipts = presenter.receipts
            else {
                return UITableViewCell()
        }
        cell.timeStamp = receipts[indexPath.section].timeStamp
        cell.products = receipts[indexPath.section].joinProducts()
        cell.isUserInteractionEnabled = false
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.receipts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3
    }
}
