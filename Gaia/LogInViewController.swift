//
//  LogInViewController.swift
//  Gaia
//
//  Created by Carlos Avogadro on 3/29/16.
//  Copyright © 2016 John Henning. All rights reserved.
//

import UIKit
import Parse
import ZFRippleButton
import GoogleMaterialIconFont
import ChameleonFramework
import SVProgressHUD

class LogInViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: ZFRippleButton!
    @IBOutlet weak var signUpButton: ZFRippleButton!
    
    
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
        // Handle Gradient With ThemeHandler
        ThemeHandler.sharedThemeHandler.setFrameGradientTheme(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Load sign up view to create a new User
    @IBAction func onNewUser(sender: AnyObject) {
        
        let vc = SignUpViewController()
        vc.view.frame.size = self.view.frame.size
        
        // Present SignUp Controller
        presentViewController(vc, animated: true, completion: nil)
        
    }
    //If the user exists segue into the Container view
    @IBAction func onLogin(sender: AnyObject) {
        // Close keyboard
        view.endEditing(true)
        // Show Progress Wheel While Login
        SVProgressHUD.show()
        // Log user in
        PFUser.logInWithUsernameInBackground(userNameField.text!, password:passwordField.text!) { (user: PFUser?, error: NSError?) -> Void in
            if let error = error {
                // Log failure
                log.error("Unable to log in user in background!")
            }
            else {
                // Log User Info
                log.info("User \(user!.username) has logged in")
                // Segue to ContainerViewController
                self.presentViewController(self.containerViewController!, animated: true, completion: nil)
            }
            // Close wheel
            SVProgressHUD.dismiss()
        }
    }
    
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }

}
