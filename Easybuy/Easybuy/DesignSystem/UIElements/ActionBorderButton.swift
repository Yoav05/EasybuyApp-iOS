//
//  ActionBorderButton.swift
//  Easybuy
//
//  Created by Yoav on 20/04/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

import UIKit

final class ActionBorderButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        layer.borderColor = Design.Buttons.actionColor.cgColor
        layer.borderWidth = Design.Buttons.borderWidth
        layer.cornerRadius = Design.Buttons.cornerRadius
        titleLabel?.numberOfLines = 0
        setTitleColor(Design.Buttons.actionColor, for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
