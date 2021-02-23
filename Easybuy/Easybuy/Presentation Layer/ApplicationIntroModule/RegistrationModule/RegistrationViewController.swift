//
//  RegistrationViewController.swift
//  Easybuy
//
//  Created by Yoav on 22/04/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

import UIKit

protocol RegistrationViewControllerProtocol: AnyObject {
    func startRegistration()
    func fieldsError(error: AuthFieldState)
    func registartionError(error: Error)
}

final class RegistrationViewController: UIViewController {

    private let presenter: RegistrationPresenter
    
    init(presenter: RegistrationPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private enum Constants {
        static let topOffset: CGFloat = 20
        static let textFieldWidthMultiplier: CGFloat = 0.8
        static let textFieldHeight: CGFloat = 40
        static let buttonHeight: CGFloat = 60
        static let registrationButtonWidthMultiplier: CGFloat = 0.8
        static let emailPasswordOffset: CGFloat = 12
    }

    private let closeButton: XmarkButton  = {
        let button = XmarkButton()
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = Design.Fonts.largeTitleRegularFont
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Регистрация"
        return label
    }()

    private lazy var emailTextField: UITextField =  {
        let textField = UITextField(frame: .zero)
        textField.delegate = self
        textField.textContentType = .username
        textField.keyboardType = .emailAddress
        textField.borderStyle = .roundedRect
        textField.placeholder = "Email"
        textField.autocapitalizationType = .none
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        return textField
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.delegate = self
        textField.textContentType = .newPassword
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.placeholder = "Password"
        textField.autocapitalizationType = .none
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        return textField
    }()

    private lazy var confirmPasswordTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.delegate = self
        textField.textContentType = .newPassword
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.placeholder = "Confirm password"
        textField.autocapitalizationType = .none
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        return textField
    }()

    private let registartionButton: ActionBorderButton = {
        let button = ActionBorderButton(type: .system)
        button.addTarget(self, action: #selector(registrationButtonTapped), for: .touchUpInside)
        button.setTitle("Зарегистрировать", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = Design.Fonts.buttonFont
        return button
    }()

    private let errorLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = Design.Fonts.authErrorFont
        label.numberOfLines = 0
        label.textAlignment = .left
        label.isEnabled = false
        label.textColor = .red
        return label
    }()
    

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
        setupLayout()
    }

    private func setupLayout() {
        [closeButton,
         titleLabel,
         emailTextField,
         passwordTextField,
         confirmPasswordTextField,
         registartionButton,
         errorLabel].forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subview)
        }

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.topOffset),
            closeButton.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),

            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.topOffset),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            emailTextField.topAnchor.constraint(equalTo: titleLabel.layoutMarginsGuide.bottomAnchor, constant: Constants.topOffset),
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Constants.textFieldWidthMultiplier),
            emailTextField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: Constants.emailPasswordOffset),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Constants.textFieldWidthMultiplier),
            passwordTextField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight),

            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: Constants.emailPasswordOffset),
            confirmPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmPasswordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Constants.textFieldWidthMultiplier),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight),

            errorLabel.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: Constants.topOffset / 2),
            errorLabel.trailingAnchor.constraint(equalTo: confirmPasswordTextField.trailingAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: confirmPasswordTextField.leadingAnchor),
    
            registartionButton.topAnchor.constraint(equalTo: errorLabel.layoutMarginsGuide.bottomAnchor, constant: 2 * Constants.topOffset),
            registartionButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            registartionButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Constants.registrationButtonWidthMultiplier),
            registartionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // TODO: - Обработка текста
        textField.resignFirstResponder()
        return true
    }
}

extension RegistrationViewController {
    @objc private func closeButtonTapped() {
        presenter.registrationClosed()
    }

    @objc private func registrationButtonTapped() {
        loadingIndicator.startLoading()
        presenter.isFieldsCorrectlyPassed(email: emailTextField.text,
                                          password: passwordTextField.text,
                                          repeatPassword: confirmPasswordTextField.text)
    }
}

extension RegistrationViewController: RegistrationViewControllerProtocol {
    func startRegistration() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Ошибка, при начале регистрации")
            return
        }
        presenter.nextFlow(with: email, password: password)
    }

    func fieldsError(error: AuthFieldState) {
        loadingIndicator.stopLoading()
        switch error {
        case .emptyField:
            errorLabel.text = "Заполните все пустые поля"
            errorLabel.isEnabled = true
        case .wrongEmail:
            errorLabel.text = "Неправильный формат электронной почты"
            errorLabel.isEnabled = true
        case .wrongPassword:
            errorLabel.text = "Пароль должен содержать минимум 8 символов"
            errorLabel.isEnabled = true
        case .passwordMismatch:
            errorLabel.text = "Пароли не совпадают"
        case .success:
            break
        }
    }

    func registartionError(error: Error) {
        loadingIndicator.stopLoading()
        errorLabel.text = "Ошибка при регистрации: \(error.localizedDescription)"
        errorLabel.isEnabled = true
    }
}

