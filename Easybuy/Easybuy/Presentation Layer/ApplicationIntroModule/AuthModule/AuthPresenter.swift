//
//  AuthPresenter.swift
//  Easybuy
//
//  Created by Yoav on 20/04/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

protocol AuthViewControllerProtocol: AnyObject {
    
}

protocol AuthPresenterProtocol {
    func logInFlow()
    func registrationFlow()
    func skipFlow()
}

final class AuthPresenter: AuthPresenterProtocol {

    private let coordinator: AuthCoordinator
    
    weak var view: AuthViewControllerProtocol?

    init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
    }

    func logInFlow() {
        coordinator.showLogIn()
    }

    func registrationFlow() {
        coordinator.showRegistration()
    }

    func skipFlow() {
        coordinator.skipFlow()
    }
}
