//
//  DetailTableViewCell.swift
//  Easybuy
//
//  Created by Yoav on 16/05/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    private lazy var productsLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = Design.Fonts.productFont
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    var products: String? {
        didSet {
            productsLabel.text = products
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        productsLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(productsLabel)
        NSLayoutConstraint.activate([
            productsLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            productsLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            productsLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            productsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
