//
//  LoadingIndicator.swift
//  Easybuy
//
//  Created by Yoav on 01/05/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

import UIKit

final class LoadingIndicator: UIView {

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(indicator)
        indicator.color = .white
        NSLayoutConstraint.activate([
            indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        return indicator
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .gray
        alpha = 0.8
        layer.cornerRadius = 12
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func startLoading() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            self.alpha = 0.88
            self.activityIndicator.startAnimating()
        }
    }

    func stopLoading() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            self.alpha = 0
            self.activityIndicator.stopAnimating()
        }
    }
}
