//
//  SearchCollectionViewCell.swift
//  Easybuy
//
//  Created by Yoav on 13/05/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

import UIKit

final class SearchCollectionViewCell: UICollectionViewCell {
    
    var searchType: SearchType? {
        didSet {
            guard let searchType = searchType else { return }
            imageLabel.text = searchType.name
        }
    }

    var  imageName: String? {
        didSet {
            guard let name = imageName else { return }
            iconImageView.image = UIImage(named: name)
        }
    }

    private let iconImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    private let imageLabel: UILabel = {
        let imageLabel = UILabel()
        imageLabel.textAlignment = .center
        imageLabel.font = Design.Fonts.chpisButtonFont
        return imageLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupLayout()
        let redView = UIView(frame: bounds)
        redView.backgroundColor = .clear
        self.backgroundView = redView

        let selectedView = UIView(frame: bounds)
        selectedView.layer.backgroundColor = UIColor.red.withAlphaComponent(0.2).cgColor
        selectedView.layer.cornerRadius = 30
        self.selectedBackgroundView = selectedView
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        [iconImageView, imageLabel].forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(subview)
        }

        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            iconImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            iconImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            iconImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),

            imageLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor),
            imageLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}
