//
//  MainTabBarControllerViewController.swift
//  Easybuy
//
//  Created by Yoav on 02/05/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

import UIKit

class MainTabBarControllerViewController: UITabBarController {

    private let historyCoordinator: HistoryCoordinator
    private let recommendationCoordinator: RecommendationCoordinator
    private let profileCoordinator: ProfileCoordinator
    private let searchCoordinator: SearchCoordinator

    init(historyCoordinator: HistoryCoordinator,
         recommendationCoordinator: RecommendationCoordinator,
         profileCoordinator: ProfileCoordinator,
         searchCoordinator: SearchCoordinator) {

        self.historyCoordinator = historyCoordinator
        self.recommendationCoordinator = recommendationCoordinator
        self.profileCoordinator = profileCoordinator
        self.searchCoordinator = searchCoordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        historyCoordinator.start()
        recommendationCoordinator.start()
        profileCoordinator.start()
        searchCoordinator.start()
        viewControllers = [historyCoordinator.navigationController,
                           searchCoordinator.navigationController,
                           recommendationCoordinator.navigationController,
                           profileCoordinator.navigationController]
        selectedIndex = 2
    }
}
