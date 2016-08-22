//**************************************************************************//
//                                                                          //
//     File Name:     InviteViewController.swift                            //
//     App Name:      LifeLine                                              //
//     Created by     Tanuj Nayanam, Rahul Biraj on 11/23/15.               //
//     Copyright ©    2015 Tanuj Nayanam., Rahul Biraj All rights reserved. //
//     Course Name:   Mobile Applicaton Programming                         //
//     CourseCode:    CSE - 651 FALL 2015                                   //
//     Language:      Swift 2.1                                             //
//     Tools:         Xcode Version 7.0.1                                   //
//     DevelopedOn:   OS X Yosemite 10.10.5                                 //
//     Device Suport: IPhones                                               //
//                                                                          //
//**************************************************************************//

/*
 *  This module sends mail about the app to the contacts
 *
 */

import UIKit
import MessageUI

class InviteViewController: UIViewController , MFMailComposeViewControllerDelegate
{
    @IBOutlet weak var inviteField: UITextField!        // Text field outlet for email input
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    // Invite function
    @IBAction func invitefunction(sender: AnyObject)
    {
        _ = inviteField.text!
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail()
        {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        }
        else
        {
            self.showSendMailErrorAlert()
        }
        let alert = alertpopup()
        presentViewController(alert, animated: true, completion: nil)
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        self.presentViewController(mailComposeViewController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // Configure and Compose the mail
    func configuredMailComposeViewController() -> MFMailComposeViewController
    {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([inviteField.text!])
        print(inviteField.text)
        mailComposerVC.setSubject("Please register to the Liferline App")
        mailComposerVC.setMessageBody("Hi , You can save someone's life by registering to this app, Thank you", isHTML: false)
        return mailComposerVC
    }
    
    // Error Handling
    func showSendMailErrorAlert()
    {
        let sendMailErrorAlert = UIAlertController(title: "Oops!", message:"This feature isn't available right now", preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default)
            {
                _ in
            }
        sendMailErrorAlert.addAction(action)
    }
    
    // Alert Pop Up
    func alertpopup() -> UIAlertController
    {
        let alertview = UIAlertController(title: "Email sent", message: "Thank you very much", preferredStyle: .Alert)
        alertview.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(alertAction) -> Void in self.dismissViewControllerAnimated(true, completion: nil)}  ))
        alertview.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        return alertview
    }
    
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?)
    {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
