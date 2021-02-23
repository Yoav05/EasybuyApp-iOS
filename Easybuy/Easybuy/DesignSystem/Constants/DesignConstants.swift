//
//  DesignConstants.swift
//  Easybuy
//
//  Created by Yoav on 20/04/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

import UIKit
enum Design {

    enum Buttons {
        // Orange
//        static let actionColor: UIColor = UIColor(red: 255 / 255.0, green: 149 / 255.0, blue: 0 / 255.0, alpha: 1)
        // Blue
        static let actionColor: UIColor = UIColor(red: 0 / 255.0, green: 122 / 255.0, blue: 255 / 255.0, alpha: 1)
        // Tea Blue
//        static let actionColor: UIColor = UIColor(red: 90 / 255.0, green: 200 / 255.0, blue: 250 / 255.0, alpha: 1)
        static let dismissColor: UIColor = UIColor(red: 54 / 255.0, green: 54 / 255.0, blue: 54 / 255.0, alpha: 1)
        static let borderWidth: CGFloat = 1
        static let cornerRadius: CGFloat = 10
    }

    enum Fonts {
        static let largeTitleRegularFont: UIFont = UIFont(name: "SFProRounded-Regular", size: 25)!
        static let largeBannerRegularFont: UIFont = UIFont(name: "SFProRounded-Regular", size: 35)!
        static let largeTitleThinFont: UIFont = UIFont(name: "SFProRounded-Ultralight", size: 25)!
        static let buttonFont: UIFont =  UIFont(name: "SFProRounded-Regular", size: 20)!
        static let forgotButtonFont: UIFont = UIFont(name: "SFProRounded-Regular", size: 16)!
        static let authErrorFont: UIFont = UIFont(name: "SFProRounded-Regular", size: 12)!
        static let chpisButtonFont: UIFont = UIFont(name: "SFProRounded-Regular", size: 14)!
        static let thinButtonFont: UIFont = UIFont(name: "SFProRounded-Regular", size: 15)!
        static let receiptFont: UIFont = UIFont(name: "SFProRounded-Medium", size: 25)!
        static let productFont: UIFont = UIFont(name: "SFProRounded-Thin", size: 25)!
    }
}
