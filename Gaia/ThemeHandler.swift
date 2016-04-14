//
//  ThemeHandler.swift
//  Gaia
//
//  Created by Alex Clark on 4/7/16.
//  Copyright © 2016 John Henning. All rights reserved.
//

import UIKit
import ChameleonFramework
import ZFRippleButton
import SVProgressHUD

class ThemeHandler: NSObject {
    
    // Static Theme Object
    static let sharedThemeHandler = ThemeHandler()
    
    // Gradient Colors && Style
    let GradientBackgroundColors = [FlatGreenDark(), FlatMint()]
    let GradientStyle = UIGradientStyle.TopToBottom
    
    // Colors
    
    // Primary
    let PrimaryColor1 = FlatMint()
    let PrimaryColor2 = FlatMintDark()
    let PrimaryColor3 = FlatGreen()
    let PrimaryColor4 = FlatGreenDark()
    
    // Complementary
    let ComplementaryColor1 = UIColor(hexString: "#4777D6")
    let ComplementaryColor2 = UIColor(hexString: "#1D5BD6")
    let ComplementaryColor3 = UIColor(hexString: "#0948C5")
    let ComplementaryColor4 = UIColor(hexString: "#073694")
    let ComplementaryColor5 = UIColor(hexString: "#052A73")
    
    // Secondary
    let SecondaryColor1 = UIColor(hexString: "#4CE93C")
    let SecondaryColor2 = UIColor(hexString: "#1FE909")
    let SecondaryColor3 = UIColor(hexString: "#15E000")
    let SecondaryColor4 = UIColor(hexString: "#11B600")
    let SecondaryColor5 = UIColor(hexString: "#0D8E00")
    
    
    // Fonts
    let ThemeFont = UIFont(name: "HelveticaNeue-CondensedBold", size: 20)
    let SmallThemeFont = UIFont(name: "HelveticaNeue-CondensedBold", size: 12)
    let LargeThemeFont = UIFont(name: "HelveticaNeue-CondensedBold", size: 36)
    
    // Functions
    override init() {
        
        super.init()
        setupThemeProgressHUDDefaults()
    
    }
    
    func setupThemeProgressHUDDefaults() {
        SVProgressHUD.setDefaultStyle(.Custom)
        SVProgressHUD.setBackgroundColor(ComplementaryColor3)
        SVProgressHUD.setDefaultAnimationType(.Native)
        SVProgressHUD.setCornerRadius(50)
        SVProgressHUD.setFont(LargeThemeFont)
        SVProgressHUD.setForegroundColor(UIColor.whiteColor())
        SVProgressHUD.setDefaultMaskType(.Black)
    }
    
    func setFrameGradientTheme(vc: UIViewController?) {
    
        // Set passed view controller's background gradient
        if let vc = vc {
            
            // Set Controller Gradient Theme
            vc.view.backgroundColor = GradientColor(GradientStyle, frame: vc.view.frame, colors: GradientBackgroundColors)
            
        }
        else {
            
            // Log Error
            log.error("Passed UIViewController \(vc?.nibName) does not exist!")
            
        }
        
    }
    
    func setDangerZFRippleButtonThemeAttributes(btn: ZFRippleButton?) {
        
        // Set passed button properties
        if let btn = btn {
            
            btn.shadowRippleEnable = true
            btn.shadowRippleRadius = 1
            btn.rippleOverBounds = false
            btn.trackTouchLocation = false
            btn.buttonCornerRadius = 5
            btn.rippleColor = FlatRed()
            btn.rippleBackgroundColor = FlatRedDark()
            
        }
        else {
            
            // Log
            log.error("Button passed does not exist!")
            
        }
        
    }
    
    func setToggleZFRippleButtonThemeAttributes(btn: ZFRippleButton?) {
        
        // Set passed button properties
        if let btn = btn {
            
            btn.shadowRippleEnable = true
            btn.shadowRippleRadius = 30
            btn.rippleOverBounds = true
            btn.trackTouchLocation = false
            btn.buttonCornerRadius = 0
            btn.rippleColor = ComplementaryColor1
            btn.rippleBackgroundColor = UIColor.clearColor()
            
        }
        else {
            
            // Log
            log.error("Button passed does not exist!")
            
        }
        
    }
    
    func setZFRippleButtonThemeAttributes(btn: ZFRippleButton?) {
        
        // Set passed button properties
        if let btn = btn {
            
            btn.shadowRippleEnable = true
            btn.shadowRippleRadius = 1
            btn.rippleOverBounds = false
            btn.trackTouchLocation = false
            btn.buttonCornerRadius = 5
            btn.rippleColor = ComplementaryColor1
            btn.rippleBackgroundColor = ComplementaryColor2
        
        }
        else {
        
            // Log
            log.error("Button passed does not exist!")

        }
    
    }
    
    func setTabZFRippleButtonThemeAttributes(btn: ZFRippleButton?) {
        
        // Set passed button properties
        if let btn = btn {
            
            btn.shadowRippleEnable = true
            btn.shadowRippleRadius = 1
            btn.rippleOverBounds = false
            btn.trackTouchLocation = false
            btn.buttonCornerRadius = 5
            btn.rippleColor = FlatGreen()
            btn.rippleBackgroundColor = FlatGreenDark()
            
        }
        else {
            
            // Log
            log.error("Button passed does not exist!")
            
        }
        
    }
    
    func switchTabZFRippleButtonActivity(btn: ZFRippleButton?, on: Bool!) {
        
        // Set passed button properties
        if let btn = btn {
            
            if !(on) {
                // Button turn off
                btn.backgroundColor = PrimaryColor4
                btn.rippleColor = PrimaryColor3
                btn.rippleBackgroundColor = PrimaryColor4
            }
            else {
                // Button turn on
                btn.backgroundColor = SecondaryColor1
                btn.rippleColor = SecondaryColor2
                btn.rippleBackgroundColor = SecondaryColor3
            }
            
        }
        else {
            
            // Log
            log.error("Button passed does not exist!")
            
        }
        
    }
    
    
    func setLabelThemeAttributes(label: UILabel?) {
        
        // Set passed button properties
        if let label = label {
            
            label.font = ThemeFont
            label.textColor = UIColor.whiteColor()
            
        }
        else {
            
            // Log
            log.error("Label passed does not exist!")
            
        }
        
    }
    
    func setSmallLabelThemeAttributes(label: UILabel?) {
        
        // Set passed button properties
        if let label = label {
            
            label.font = SmallThemeFont
            label.textColor = UIColor.whiteColor()
            
        }
        else {
            
            // Log
            log.error("Label passed does not exist!")
            
        }
        
    }
    
    func setLargeLabelThemeAttributes(label: UILabel?) {
        
        // Set passed button properties
        if let label = label {
            
            label.font = LargeThemeFont
            label.textColor = UIColor.whiteColor()
            
        }
        else {
            
            // Log
            log.error("Label passed does not exist!")
            
        }
        
    }
    
    func setTextFieldThemeAttributes(field: UITextField?) {
        
        // Set passed button properties
        if let field = field {
            
            field.font = ThemeFont
            field.textColor = UIColor.blackColor()
            field.borderStyle = .RoundedRect
            
        }
        else {
            
            // Log
            log.error("Label passed does not exist!")
            
        }
        
    }
}
