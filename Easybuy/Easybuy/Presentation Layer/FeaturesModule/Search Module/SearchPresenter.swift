//
//  SearchPresenter.swift
//  Easybuy
//
//  Created by Yoav on 13/05/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

protocol SearchPresenterProtocol {
    var searchItems: [SearchItem] { get }
    func searchRequest(with categories: [String])
    func showSearchResult()
}

final class SearchPresenter: SearchPresenterProtocol {
    
    private let coordinator: SearchCoordinator
    private let interactor: InteractorProtocol
    weak var view: SearchViewControllerProtocol?
    private var categories: [String]?
    private var items: [String]?
    
    init(coordinator: SearchCoordinator,
         interactor: InteractorProtocol) {
        self.coordinator = coordinator
        self.interactor = interactor
    }

    var searchItems: [SearchItem] = [
        SearchItem(imageName: "chocolate", searchType: .chocolate),
        SearchItem(imageName: "milk", searchType: .milk),
        SearchItem(imageName: "fruits", searchType: .fruits),
        SearchItem(imageName: "cola", searchType: .carbonatedDrinks),
        SearchItem(imageName: "vegetables", searchType: .vegetables),
        SearchItem(imageName: "snacks", searchType: .snacks)
    ]

    func searchRequest(with categories: [String]) {
        interactor.doSearch(with: categories) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let items):
                self.categories = categories
                self.items = items
                self.view?.successSearch()
                print(items)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func showSearchResult() {
        guard let items = items,
            let title = categories else { return }
        coordinator.showSearchResult(with: items, title: title)
    }

}
