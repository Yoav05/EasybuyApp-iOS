//
//  HistoryPresenter.swift
//  Easybuy
//
//  Created by Yoav on 03/05/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

import Foundation

protocol HistoryPresenterProtocol {
    func getReceipts()
    var receipts: [Receipt]? { get }
}

final class HistoryPresenter: HistoryPresenterProtocol {

    weak var view: HistoryViewControllerProtocol?
    private let coordinator: HistoryCoordinator
    private let interactor: InteractorProtocol

    init(coordinator: HistoryCoordinator,
         interactor: InteractorProtocol) {
        self.coordinator = coordinator
        self.interactor = interactor
    }

    // MARK: -  HistoryPresenterProtocol
    
    var receipts: [Receipt]?
    
    func getReceipts() {
        interactor.loadReceipts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let receipts):
                self.receipts = receipts
                self.view?.getItems()
            case .failure(_):
                // TODO: - Добавить обработку ошибочного состояния
                break
            }
        }
    }
}
