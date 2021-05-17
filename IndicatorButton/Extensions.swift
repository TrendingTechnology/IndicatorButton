//
//  Extensions.swift
//  IndicatorButton
//
//  Created by quan bui on 2021/05/17.
//

import UIKit

extension UIButton {
    open func setTitle(_ text: String?) {
        for state: UIControl.State in [.normal, .highlighted, .disabled, .selected, .focused, .application, .reserved] {
            self.setTitle(text, for: state)
        }
    }
}

extension UIView {
    open func setCornerBorder(color: UIColor? = nil,
                              cornerRadius: CGFloat = 4.0,
                              borderWidth: CGFloat = 1.5) {
        self.layer.borderColor = color != nil ? color?.cgColor : UIColor.clear.cgColor
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.clipsToBounds = true
    }
}
