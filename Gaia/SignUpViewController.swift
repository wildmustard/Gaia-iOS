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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onCreate(sender: AnyObject) {
        
        let newUser = PFUser()
        
        newUser.username = userNameField.text
        newUser.password = passwordField.text
        newUser.email = emailField.text
        //Try to sign new user up
        newUser.signUpInBackgroundWithBlock { (success:Bool,error: NSError?) -> Void in
            //if succesful execute this
            if success{
                print("Created a new user")
                
                
                //Segue not working
                
                //self.presentViewController((ContainerViewController() as? UIViewController)!, animated: true, completion: nil)
                
                
                //self.performSegueWithIdentifier("loginSegue", sender: nil)
            }else{
                print(error?.localizedDescription)
                
            }
        }

    }
   
    @IBAction func onBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {
        })

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
