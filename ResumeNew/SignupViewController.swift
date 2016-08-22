//************************************************************************//
//                                                                        //
//     File Name:     SignUpViewController.swift                          //
//     App Name:      LifeLine                                            //
//     Created by     Tanuj Nayanam, Rahul Biraj on 11/23/15.             //
//     Copyright ©    2015 Tanuj Nayanam, Rahul Biraj All rights reserved.//
//     Course Name:   Mobile Applicaton Programming                       //
//     CourseCode:    CSE - 651 FALL 2015                                 //
//     Language:      Swift 2.1                                           //
//     Tools:         Xcode Version 7.0.1                                 //
//     DevelopedOn:   OS X Yosemite 10.10.5                               //
//     Device Suport: IPhones                                             //
//                                                                        //
//************************************************************************//

/*
 *  View Controller for the SignUp where user registers
 *
 */

import UIKit
import CoreLocation
import MapKit

class SignupViewController: UIViewController, UITextFieldDelegate, UIAlertViewDelegate, CLLocationManagerDelegate, MapViewControllerDelegate // Conforming to implement protocol
{
    var location: CLLocation?  // here CLLocation is acting as B. And we are making delegate og CLLocation Manager
    
    //View or Outlets
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var userBloodGroup: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    var lat: Double = 0
    var long: Double = 0
    var address: String = ""
    
    let locationManager = CLLocationManager()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        firstName.delegate = self
        lastName.delegate = self
        age.delegate = self
        phoneNumber.delegate = self
        userName.delegate = self
        userEmail.delegate = self
        password.delegate  = self
        confirmPassword.delegate = self
        userBloodGroup.delegate = self
    }
    
    // Implement the protocol
    func addItemFromMapViewController(controller: MapViewController, loc location: MKPointAnnotation, address addressText: String)
    {
        lat = location.coordinate.latitude                                 // Storing the value came from MapViewController and it will be passed to SignUp Model
        long = location.coordinate.longitude
        address = addressText
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        geocoder.reverseGeocodeLocation(location)
        {
            (placemarks, error) -> Void in
            if let placemarks = placemarks where placemarks.count > 0
            {
                let placemark = placemarks[0]
                print(placemark.addressDictionary)
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Making current class a delegate of MapViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "GoToMapView"
        {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! MapViewController
            controller.delegate = self
        }
    }
    
    // SignUp Clicked
    @IBAction func signUpTouched(sender: UIButton)
    {
        errorLabel.text = ""
        if(Int(age.text!) == nil)
        {
            age.text = "0"
        }
        if(Int(phoneNumber.text!) == nil)
        {
            phoneNumber.text = "0"
        }
        let signUp = SignUp(fName: firstName.text!, lName: lastName.text!, age: Int(age.text!)!, phoneNumber: Int(phoneNumber.text!)!, uName: userName.text!, email: userEmail.text!, pass: password.text!, confirmPass: confirmPassword.text!, bGroup: userBloodGroup.text!, latitude: lat, longitude: long, address: address)
        do
        {
            try signUp.signUpUser() // here we are saving the data in database
            let alert = signUpSuccessAlert()
            presentViewController(alert, animated: true, completion: nil)
        }
        catch let error as Error
        {
            errorLabel.text = error.description
        }
        catch
        {
            errorLabel.text = "Something went wrong. Please try again!"
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    func signUpSuccessAlert() -> UIAlertController
    {
        let alertview = UIAlertController(title: "Sign Up successful", message: "now you can log in", preferredStyle: .Alert)
        alertview.addAction(UIAlertAction(title: "Log in", style: .Default, handler: {(alertAction) -> Void in self.dismissViewControllerAnimated(true, completion: nil)}  ))
        alertview.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        return alertview
    }
    
}
 