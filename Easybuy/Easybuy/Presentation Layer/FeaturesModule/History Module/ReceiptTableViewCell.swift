//
//  ReceiptTableViewCell.swift
//  Easybuy
//
//  Created by Yoav on 06/05/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

import UIKit

class ReceiptTableViewCell: UITableViewCell {

    private lazy var title: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = Design.Fonts.largeTitleRegularFont
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "Чек"
        return label
    }()
    
    
    private lazy var timeStampLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = Design.Fonts.chpisButtonFont
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

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

    var timeStamp: String? {
        didSet {
            timeStampLabel.text = timeStamp
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        [timeStampLabel, title, productsLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false; contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            title.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
    
            timeStampLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            timeStampLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            
            productsLabel.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 12),
            productsLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            productsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
}
