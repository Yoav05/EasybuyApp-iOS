//
//  EasybuyNetworkService.swift
//  Easybuy
//
//  Created by Yoav on 22/04/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

import Foundation
import Firebase

protocol EasyBuyNetworkServiceProtocol {
    func createUser(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func logInUser(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func saveReceiptData(products: [String], completion: @escaping (Result<Bool, Error>) -> Void)
    func loadReceipts(completion: @escaping(Result<[Receipt], Error>) -> Void)
    func getRecommendations(amount: Int, completion: @escaping(Result<Data, Error>) -> Void)
    func doSearch(with categories: [String], completion: @escaping(Result<Data, Error>) -> Void)
}

final class EasyBuyNetworkService: EasyBuyNetworkServiceProtocol {

    private let remoteDataBase = Firestore.firestore()
    private let session = URLSession(configuration: .default)

    func createUser(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }

    func logInUser(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }

    func saveReceiptData(products: [String], completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        let data: [String: Any] = [FirestoreConstants.receiptData: products, FirestoreConstants.timestamp: FieldValue.serverTimestamp()]
        remoteDataBase.collection(FirestoreConstants.users).document(userUid).collection(FirestoreConstants.products).addDocument(data: data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }

    func loadReceipts(completion: @escaping (Result<[Receipt], Error>) -> Void) {
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        remoteDataBase.collection(FirestoreConstants.users).document(userUid).collection(FirestoreConstants.products).order(by: FirestoreConstants.timestamp, descending: true).getDocuments { query, err in
            if let err = err {
                completion(.failure(err))
            } else {
                guard let documents = query?.documents else { completion(.failure(EasyBuyNetworkService.Errors.extractDocumentError)); return }
                let result = documents.compactMap { document -> Receipt? in
                    if let products = document[FirestoreConstants.receiptData] as? [String],
                        let timeStamp = document[FirestoreConstants.timestamp] as? Timestamp {
                        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp.seconds))
                        let formatter = DateFormatter()
                        formatter.dateFormat = "d MMM, HH:mm"
                        formatter.locale = Locale(identifier: "ru_MD")
                        return Receipt(products: products, timeStamp: formatter.string(from: date))
                    }
                    return nil
                }
                completion(.success(result))
            }
        }
    }

    enum Errors: Error {
        case extractDocumentError
        case statusCode
    }
}

// MARK: - Recommendation rest api
extension EasyBuyNetworkService {
    func getRecommendations(amount: Int, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let url = NetworkHelper().createGetRecommendationsUrl(with: userId, amount: nil)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Ошибка при запросе:" + error.localizedDescription + "\n" + "❌❌❌")
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 201 {
                completion(.success(data))
            } else if let res = response as? HTTPURLResponse {
                print("Ошибка запроса, код: \(res.statusCode) ❌❌❌"  + "\n")
                completion(.failure(Errors.statusCode))
            }
        }
        task.resume()
    }

    func doSearch(with categories: [String], completion: @escaping (Result<Data, Error>) -> Void) {
        guard let request = NetworkHelper().createSearcUrl(with: categories) else { return }
        print(request)
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Ошибка при запросе:" + error.localizedDescription + "\n" + "❌❌❌")
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 201 {
                completion(.success(data))
            } else if let res = response as? HTTPURLResponse {
                print("Ошибка запроса, код: \(res.statusCode) ❌❌❌"  + "\n")
                completion(.failure(Errors.statusCode))
            }
        }
        task.resume()
    }
}
