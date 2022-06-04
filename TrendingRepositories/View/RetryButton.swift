//
//  RetryButton.swift
//  TrendingRepositories
//
//  Created by Usama Bashir on 04/06/2022.
//

import UIKit

@IBDesignable
class RetryButton: UIButton {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            self.layer.borderWidth = newValue
        }
        get {
            return self.layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            self.layer.cornerRadius = newValue
        }
        get {
            return self.layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let color = newValue else { return }
            self.layer.borderColor = color.cgColor
        }
        get {
            guard let color = self.layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
