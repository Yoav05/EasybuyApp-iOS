//
//  ReceiptPresenter.swift
//  Easybuy
//
//  Created by Yoav on 04/05/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

import Foundation

import Foundation

protocol ReceiptPresenterProtocol {
    func viewDidDisappear()
    func transformTextToEnumeateList(text: String) -> String
    func saveReceipt(receipt: String)
}

final class ReceiptPresenter: ReceiptPresenterProtocol {

    weak var view: ReceiptViewControllerProtocol?
    private let coordinator: RecommendationCoordinator
    private let interactor: InteractorProtocol
    
    init(coordinator: RecommendationCoordinator,
         interactor: InteractorProtocol) {
        self.coordinator = coordinator
        self.interactor = interactor
    }

    func viewDidDisappear() {
        coordinator.receiptControllerDidDismiss()
    }

    func transformTextToEnumeateList(text: String) -> String {
        let splittedText = text.split(separator: "\n")
        var results = [String]()
        for (index, value) in splittedText.enumerated() {
            results.append("\(index + 1). " + value.split(whereSeparator: { !$0.isLetter }).joined(separator: " "))
        }
        return results.joined(separator: "\n")
    }

    func saveReceipt(receipt: String) {
        let splittedText = receipt.split(separator: "\n")
        var results = [String]()
        for value in splittedText {
            results.append(value.split(whereSeparator: { !$0.isLetter }).joined(separator: " "))
        }
        interactor.saveReceipt(products: results) { result in
            switch result {
            case .success(let state):
                print("Записалось \(state)")
            case .failure(_):
                print("Не записалось")
            }
        }
        print(results)
    }
}
