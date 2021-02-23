//
//  StartViewController.swift
//  Easybuy
//
//  Created by Yoav on 03/05/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    private lazy var loadingIndicator: LoadingIndicator = {
        let loader = LoadingIndicator()
        loader.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loader)
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loader.heightAnchor.constraint(equalToConstant: 100),
            loader.widthAnchor.constraint(equalToConstant: 100)
        ])
        return loader
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        loadingIndicator.startLoading()
    }
}
