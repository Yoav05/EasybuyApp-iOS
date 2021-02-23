//
//  MainCoordinator.swift
//  Easybuy
//
//  Created by Yoav on 23/04/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

import UIKit

final class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = [Coordinator]()
    
    var container: [UIViewController] = [UIViewController]()

    var navigationController: UINavigationController

    private let repository: RepositoryProtocol
    private let interactor: InteractorProtocol
    private let window: UIWindow

    init(navigationController: UINavigationController,
         repository: RepositoryProtocol,
         interactor: InteractorProtocol,
         window: UIWindow) {
        self.navigationController = navigationController
        self.repository = repository
        self.interactor = interactor
        self.window = window
    }

    func start() {
        container.append(navigationController)
        window.rootViewController = StartViewController()
        if repository.isAutoSignEnable() {
            repository.autoSignUser { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    self.startFeatureCoordinator()
                case .failure:
                    self.startAuthCoordinator()
                }
            }
        } else {
            startAuthCoordinator()
        }
    }

    private func startAuthCoordinator() {
        window.rootViewController = navigationController
        UIView.transition(with: window, duration: 0.6, options: .transitionFlipFromRight, animations: nil, completion: nil)
        let child = AuthCoordinator(navigationController: navigationController, builder: AuthBuilder(interactor: interactor), container: container)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }

    private func startFeatureCoordinator() {
        let featureBuilder = FeatureBuilder(interactor: interactor)
        let recommendationCoordinator = RecommendationCoordinator(navigationController: UINavigationController(), builder: featureBuilder)
        let profileCoordinator = ProfileCoordinator(navigationController: UINavigationController(), builder: featureBuilder)
        let historyCoordinator = HistoryCoordinator(navigationController: UINavigationController(), builder: featureBuilder)
        let searchCoordinator = SearchCoordinator(navigationController: UINavigationController(), builder: featureBuilder)
        profileCoordinator.parentCoordinator = self
        let tabBarController = MainTabBarControllerViewController(historyCoordinator: historyCoordinator,
                                                                  recommendationCoordinator: recommendationCoordinator,
                                                                  profileCoordinator: profileCoordinator,
                                                                  searchCoordinator: searchCoordinator)
        window.rootViewController = tabBarController
        UIView.transition(with: window,
                          duration: 0.6,
                          options: [.transitionFlipFromLeft],
                          animations: nil, completion: nil)
        childCoordinators += [recommendationCoordinator, profileCoordinator, historyCoordinator]
    }

    func authDidFinish(_ child: Coordinator) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
        startFeatureCoordinator()
    }

    func signOutDidTapped(_ child: Coordinator) {
        childCoordinators.removeAll()
        startAuthCoordinator()
    }
}
