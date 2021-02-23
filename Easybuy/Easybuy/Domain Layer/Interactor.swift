//
//  Interactor.swift
//  Easybuy
//
//  Created by Yoav on 29/04/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

import Foundation

protocol InteractorProtocol {
    func isEmailAndPasswordValid(email: String?, password: String?) -> AuthFieldState
    func isEmailAndPasswordValid(email: String?, password: String?, repeatPassword: String?) -> AuthFieldState
    func createUser(withEmail: String, password: String, completion: @escaping(Result<Bool, Error>) -> Void)
    func signInUser(withEmail: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func getUserEmail() -> String?
    func signOutUser(completion: @escaping(Result<Bool, Error>) -> Void)
    func saveReceipt(products: [String], completion: @escaping (Result<Bool, Error>) -> Void)
    func loadReceipts(completion: @escaping(Result<[Receipt], Error>) -> Void)
    func getRecommendations(amount: Int, completion: @escaping(Result<Recommendations, Error>) -> Void)
    func doSearch(with categories: [String], completion: @escaping(Result<[String], Error>) -> Void)
}

final class Interactor: InteractorProtocol {

    private let passwordRegex = "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"
    private let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    private let repository: RepositoryProtocol

    init(repository: RepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - InteractorProtocol

    func isEmailAndPasswordValid(email: String?, password: String?) -> AuthFieldState {
        guard let email = email, let password = password else { return .emptyField }

        if email.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            password.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return .emptyField
        }
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        if !emailTest.evaluate(with: email.trimmingCharacters(in: .whitespacesAndNewlines)) {
            return .wrongEmail
        }
        
        if password.count < 8 {
            return .wrongPassword
        }

        return .success
    }

    func isEmailAndPasswordValid(email: String?, password: String?, repeatPassword: String?) -> AuthFieldState {
        guard let email = email, let password = password, let repeatPassword = repeatPassword else { return .emptyField }

        if email.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            password.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return .emptyField
        }

        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        if !emailTest.evaluate(with: email.trimmingCharacters(in: .whitespacesAndNewlines)) {
            return .wrongEmail
        }

        if password.count < 8 {
            return .wrongPassword
        }

        if password.trimmingCharacters(in: .whitespacesAndNewlines) != repeatPassword.trimmingCharacters(in: .whitespacesAndNewlines) {
            return .passwordMismatch
        }
        return .success
    }

    func createUser(withEmail: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        repository.createUser(withEmail: withEmail, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let state):
                    completion(.success(state))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    func signInUser(withEmail: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        repository.signInUser(withEmail: withEmail, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let state):
                    completion(.success(state))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    func getUserEmail() -> String? {
        return repository.getUserEmail()
    }

    func signOutUser(completion: @escaping (Result<Bool, Error>) -> Void) {
        repository.signOutUser(completion: completion)
    }
    
    func saveReceipt(products: [String], completion: @escaping (Result<Bool, Error>) -> Void) {
        repository.saveReceipt(products: products) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let state):
                    completion(.success(state))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    func loadReceipts(completion: @escaping (Result<[Receipt], Error>) -> Void) {
        repository.loadReceipts { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let receipts):
                    completion(.success(receipts))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    func getRecommendations(amount: Int, completion: @escaping (Result<Recommendations, Error>) -> Void) {
        repository.getRecommendations(amount: amount) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    completion(.success(result))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    func doSearch(with categories: [String], completion: @escaping (Result<[String], Error>) -> Void) {
        repository.doSearch(with: categories) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    completion(.success(result))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}

enum AuthFieldState {
    case emptyField
    case wrongPassword
    case wrongEmail
    case passwordMismatch
    case success
}


/// Для разбиения на разные протоколы

//protocol ApplicationIntroInteractorProtocol {
//
//}
//
//protocol RecommendationsInteractorProtocol {
//
//}
//
//protocol HistoryInteractorProtocol {
//
//}
//
//protocol ProfileInteractorProtocol {
//
//}
