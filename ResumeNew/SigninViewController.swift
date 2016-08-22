//**************************************************************************//
//                                                                          //
//     File Name:     SignInViewController.swift                            //
//     App Name:      LifeLine                                              //
//     Created by     Tanuj Nayanam, Rahul Biraj on 11/23/15.               //
//     Copyright ©    2015 Tanuj Nayanam, Rahul Biraj All rights reserved.  //
//     Course Name:   Mobile Applicaton Programming                         //
//     CourseCode:    CSE - 651 FALL 2015                                   //
//     Language:      Swift 2.1                                             //
//     Tools:         Xcode Version 7.0.1                                   //
//     DevelopedOn:   OS X Yosemite 10.10.5                                 //
//     Device Suport: IPhones                                               //
//                                                                          //
//**************************************************************************//

/*
 *  View Controller for the Sign-In Option
 *
 */

import UIKit

class SigninViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        userName.delegate = self                        // Specifying that userName present in the SignInView's UI can delegate its task to SignInViewController
        password.delegate = self                        // Specifying that password present in the SignInView's UI can delegate its task to SignInViewController
    }

    // Function triggers when user click on SignIn
    @IBAction func signInTouched(sender: UIButton)
    {
        let signin = SignIn(user: userName.text!, pass: password.text!)    // Creating the object of SignIn Model and passing the user entered values username and password to the SignIn Model
        do
        {
            try signin.signInUser()                                         // The value is present with the SignIn Model now. So calling the SignInUser module in SignIn Model to log in the user
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        catch let error as Error
        {
            errorLabel.text = error.description
        }
        catch
        {
            errorLabel.text = "Please try again!"
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.view.endEditing(true)
    }

}
