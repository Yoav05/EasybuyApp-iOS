//
//  RegistrationPresenter.swift
//  Easybuy
//
//  Created by Yoav on 22/04/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

protocol RegistrationPresenterProtocol {
    func registrationClosed()
    func isFieldsCorrectlyPassed(email: String?, password: String?, repeatPassword: String?)
    func nextFlow(with email: String, password: String)
}

final class RegistrationPresenter: RegistrationPresenterProtocol {
    private let coordinator: AuthCoordinator
    private let interactor: InteractorProtocol
    
    weak var view: RegistrationViewControllerProtocol?

    init(coordinator: AuthCoordinator,
         interactor: InteractorProtocol) {
        self.coordinator = coordinator
        self.interactor = interactor
    }

    func registrationClosed() {
        coordinator.back()
    }

    func isFieldsCorrectlyPassed(email: String?, password: String?, repeatPassword: String?) {
        let state = interactor.isEmailAndPasswordValid(email: email,
                                                       password: password,
                                                       repeatPassword: repeatPassword)
        switch state {
        case .success:
            view?.startRegistration()
        case .wrongPassword, .emptyField, .wrongEmail, .passwordMismatch:
            view?.fieldsError(error: state)
        }
    }

    func nextFlow(with email: String, password: String) {
        interactor.createUser(withEmail: email, password: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.coordinator.registrationDone()
            case .failure(let error):
                self.view?.registartionError(error: error)
            }
        }
    }
}
