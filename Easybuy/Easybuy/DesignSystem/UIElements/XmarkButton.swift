//
//  XmarkButton.swift
//  Easybuy
//
//  Created by Yoav on 21/04/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

import UIKit

class XmarkButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setImage(UIImage(systemName: "xmark"), for: .normal)
        tintColor = UIColor.label
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
