//
//  DetailSearchPresenter.swift
//  Easybuy
//
//  Created by Yoav on 16/05/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//


protocol DetailSearchPresenterProtocol {
    var searchItems: [String]? { get }
    func setTitle()
}

final class DetailSearchPresenter: DetailSearchPresenterProtocol {

    private let coordinator: SearchCoordinator
    weak var view: DetailSearchViewControllerProtocol?
    private var title: [String]?
    
    init(coordinator: SearchCoordinator,
         items: [String],
         title: [String]) {
        self.coordinator = coordinator
        searchItems = items
        self.title = title
    }

    var searchItems: [String]?

    func setTitle() {
        guard let title = title else { return }
        view?.setTitle(title: title.joined(separator: ", "))
    }

}
