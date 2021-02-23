//
//  AuthBuilder.swift
//  Easybuy
//
//  Created by Yoav on 23/04/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

import UIKit

protocol AuthBuilderProtocol {
    func makeAuth(coordinator: AuthCoordinator) -> UIViewController
    func makeLogIn(coordinator: AuthCoordinator) -> UIViewController
    func makeRegistration(coordinator: AuthCoordinator) -> UIViewController
}

final class AuthBuilder: AuthBuilderProtocol {

    private let interactor: InteractorProtocol
    
    init(interactor: InteractorProtocol) {
        self.interactor = interactor
    }

    func makeAuth(coordinator: AuthCoordinator) -> UIViewController {
        let presenter = AuthPresenter(coordinator: coordinator)
        let controller = AuthViewController(presenter: presenter)
        presenter.view = controller
        return controller
    }
    
    func makeLogIn(coordinator: AuthCoordinator) -> UIViewController {
        let presenter = LogInPresenter(coordinator: coordinator, interactor: interactor)
        let controller = LogInViewController(presenter: presenter)
        presenter.view = controller
        return controller
    }

    func makeRegistration(coordinator: AuthCoordinator) -> UIViewController {
        let presenter = RegistrationPresenter(coordinator: coordinator, interactor: interactor)
        let controller = RegistrationViewController(presenter: presenter)
        presenter.view = controller
        return controller
    }
}
