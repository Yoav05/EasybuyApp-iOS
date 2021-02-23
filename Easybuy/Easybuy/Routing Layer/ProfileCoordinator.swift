//
//  ProfileCoordinator.swift
//  Easybuy
//
//  Created by Yoav on 02/05/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

import UIKit

final class ProfileCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = [Coordinator]()
    
    var navigationController: UINavigationController
    
    var container: [UIViewController] = [UIViewController]()
    
    weak var parentCoordinator: MainCoordinator?

    private let builder: FeatureBuilderProtocol
    
        init(navigationController: UINavigationController,
         builder: FeatureBuilderProtocol) {
        self.navigationController = navigationController
        self.builder = builder
    }

    func start() {
        let controller = builder.makeProfileModule(self)
        controller.tabBarItem = UITabBarItem(title: "Профиль" , image: UIImage(systemName: "person.fill"), tag: 2)
        navigationController.pushViewController(controller, animated: false)
    }

    func showAppearence() {
        
    }

    func signOutFlow() {
        parentCoordinator?.signOutDidTapped(self)
    }
}
