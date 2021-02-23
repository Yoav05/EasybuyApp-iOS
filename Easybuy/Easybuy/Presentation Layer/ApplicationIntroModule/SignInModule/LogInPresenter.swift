//
//  LogInPresenter.swift
//  Easybuy
//
//  Created by Yoav on 21/04/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//


protocol LogInPresenterProtocol {
    func logInClosed()
    func isFieldsCorrecltyPassed(email: String?, password: String?)
    func nextFlow(with email: String, with password: String)
}

final class LogInPresenter: LogInPresenterProtocol {

    private let coordinator: AuthCoordinator
    private let interactor: InteractorProtocol

    weak var view: LogInViewController?

    init(coordinator: AuthCoordinator,
         interactor: InteractorProtocol) {
        self.coordinator = coordinator
        self.interactor = interactor
    }

    func logInClosed() {
        coordinator.back()
    }

    func isFieldsCorrecltyPassed(email: String?, password: String?) {
        let state = interactor.isEmailAndPasswordValid(email: email,
                                                       password: password)
        switch state {
        case .success:
            view?.startLogin()
        case .wrongPassword, .emptyField, .wrongEmail, .passwordMismatch:
            view?.fieldsError(error: state)
        }
    }

    func nextFlow(with email: String, with password: String) {
        interactor.signInUser(withEmail: email, password: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.coordinator.logInDone()
            case .failure(let error):
                self.view?.signInError(error: error)
            }
        }
    }
}
