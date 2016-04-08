//
//  ThemeHandler.swift
//  Gaia
//
//  Created by Alex Clark on 4/7/16.
//  Copyright © 2016 John Henning. All rights reserved.
//

import UIKit
import ChameleonFramework

class ThemeHandler: NSObject {
    
    // Static Theme Object
    static let sharedThemeHandler = ThemeHandler()
    
    // Gradient Colors && Style
    let GradientBackgroundColors = [FlatGreenDark(), FlatMint()]
    let GradientStyle = UIGradientStyle.TopToBottom
    
    // Colors
    
    // Complementary
    let ComplementaryColor = UIColor(hexString: "#0948C5")
    let DarkComplementaryColor = UIColor(hexString: "#052A73")
    let LightComplementaryColor = UIColor(hexString: "#4777D6")
    
    // Secondary
    let SecondaryColor = UIColor(hexString: "#15E000")
    let DarkSecondaryColor = UIColor(hexString: "#4CE93C")
    let LightSecondaryColor = UIColor(hexString: "#0D8E00")
    
    func setFrameGradientTheme(vc: UIViewController?) {
    
        // Set passed view controller's background gradient
        if let vc = vc {
            
            vc.view.backgroundColor = GradientColor(GradientStyle, frame: vc.view.frame, colors: GradientBackgroundColors)
            
        }
        
    }

}
