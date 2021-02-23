//
//  ActionButton.swift
//  Easybuy
//
//  Created by Yoav on 20/04/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

import UIKit

final class ActionFillButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Design.Buttons.actionColor
        layer.cornerRadius = Design.Buttons.cornerRadius
        setTitleColor(.systemBackground, for: .normal)
        titleLabel?.numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
