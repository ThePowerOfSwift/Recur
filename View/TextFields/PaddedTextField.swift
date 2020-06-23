//
//  PaddedTextField.swift
//  Recur
//
//  Created by Dread Pirate Nic on 6/25/19.
//  Copyright © 2019 buildschool. All rights reserved.
//
import UIKit

class PaddedTextField: UITextField {

    var padding = UIEdgeInsets.zero

    init(_ padding: UIEdgeInsets) {
        self.padding = padding
        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
