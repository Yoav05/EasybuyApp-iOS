//
//  DismissButton.swift
//  Easybuy
//
//  Created by Yoav on 20/04/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

import UIKit

final class DismissButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Design.Buttons.dismissColor
        layer.cornerRadius = Design.Buttons.cornerRadius
        titleLabel?.numberOfLines = 0
        setTitleColor(.white, for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
