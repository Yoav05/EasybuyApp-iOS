//
//  HistoryCoordinator.swift
//  Easybuy
//
//  Created by Yoav on 05/05/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

import UIKit

final class HistoryCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = [Coordinator]()
    
    var navigationController: UINavigationController
    
    var container: [UIViewController] = [UIViewController]()
    
    private let builder: FeatureBuilderProtocol
    
    init(navigationController: UINavigationController, builder: FeatureBuilderProtocol) {
        self.navigationController = navigationController
        self.builder = builder
    }
    
    func start() {
        let controller = builder.makeHistoryModule(self)
        controller.tabBarItem = UITabBarItem(title: "История" , image: UIImage(systemName: "doc.plaintext"), tag: 0)
        navigationController.pushViewController(controller, animated: false)
    }
}
