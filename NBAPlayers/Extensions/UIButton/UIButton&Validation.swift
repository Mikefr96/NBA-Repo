//
//  UIButton&Validation.swift
//  NBAPlayers
//
//

import UIKit

extension UIButton {
    var isValid: Bool {
        get { isEnabled && backgroundColor == .valid }
        set {
            backgroundColor = newValue ? .valid : .nonValid
            isEnabled = newValue
        }
    }
}
