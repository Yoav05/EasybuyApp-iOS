//
//  ReceiptViewController.swift
//  Easybuy
//
//  Created by Yoav on 04/05/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

import UIKit

protocol ReceiptViewControllerProtocol: AnyObject {
    
}

final class ReceiptViewController: UIViewController {
    
    private enum Constants {
        static let topOffset: CGFloat = 20
        static let buttonHeight: CGFloat = 60
        static let doneButtonHeight: CGFloat = 20
        static let titleOffset: CGFloat = 16
        static let textViewPlaceholder = "Нажмите, чтобы начать записывать"
    }

    private let presenter: ReceiptPresenterProtocol
    
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
        label.text = "Добавить чек"
        return label
    }()

    private lazy var textView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.isUserInteractionEnabled = true
        textView.delegate = self
        textView.adjustsFontForContentSizeCategory = true
        textView.font = Design.Fonts.receiptFont
        textView.text = Constants.textViewPlaceholder
        textView.textColor = UIColor.lightGray
        return textView
    }()

    private let saveButton: ActionFillButton = {
        let button = ActionFillButton(type: .system)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.setTitle("СОХРАНИТЬ", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = Design.Fonts.buttonFont
        return button
    }()

    private let doneButton: ActionFillButton = {
        let button = ActionFillButton(type: .system)
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        button.setTitle("ГОТОВО", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = Design.Fonts.chpisButtonFont
        button.alpha = 0
        return button
    }()

    init(presenter: ReceiptPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.viewDidDisappear()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupKeyboard()
        setupLayout()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard UIApplication.shared.applicationState == .inactive else { return }
        setColors()
    }

    private func setupKeyboard() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    private func setupLayout() {
        [titleLabel, textView, saveButton, doneButton, closeButton].forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subview)
        }
        NSLayoutConstraint.activate([

            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.topOffset),
            closeButton.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),

            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.titleOffset),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.topOffset),
            doneButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25),
            doneButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            doneButton.heightAnchor.constraint(equalToConstant: Constants.doneButtonHeight),
            
            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.topOffset),
            textView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),

            saveButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: Constants.topOffset),
            saveButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            saveButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -Constants.topOffset)
        ])
    }

    private func setColors() {
        if textView.textColor != UIColor.lightGray {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                textView.textColor = .white
            } else {
                textView.textColor = .black
            }
        }
    }
}

private extension ReceiptViewController {

    @objc func saveButtonTapped() {
        if (textView.textColor != UIColor.lightGray) {
            presenter.saveReceipt(receipt: textView.text)
        }
        self.dismiss(animated: true, completion: nil)
    }

    @objc func doneButtonTapped() {
        doneButton.alpha = 0
        textView.resignFirstResponder()
        if (textView.textColor != UIColor.lightGray) {
            textView.text = presenter.transformTextToEnumeateList(text: textView.text)
        }
    }

    @objc func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = .zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        textView.scrollIndicatorInsets = textView.contentInset

        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
}

extension ReceiptViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        doneButton.alpha = 1
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            if UITraitCollection.current.userInterfaceStyle == .dark {
                textView.textColor = .white
            } else {
                textView.textColor = .black
            }
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Constants.textViewPlaceholder
            textView.textColor = UIColor.lightGray
        }
    }
}

extension ReceiptViewController: ReceiptViewControllerProtocol {
    
}
