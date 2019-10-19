//
//  Colors.swift
//  Contact
//
//  Created by vikas mishra on 19/10/19.
//  Copyright © 2019 vikas mishra. All rights reserved.
//

import Foundation
import UIKit

class Colors {
    
    static let shared = Colors()
    
    let colorTop = UIColor.white.cgColor
    let colorBottom = Colors.getPrimaryColor(opacity: 0.28).cgColor
    
    let gl: CAGradientLayer
    
    init() {
        gl = CAGradientLayer()
        gl.colors = [ colorTop, colorBottom]
        gl.locations = [ 0.0, 1.0]
    }
    
    static func getPrimaryColor(opacity: CGFloat) -> UIColor {
        return UIColor(red: 80.0/255.0, green: 227.0/255.0, blue: 194.0/255.0, alpha: opacity);
    }
    
    static func backgroundColor() -> UIColor {
        return UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0);
    }
}
