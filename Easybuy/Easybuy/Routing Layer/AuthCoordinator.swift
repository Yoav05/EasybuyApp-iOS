//
//  AuthCoordinator.swift
//  Easybuy
//
//  Created by Yoav on 23/04/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

import UIKit

final class AuthCoordinator: Coordinator {

    private let builder: AuthBuilderProtocol

    // MARK: Public Variables

    weak var parentCoordinator: MainCoordinator?

    var childCoordinators: [Coordinator] = [Coordinator]()
    
    var navigationController: UINavigationController

    var container: [UIViewController]

    // MARK: Init
    init(navigationController: UINavigationController,
         builder: AuthBuilderProtocol,
         container: [UIViewController]) {
        self.navigationController = navigationController
        self.builder = builder
        self.container = container
    }

    // MARK: Methods

    func start() {
        let controller = builder.makeAuth(coordinator: self)
        presentController(controller: controller, animated: false, style: .overFullScreen)
    }

    func showLogIn() {
        let controller = builder.makeLogIn(coordinator: self)
        presentController(controller: controller, animated: true, style: .overFullScreen)
    }

    func showRegistration() {
        let controller = builder.makeRegistration(coordinator: self)
        presentController(controller: controller, animated: true, style: .overFullScreen)
    }

    func skipFlow() {
        // TODO:
        back()
        parentCoordinator?.authDidFinish(self)
    }

    func logInDone() {
        back()
        skipFlow()
    }

    func registrationDone() {
        back()
        skipFlow()
    }
}
