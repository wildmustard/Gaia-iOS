//
//  SignUpViewController.swift
//  Gaia
//
//  Created by Carlos Avogadro on 3/29/16.
//  Copyright © 2016 John Henning. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var mainStoryboard: UIStoryboard?
    var containerViewController: ContainerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        containerViewController = mainStoryboard?.instantiateViewControllerWithIdentifier("Main") as? ContainerViewController
        // Do any additional setup after loading the view.
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Submission Action
    @IBAction func onSubmit(sender: AnyObject) {

        // Setup new Parse User
        let newUser = PFUser()
        
        // Set new user from form post details
        newUser.username = userNameField.text
        newUser.password = passwordField.text
        newUser.email = emailField.text
        
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    */
}