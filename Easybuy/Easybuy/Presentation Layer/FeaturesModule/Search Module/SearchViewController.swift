//
//  SearchViewController.swift
//  Easybuy
//
//  Created by Yoav on 13/05/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

import UIKit

protocol SearchViewControllerProtocol: AnyObject {
    func successSearch()
    func failureSearch(with error: Error)
}

final class SearchViewController: UIViewController {
    
    private let presenter: SearchPresenterProtocol
    
    init(presenter: SearchPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum Constants {
        static let collectionViewCellId = "SearchCollectionViewCellId"
        static let topOffset: CGFloat = 20
    }
    
    private lazy var searchCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width / 2 - 30, height: view.frame.height * 0.2)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = view.backgroundColor
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: Constants.collectionViewCellId)
        collectionView.allowsMultipleSelection = true
        return collectionView
    }()

    private lazy var loadingIndicator: LoadingIndicator = {
        let loader = LoadingIndicator()
        loader.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loader)
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loader.heightAnchor.constraint(equalToConstant: 100),
            loader.widthAnchor.constraint(equalToConstant: 100)
        ])
        return loader
    }()

    private let searchButton: ActionFillButton = {
        let button = ActionFillButton(type: .system)
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        button.setTitle("НАЙТИ", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = Design.Fonts.buttonFont
        button.alpha = 0
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupLayout()
    }

    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Поиск по вкусам"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: Design.Fonts.largeTitleRegularFont];
    }

    private func setupLayout() {
        [searchCollectionView, searchButton].forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subview)
        }
        NSLayoutConstraint.activate([
            searchCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.topOffset),
            searchCollectionView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
            searchCollectionView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            searchCollectionView.bottomAnchor.constraint(equalTo: searchButton.topAnchor),

            searchButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchButton.heightAnchor.constraint(equalToConstant: 40),
            searchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
        ])
    }

    @objc private func searchButtonTapped() {
        guard let selectedItems = searchCollectionView.indexPathsForSelectedItems else { return }
        searchCollectionView.isUserInteractionEnabled = false
        searchButton.isEnabled = false
        loadingIndicator.startLoading()
        let categories = selectedItems.map { presenter.searchItems[$0.row].searchType.name }
        presenter.searchRequest(with: categories)
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.searchItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.collectionViewCellId, for: indexPath) as? SearchCollectionViewCell {
            cell.searchType = presenter.searchItems[indexPath.row].searchType
            cell.imageName = presenter.searchItems[indexPath.row].imageName
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedItems = collectionView.indexPathsForSelectedItems else { return }
        if selectedItems.count > 2 {
            selectedItems.forEach { path in
                if path != indexPath {
                    collectionView.deselectItem(at: path, animated: true)
                }
            }
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                self.searchButton.alpha = 1
            }, completion: nil)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let selectedItems = collectionView.indexPathsForSelectedItems else { return }
        if selectedItems.count == 0 {
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveLinear, animations: {
                self.searchButton.alpha = 0
            }, completion: nil)
        }
    }
}

extension SearchViewController: SearchViewControllerProtocol {
    func successSearch() {
        searchCollectionView.isUserInteractionEnabled = true
        searchButton.isEnabled = true
        loadingIndicator.stopLoading()
        presenter.showSearchResult()
    }
    
    func failureSearch(with error: Error) {
        // TODO: Показать ошибку
    }
    
    
}
