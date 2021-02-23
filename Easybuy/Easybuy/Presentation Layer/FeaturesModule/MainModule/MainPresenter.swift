//
//  MainPresenter.swift
//  Easybuy
//
//  Created by Yoav on 23/04/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//



protocol MainPresenterProtocol {
    func recordReceipt()
    func getRecommendations()
    func saveCurrentRecommendations()
    var recommendations: Recommendations? { get }

}

final class MainPresenter: MainPresenterProtocol {

    private let coordinator: RecommendationCoordinator
    private let interactor: InteractorProtocol
    
    weak var view: MainViewControllerProtocol?
    
    init(coordinator: RecommendationCoordinator,
         interactor: InteractorProtocol) {
        self.coordinator = coordinator
        self.interactor = interactor
    }

    var recommendations: Recommendations?

    func recordReceipt() {
        coordinator.showReceiptController()
    }

    func saveCurrentRecommendations() {
        // TODO:
    }

    func getRecommendations() {
        interactor.getRecommendations(amount: 6) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let recommendations):
                self.recommendations = recommendations
                self.view?.successGetRecommendations()
            case .failure(let error):
                self.view?.failure(error: error)
            }
        }
    }
}
