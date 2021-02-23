//
//  MainBuilder.swift
//  Easybuy
//
//  Created by Yoav on 23/04/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

import UIKit

protocol FeatureBuilderProtocol {
    func makeMainModule(_ coordinator: RecommendationCoordinator) -> UIViewController
    func makeProfileModule(_ coordinator: ProfileCoordinator) -> UIViewController
    func makeReceiptModule(_ coordinator: RecommendationCoordinator) -> UIViewController
    func makeHistoryModule(_ coordinator: HistoryCoordinator) -> UIViewController
    func makeSearchModule(_ coordinator: SearchCoordinator) -> UIViewController
    func makeSearchResultModule(_ cooridantor: SearchCoordinator, with items: [String], title: [String]) -> UIViewController
}

final class FeatureBuilder: FeatureBuilderProtocol {
    
    private let interactor: InteractorProtocol
    
    init(interactor: InteractorProtocol) {
        self.interactor = interactor
    }

    func makeMainModule(_ coordinator: RecommendationCoordinator) -> UIViewController {
        let presenter = MainPresenter(coordinator: coordinator, interactor: interactor)
        let controller = MainViewController(presenter: presenter)
        presenter.view = controller
        return controller
    }

    func makeProfileModule(_ coordinator: ProfileCoordinator) -> UIViewController {
        let presenter = ProfilePresenter(interactor: interactor, coordinator: coordinator)
        let controller = ProfileViewController(presenter: presenter)
        presenter.view = controller
        return controller
    }

    func makeReceiptModule(_ coordinator: RecommendationCoordinator) -> UIViewController {
        let presenter = ReceiptPresenter(coordinator: coordinator, interactor: interactor)
        let controller = ReceiptViewController(presenter: presenter)
        presenter.view = controller
        return controller
    }

    func makeHistoryModule(_ coordinator: HistoryCoordinator) -> UIViewController {
        let presenter = HistoryPresenter(coordinator: coordinator, interactor: interactor)
        let controller = HistoryViewController(presenter: presenter)
        presenter.view = controller
        return controller
    }

    func makeSearchModule(_ coordinator: SearchCoordinator) -> UIViewController {
        let presenter = SearchPresenter(coordinator: coordinator, interactor: interactor)
        let controller = SearchViewController(presenter: presenter)
        presenter.view = controller
        return controller
    }

    func makeSearchResultModule(_ cooridantor: SearchCoordinator, with items: [String], title: [String]) -> UIViewController {
        let presenter = DetailSearchPresenter(coordinator: cooridantor, items: items, title: title)
        let controller = DetailSearchViewController(presenter: presenter)
        presenter.view = controller
        return controller
    }
}
