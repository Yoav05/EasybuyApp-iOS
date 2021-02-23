//
//  Repository.swift
//  Easybuy
//
//  Created by Yoav on 02/05/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

import Security
import Foundation

protocol RepositoryProtocol {
    func signInUser(withEmail: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func createUser(withEmail: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func autoSignUser(completion: @escaping(Result<Bool, Error>) -> Void)
    func isAutoSignEnable() -> Bool
    func getUserEmail() -> String?
    func signOutUser(completion: @escaping(Result<Bool, Error>) -> Void)
    func saveReceipt(products: [String], completion: @escaping(Result<Bool, Error>) -> Void)
    func loadReceipts(completion: @escaping(Result<[Receipt], Error>) -> Void)
    func getRecommendations(amount: Int, completion: @escaping(Result<Recommendations, Error>) -> Void)
    func doSearch(with categories: [String], completion: @escaping(Result<[String], Error>) -> Void)
}

final class Repository: RepositoryProtocol {

    private let networkService: EasyBuyNetworkServiceProtocol
    
    private let emailKey = "EmailKey"
    
    init(networkService: EasyBuyNetworkServiceProtocol) {
        self.networkService = networkService
    }

    // MARK: - RepositoryProtocol Methods

    func createUser(withEmail: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        networkService.createUser(email: withEmail, password: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let state):
                do {
                    try self.saveAccountIntoKeychain(with: withEmail, password: password)
                    completion(.success(state))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func signInUser(withEmail: String, password: String, completion: @escaping(Result<Bool, Error>) -> Void) {
        networkService.logInUser(email: withEmail, password: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let state):
                do {
                    try self.saveAccountIntoKeychain(with: withEmail, password: password)
                    completion(.success(state))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func autoSignUser(completion: @escaping (Result<Bool, Error>) -> Void)  {
        guard let email = UserDefaults.standard.string(forKey: emailKey) else {
            completion(.failure(RepositoryError.noSavedEmailAndPassword))
            return
        }
        guard let accountEmail = email.data(using: .utf8) else { return }

        let query: [String: Any]  = [kSecClass as String: kSecClassInternetPassword,
                                     kSecAttrAccount as String: accountEmail,
                                     kSecReturnAttributes as String: true,
                                     kSecReturnData as String: true]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else { completion(.failure(KeychainError.noPassword)); return }
        guard status == errSecSuccess else { completion(.failure(KeychainError.unhandledError(status: status))); return }

        guard let existingItem = item as? [String : Any],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8)
        else {
            completion(.failure(KeychainError.unexpectedPasswordData)); return
        }

        networkService.logInUser(email: email, password: password) { result in
            switch result {
            case .success(let state):
                completion(.success(state))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func isAutoSignEnable() -> Bool {
        if UserDefaults.standard.string(forKey: emailKey) != nil {
            return true
        }
        return false
    }

    func getUserEmail() -> String? {
        return UserDefaults.standard.string(forKey: emailKey)
    }
    
    func signOutUser(completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let email = UserDefaults.standard.string(forKey: emailKey) else {
            completion(.failure(RepositoryError.noSavedEmailAndPassword))
            return
        }
        guard let accountEmail = email.data(using: .utf8) else { return }

        let query: [String: Any]  = [kSecClass as String: kSecClassInternetPassword,
                                     kSecAttrAccount as String: accountEmail,
                                     kSecReturnAttributes as String: true,
                                     kSecReturnData as String: true]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
                completion(.failure(KeychainError.unhandledError(status: status)))
                return
        }
        UserDefaults.standard.removeObject(forKey: emailKey)
        completion(.success(true))
    }

    func saveReceipt(products: [String], completion: @escaping (Result<Bool, Error>) -> Void) {
        networkService.saveReceiptData(products: products, completion: completion)
    }

    func loadReceipts(completion: @escaping (Result<[Receipt], Error>) -> Void) {
        networkService.loadReceipts(completion: completion)
    }
    
    func getRecommendations(amount: Int, completion: @escaping (Result<Recommendations, Error>) -> Void) {
        networkService.getRecommendations(amount: amount) { result in
            switch result {
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(Recommendations.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func doSearch(with categories: [String], completion: @escaping (Result<[String], Error>) -> Void) {
        networkService.doSearch(with: categories) { result in
            switch result {
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(SearchItems.self, from: data)
                    completion(.success(result.searchResult ?? [""]))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Private
    private func saveAccountIntoKeychain(with email: String, password: String) throws {
        guard let accountEmail = email.data(using: .utf8),
            let accountPassword = password.data(using: .utf8) else { return }
        let defaults = UserDefaults.standard
        defaults.set(email, forKey: emailKey)
        autoSignUser { result in
            switch result {
            case .success(_):
                return
            case .failure(_):
                let query: [String: Any]  = [kSecClass as String: kSecClassInternetPassword,
                                             kSecAttrAccount as String: accountEmail,
                                             kSecValueData as String: accountPassword]
                SecItemAdd(query as CFDictionary, nil)
//                guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
            }
        }
    }
}

enum RepositoryError: Error {
    case noSavedEmailAndPassword
}

enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}
