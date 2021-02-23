//
//  LogInViewController.swift
//  Easybuy
//
//  Created by Yoav on 20/04/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

import UIKit

protocol LogInViewControllerProtocol: AnyObject {
    func startLogin()
    func fieldsError(error: AuthFieldState)
    func signInError(error: Error)
}

class LogInViewController: UIViewController {

    private let presenter: LogInPresenter

    init(presenter: LogInPresenter) {
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
        static let loginButtonWidthMultiplier: CGFloat = 0.8
        static let emailPasswordOffset: CGFloat = 12
        static let anotherLoginWidthMultiplier: CGFloat = 0.6
        static let anotherButtonsOffset: CGFloat = 12
    }
    
    // MARK: - UI Elementss
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
        label.text = "Вход"
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
        textField.textContentType = .password
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.placeholder = "Password"
        textField.autocapitalizationType = .none
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        return textField
    }()

    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Забыли пароль?", for: .normal)
        button.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
        button.setTitleColor(Design.Buttons.actionColor, for: .normal)
        button.titleLabel?.textAlignment = .right
        button.titleLabel?.font = Design.Fonts.forgotButtonFont
        return button
    }()

    private let logInButton: ActionFillButton = {
        let button = ActionFillButton(type: .system)
        button.addTarget(self, action: #selector(logInTapped), for: .touchUpInside)
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = Design.Fonts.buttonFont
        return button
    }()

    private let secondTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = Design.Fonts.largeTitleRegularFont
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Другие способы входа"
        label.isHidden = true
        return label
    }()

    private let googleLoginButton: ActionBorderButton = {
        let button = ActionBorderButton(type: .system)
        button.addTarget(self, action: #selector(googleLogInTapped), for: .touchUpInside)
        button.titleLabel?.font = Design.Fonts.buttonFont
        button.setTitle("Google", for: .normal)
        button.isHidden = true
        return button
    }()

    private let faceBookLoginButton: ActionBorderButton = {
        let button = ActionBorderButton(type: .system)
        button.addTarget(self, action: #selector(facebookLogInTapped), for: .touchUpInside)
        button.titleLabel?.font = Design.Fonts.buttonFont
        button.setTitle("Facebook", for: .normal)
        button.isHidden = true
        return button
    }()

    private let vkLoginButton: ActionBorderButton = {
        let button = ActionBorderButton(type: .system)
        button.addTarget(self, action: #selector(vkLogInTapped), for: .touchUpInside)
        button.titleLabel?.font = Design.Fonts.buttonFont
        button.setTitle("VK", for: .normal)
        button.isHidden = true
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

    // MARK: Setup Constraints
    private func setupLayout() {
        [closeButton, titleLabel,
         emailTextField,
         passwordTextField,
         errorLabel,
         forgotPasswordButton,
         logInButton,
         secondTitleLabel,
         googleLoginButton,
         faceBookLoginButton,
         vkLoginButton].forEach { subview in
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
            


            forgotPasswordButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor),
            forgotPasswordButton.rightAnchor.constraint(equalTo: passwordTextField.rightAnchor),
            
            errorLabel.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor),
            errorLabel.leftAnchor.constraint(equalTo: passwordTextField.leftAnchor),
            errorLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
 
            logInButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor,
                                             constant: Constants.topOffset * 2),
            logInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Constants.loginButtonWidthMultiplier),
            logInButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),

            secondTitleLabel.topAnchor.constraint(equalTo: logInButton.bottomAnchor, constant: Constants.topOffset * 2),
            secondTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            googleLoginButton.topAnchor.constraint(equalTo: secondTitleLabel.bottomAnchor, constant: Constants.anotherButtonsOffset),
            googleLoginButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            googleLoginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Constants.anotherLoginWidthMultiplier),
            googleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            faceBookLoginButton.topAnchor.constraint(equalTo: googleLoginButton.bottomAnchor, constant: Constants.anotherButtonsOffset),
            faceBookLoginButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            faceBookLoginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Constants.anotherLoginWidthMultiplier),
            faceBookLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            vkLoginButton.topAnchor.constraint(equalTo: faceBookLoginButton.bottomAnchor, constant: Constants.anotherButtonsOffset),
            vkLoginButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            vkLoginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Constants.anotherLoginWidthMultiplier),
            vkLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

// MARK: - Button Actions
extension LogInViewController {
    @objc private func closeButtonTapped() {
        presenter.logInClosed()
    }

    @objc private func forgotPasswordTapped() {
        // TODO: - Обработка
    }

    @objc private func logInTapped() {
        loadingIndicator.startLoading()
        presenter.isFieldsCorrecltyPassed(email: emailTextField.text,
                                          password: passwordTextField.text)
    }

    @objc private func googleLogInTapped() {
        // TODO: - Обработка
    }

    @objc private func facebookLogInTapped() {
        // TODO: - Обработка
    }

    @objc private func vkLogInTapped() {
        // TODO: - Обработка
    }
}

// MARK: - UITextFieldDelegate Methods
extension LogInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension LogInViewController: LogInViewControllerProtocol {

    func startLogin() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else { return }
        presenter.nextFlow(with: email, with: password)
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
        case .success, .passwordMismatch:
            break
        }
    }

    func signInError(error: Error) {
        loadingIndicator.stopLoading()
        errorLabel.text = "Ошибка при входе: \(error.localizedDescription)"
        errorLabel.isEnabled = true
    }
}
