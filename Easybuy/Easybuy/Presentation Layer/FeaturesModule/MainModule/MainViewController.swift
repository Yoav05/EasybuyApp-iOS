//
//  MainViewController.swift
//  Easybuy
//
//  Created by Yoav on 23/04/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

import UIKit

protocol MainViewControllerProtocol: AnyObject {
    func successGetRecommendations()
    func failure(error: Error)
}

final class MainViewController: UIViewController {

    private enum Constants {
        static let bottomOffset: CGFloat = 12
        static let centerOffset: CGFloat = 6
        static let bottomButtonsHeight: CGFloat = 50
        static let itemCellId = "ItemCell"
        static let topOffset: CGFloat = 12
    }

    private let presenter: MainPresenterProtocol

    init(presenter: MainPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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

    private lazy var recommendationsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.separatorStyle = .none
        tableView.isUserInteractionEnabled = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.itemCellId)
        tableView.backgroundColor = .secondarySystemBackground
        return tableView
    }()

    private lazy var segmentedController: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Малый", "Средний", "Большой"])
        control.addTarget(self, action: #selector(segmentControl(_:)), for: .valueChanged)
        return control
    }()

    private let recommendationsPlaceHolder: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = Design.Fonts.largeBannerRegularFont
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Выберите размер корзины"
        return label
    }()

    private let recordReceiptButton: ActionBorderButton = {
        let button = ActionBorderButton(type: .system)
        button.addTarget(self, action: #selector(recordReceiptButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = Design.Fonts.thinButtonFont
        button.setTitle("Добавить чек", for: .normal)
        button.setImage(UIImage(systemName: "cart.badge.plus"), for: .normal)
        button.titleLabel?.textAlignment = .center
        return button
    }()

    private let getRecommendationsButton: ActionBorderButton = {
        let button = ActionBorderButton(type: .system)
        button.addTarget(self, action: #selector(getRecommendationsButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = Design.Fonts.thinButtonFont
        button.setTitle(" Рекомендуй", for: .normal)
        button.setImage(UIImage(systemName: "wand.and.stars"), for: .normal)
        button.titleLabel?.textAlignment = .center
        button.isEnabled = false
        return button
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = Design.Fonts.chpisButtonFont
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "Размер корзины"
        return label
    }()

    private let arrowImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "arrow")
        imageView.clipsToBounds = true
        imageView.isHidden = true
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        setupUI()
        setupLayout()
    }

    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = false
        title = "Рекомендации"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: Design.Fonts.largeTitleRegularFont];
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "cart.badge.plus"), style: .plain, target: self, action: #selector(recordReceiptButtonTapped))
        rightButton.tintColor = Design.Buttons.actionColor
        self.navigationItem.rightBarButtonItem = rightButton
    }

    private func setupLayout() {
        [recommendationsTableView,
         getRecommendationsButton,
         segmentedController,
         descriptionLabel,
         arrowImageView].forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subview)
        }
        
        recommendationsPlaceHolder.translatesAutoresizingMaskIntoConstraints = false
        recommendationsTableView.addSubview(recommendationsPlaceHolder)

        NSLayoutConstraint.activate([

            getRecommendationsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.bottomOffset),
            getRecommendationsButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            getRecommendationsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.centerOffset),
            getRecommendationsButton.heightAnchor.constraint(equalToConstant: Constants.bottomButtonsHeight),
            
            descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.topOffset),
            descriptionLabel.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),

            segmentedController.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Constants.topOffset / 2),
            segmentedController.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            segmentedController.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),

            recommendationsTableView.topAnchor.constraint(equalTo: segmentedController.bottomAnchor),
            recommendationsTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            recommendationsTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            recommendationsTableView.bottomAnchor.constraint(equalTo: getRecommendationsButton.topAnchor, constant: -Constants.bottomOffset),
        
            recommendationsPlaceHolder.centerXAnchor.constraint(equalTo: recommendationsTableView.centerXAnchor),
            recommendationsPlaceHolder.centerYAnchor.constraint(equalTo: recommendationsTableView.centerYAnchor),
            recommendationsPlaceHolder.leadingAnchor.constraint(equalTo: recommendationsTableView.leadingAnchor),
            recommendationsPlaceHolder.trailingAnchor.constraint(equalTo: recommendationsTableView.trailingAnchor),

            arrowImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            arrowImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            arrowImageView.bottomAnchor.constraint(equalTo: getRecommendationsButton.topAnchor, constant: -12)
        ])
    }
}

private extension MainViewController {

    @objc func saveCurrentRecommendations() {
        presenter.saveCurrentRecommendations()
    }

    @objc func recordReceiptButtonTapped() {
        presenter.recordReceipt()
    }

    @objc func getRecommendationsButtonTapped() {
        recommendationsPlaceHolder.isHidden = true
        arrowImageView.isHidden = true
        loadingIndicator.startLoading()
        presenter.getRecommendations()
    }

    @objc func segmentControl(_ segmentedControl: UISegmentedControl) {
        recommendationsPlaceHolder.text = "Теперь получите рекомендации"
        if (recommendationsTableView.visibleCells.count > 0) {
            recommendationsPlaceHolder.isHidden = true
            arrowImageView.isHidden = true
        } else {
            arrowImageView.isHidden = false
        }
        getRecommendationsButton.isEnabled = true
        recommendationsTableView.reloadData()
        print(segmentedControl.selectedSegmentIndex)
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedController.selectedSegmentIndex {
        case 0:
            return presenter.recommendations?.small?.count ?? 0
        case 1:
            return presenter.recommendations?.medium?.count ?? 0
        case 2:
            return presenter.recommendations?.large?.count ?? 0
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.itemCellId, for: indexPath)
        switch segmentedController.selectedSegmentIndex {
        case 0:
            guard let rec = presenter.recommendations?.small else { return cell }
            cell.textLabel?.text = rec[indexPath.row]
            cell.isUserInteractionEnabled = false
        case 1:
            guard let rec = presenter.recommendations?.medium else { return cell }
            cell.textLabel?.text = rec[indexPath.row]
            cell.isUserInteractionEnabled = false
        case 2:
            guard let rec = presenter.recommendations?.large else { return cell }
            cell.textLabel?.text = rec[indexPath.row]
            cell.isUserInteractionEnabled = false
        default:
            break
        }
        return cell
    }
}

extension MainViewController: MainViewControllerProtocol {
    func successGetRecommendations() {
        recommendationsTableView.reloadData()
        loadingIndicator.stopLoading()
    }

    func failure(error: Error) {
        print(error.localizedDescription)
        loadingIndicator.stopLoading()
    }
}
