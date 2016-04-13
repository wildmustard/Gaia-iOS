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
import SVProgressHUD

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
        // Close keyboard
        view.endEditing(true)
        // Setup new Parse User
        let newUser = PFUser()
        // Set new user from form post details & client defaults
        newUser.username = userNameField.text
        newUser.password = passwordField.text
        newUser.email = emailField.text
        newUser["score"] = 0
        GaiaUserClient.sharedInstance.setDefaultProfileImageForUser(newUser)
        // Start SVProgressHUD
        SVProgressHUD.show()
        // Sign up new user
        newUser.signUpInBackgroundWithBlock { (success:Bool,error: NSError?) -> Void in
            // Failure
            if let error = error {
                // Log failure to create user
                log.error("Unable to create Parse User\nError: \(error)\n")
                // Alert user to post failure
                let alert = UIAlertController(title: "Error Creating Your User", message: "Please Try Again!", preferredStyle: .Alert)
                let dismissAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                alert.addAction(dismissAction)
                self.presentViewController(alert, animated: true) {}
            }
            else {
                // Log success
                log.info("Successfully created new Gaia User for Parse\nUser: \(newUser)")
                // Segue to Home
                self.presentViewController(self.containerViewController!, animated: true, completion: nil)
            }
            // Close progress wheel when done with success / fail attempt
            SVProgressHUD.dismiss()
        }
    }
   
    // Cancel User Signup Action
    @IBAction func onCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    
    // Tap gesture for handling editing end
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
}