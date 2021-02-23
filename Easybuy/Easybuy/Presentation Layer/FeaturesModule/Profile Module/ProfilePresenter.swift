//
//  ProfilePresenter.swift
//  Easybuy
//
//  Created by Yoav on 02/05/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

import Foundation

protocol ProfilePresenterProtocol {
    var tableViewDataSource: ProfilePresenter.TableViewDataSource { get }
    func openAppearance()
    func signOut()
}

final class ProfilePresenter: ProfilePresenterProtocol {

    weak var view: ProfileViewControllerProtocol?

    private let interactor: InteractorProtocol
    private let coordinator: ProfileCoordinator

    init(interactor: InteractorProtocol,
         coordinator: ProfileCoordinator) {
        self.interactor = interactor
        self.coordinator = coordinator
    }

    struct TableViewDataSource {
        let sections: [Section]
        
        struct Section {
            let name: String?
            let items: [ItemType]
        }
        
        enum ItemType {
            case email(userEmail: String?)
            case exit(String)
            case appearance(String)
        }
    }
    
    // MARK: - ProfilePresenterProtocol

    lazy var tableViewDataSource: ProfilePresenter.TableViewDataSource = ProfilePresenter.TableViewDataSource(
        sections: [ProfilePresenter.TableViewDataSource.Section(name: "Почта", items: [.email(userEmail: interactor.getUserEmail())]),
//                   ProfilePresenter.TableViewDataSource.Section(name: nil, items: [.appearance("Внешний вид")]),
                   ProfilePresenter.TableViewDataSource.Section(name: nil, items: [.exit("Выход из приложения")])
        ]
    )

    func openAppearance() {
        coordinator.showAppearence()
    }

    func signOut() {
        interactor.signOutUser { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.coordinator.signOutFlow()
            case .failure:
                break
            }
        }
    }
}
