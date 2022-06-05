//
//  RoundedImageView.swift
//  TrendingRepositories
//
//  Created by Usama Bashir on 05/06/2022.
//

import UIKit

@IBDesignable
class RoundedImageView: UIImageView {

    @IBInspectable var roundImage: Bool {
        set {
            if newValue == true {
                self.layer.cornerRadius = self.frame.height/2
            }
        }
        get {
            return false
        }
    }
    
}
