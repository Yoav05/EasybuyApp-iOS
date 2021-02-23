//
//  SearchCoordinator.swift
//  Easybuy
//
//  Created by Yoav on 13/05/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

import UIKit

final class SearchCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = [Coordinator]()
    
    var navigationController: UINavigationController
    
    var container: [UIViewController] = [UIViewController]()
    
    private let builder: FeatureBuilderProtocol
    
    init(navigationController: UINavigationController, builder: FeatureBuilderProtocol) {
        self.navigationController = navigationController
        self.builder = builder
    }

    func start() {
        let controller = builder.makeSearchModule(self)
        controller.tabBarItem = UITabBarItem(title: "Поиск" , image: UIImage(systemName: "magnifyingglass"), tag: 3)
        navigationController.pushViewController(controller, animated: false)
    }

    func showSearchResult(with categories: [String], title: [String]) {
        let controller = builder.makeSearchResultModule(self, with: categories, title: title)
        let final = UINavigationController(rootViewController: controller)
        presentController(controller: final, animated: true, style: .pageSheet)
    }
    
    
}
