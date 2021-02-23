//
//  RecommendationCoordinator.swift
//  Easybuy
//
//  Created by Yoav on 23/04/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

import UIKit

final class RecommendationCoordinator: Coordinator {

    private let builder: FeatureBuilder

    var childCoordinators: [Coordinator] = [Coordinator]()

    var navigationController: UINavigationController

    var container: [UIViewController] = [UIViewController]()

    init(navigationController: UINavigationController,
         builder: FeatureBuilder) {
        self.navigationController = navigationController
        self.builder = builder
    }

    func start() {
        let controller = builder.makeMainModule(self)
        controller.tabBarItem = UITabBarItem(title: "Рекомендации" , image: UIImage(systemName: "cart.fill"), tag: 1)
        navigationController.pushViewController(controller, animated: false)
    }

    func showReceiptController() {
        let controller = builder.makeReceiptModule(self)
        presentController(controller: controller, animated: true, style: .pageSheet)
    }

    func receiptControllerDidDismiss() {
        container.removeLast()
    }
}
