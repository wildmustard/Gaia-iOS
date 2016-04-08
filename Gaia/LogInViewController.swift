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
        
        // Present SignUp Controller
        presentViewController((SignUpViewController() ), animated: true, completion: nil)
        
        
    }
    //If the user exists segue into the Container view
    @IBAction func onLogin(sender: AnyObject) {
        
        PFUser.logInWithUsernameInBackground(userNameField.text!, password:passwordField.text!) { (user: PFUser?, error: NSError?) -> Void in
            
            if user != nil{
                
                print("You are logged in")
                
                
                //Segue not working
                self.presentViewController(self.containerViewController!, animated: true, completion: nil)
                
                //self.performSegueWithIdentifier("loginSegue", sender: nil)
                
            }
            
        }

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
    }
    */

}
