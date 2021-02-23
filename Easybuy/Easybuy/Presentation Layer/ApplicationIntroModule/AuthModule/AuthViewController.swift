//
//  AuthViewController.swift
//  Easybuy
//
//  Created by Yoav on 20/04/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController, AuthViewControllerProtocol {
    
    private let presenter: AuthPresenterProtocol

    init(presenter: AuthPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private enum Constants {
        static let buttonWidthMultiplier: CGFloat = 0.95
        static let buttonHeight: CGFloat = 60
        static let topOffset: CGFloat = 20
        static let loginAndRegistrationOffset: CGFloat = 10
    }

    private let appTitleName: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = Design.Fonts.largeTitleRegularFont
        label.text = "EASY BUY"
        label.textAlignment = .center
        return label
    }()

    private let infoTitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = Design.Fonts.largeTitleThinFont
        label.text = "Подберем коризну за 10 секунд"
        label.textAlignment = .center
        return label
    }()

    private let loginButton: ActionBorderButton = {
        let button = ActionBorderButton(type: .system)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = Design.Fonts.buttonFont
        button.setTitle("Войти", for: .normal)
        return button
    }()

    private let registrationButton: ActionFillButton =  {
        let button = ActionFillButton(type: .system)
        button.addTarget(self, action: #selector(registrationButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = Design.Fonts.buttonFont
        button.setTitle("Регистрация", for: .normal)
        return button
    }()

    private let skipButton: DismissButton = {
        let button = DismissButton(type: .system)
        button.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = Design.Fonts.buttonFont
        button.setTitle("Пропустить", for: .normal)
        button.isHidden = true
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
    }
    
    private func setupLayout() {
        [appTitleName, infoTitle, loginButton, registrationButton, skipButton].forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subview)
        }

        NSLayoutConstraint.activate([
            appTitleName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.topOffset),
            appTitleName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            infoTitle.topAnchor.constraint(equalTo: appTitleName.bottomAnchor, constant: Constants.topOffset),
            infoTitle.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            infoTitle.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),

            loginButton.topAnchor.constraint(equalTo: infoTitle.bottomAnchor, constant: Constants.topOffset * 2),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Constants.buttonWidthMultiplier),
            loginButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),

            registrationButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: Constants.loginAndRegistrationOffset),
            registrationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registrationButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Constants.buttonWidthMultiplier),
            registrationButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),

            skipButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -Constants.topOffset),
            skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            skipButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Constants.buttonWidthMultiplier),
            skipButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
    }
}

extension AuthViewController {
    @objc private func loginButtonTapped() {
        presenter.logInFlow()
    }

    @objc private func registrationButtonTapped() {
        presenter.registrationFlow()
    }

    @objc private func skipButtonTapped() {
        presenter.skipFlow()
    }
}
