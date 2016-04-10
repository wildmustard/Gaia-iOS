//
//  SignUpViewController.swift
//  Gaia
//
//  Created by Carlos Avogadro on 3/29/16.
//  Copyright © 2016 John Henning. All rights reserved.
//

import UIKit
import Parse
import ZFRippleButton

class SignUpViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var submitButton: ZFRippleButton!
    @IBOutlet weak var cancelButton: ZFRippleButton!
    
    var mainStoryboard: UIStoryboard?
    var containerViewController: ContainerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Grab Storyboard Instance && move to container view controller
        mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        containerViewController = mainStoryboard?.instantiateViewControllerWithIdentifier("Main") as? ContainerViewController
    
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Handle Gradient, Buttons, Label Attributes With ThemeHandler
        ThemeHandler.sharedThemeHandler.setFrameGradientTheme(self)
        ThemeHandler.sharedThemeHandler.setZFRippleButtonThemeAttributes(submitButton)
        ThemeHandler.sharedThemeHandler.setZFRippleButtonThemeAttributes(cancelButton)
        ThemeHandler.sharedThemeHandler.setLabelThemeAttributes(userNameLabel)
        ThemeHandler.sharedThemeHandler.setLabelThemeAttributes(emailLabel)
        ThemeHandler.sharedThemeHandler.setLabelThemeAttributes(passwordLabel)
        ThemeHandler.sharedThemeHandler.setTextFieldThemeAttributes(userNameField)
        ThemeHandler.sharedThemeHandler.setTextFieldThemeAttributes(emailField)
        ThemeHandler.sharedThemeHandler.setTextFieldThemeAttributes(passwordField)
        
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Submission Action
    @IBAction func onSubmit(sender: AnyObject) {

        // Setup new Parse User
        let newUser = PFUser()
        
        // Set new user from form post details
        newUser.username = userNameField.text
        newUser.password = passwordField.text
        newUser.email = emailField.text
        newUser["score"] = 0
        
        //Try to sign new user up
        newUser.signUpInBackgroundWithBlock { (success:Bool,error: NSError?) -> Void in
            
            // Failure
            if let error = error {
                
                // Log failure to create user
                NSLog("Unable to create Parse User\nError: \(error)\n")
                
            }
                // Creation Successful
            else {

                // Log success
                NSLog("Successfully created new user for Parse\nUser: \(newUser)")
                
                // Segue to Home
                self.presentViewController(self.containerViewController!, animated: true, completion: nil)
                
            }
        }
        
    }
   
    // Cancel User Signup Action
    @IBAction func onCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {
        })
    }
    
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    */
}