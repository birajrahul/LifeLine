//*************************************************************************//
//                                                                         //
//     File Name:     MainViewController.swift                             //
//     App Name:      LifeLine                                             //
//     Created by     Tanuj Nayanam, Rahul Biraj on 11/23/15.              //
//     Copyright ©    2015 Tanuj Nayanam, Rahul Biraj All rights reserved. //
//     Course Name:   Mobile Applicaton Programming                        //
//     CourseCode:    CSE - 651 FALL 2015                                  //
//     Language:      Swift 2.1                                            //
//     Tools:         Xcode Version 7.0.1                                  //
//     DevelopedOn:   OS X Yosemite 10.10.5                                //
//     Device Suport: IPhones                                              //
//                                                                         //
//*************************************************************************//

/*
 *  View Controller for the Home Page where Log Out option is displayed
 *
 */

import UIKit
import MapKit
import CoreLocation

class MainViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, CLLocationManagerDelegate
{
    var arrayOfPFObject: [PFObject] = [PFObject]()
    var arrayOfLocationCoordinates: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
    var arrayOfFirstNameOfDonor = [String]()// = arrayOfFirstName[]()
    var arrayOfDonorAddress = [String]()// = arrayOfFirstName[]()
    var lat_: Double = 0
    var long_: Double = 0
    var pNumber: Int = 0
    var location: CLLocation?
    var firstNameOfDonor: String = ""
    var donorAddress: String = ""
    let locationManager = CLLocationManager()
    
    @IBAction func bloodTypeSearch(sender: AnyObject) {}
    
    @IBOutlet weak var bloodTypeInput: UITextField!
    @IBOutlet weak var userNameLabel: UILabel!                                                      // Outlet to display Logged In User
    
    // Module to log out User
    @IBAction func LogOutUser(sender: AnyObject)                                                    // LogOut Module
    {
        PFUser.logOut()
        self.performSegueWithIdentifier("goSignIn", sender: self)                                   // Redirecting to the Login Window after Logout
    }

    override func viewDidAppear(animated: Bool)
    {
        getLocation()
        super.viewDidAppear(true)
        let currentUser = PFUser.currentUser()                                                      // Captured the current LoggedIn session User
        if currentUser != nil                                                                       // If currently no user is active then go to Sign In Page else update the Label of
        {
            self.userNameLabel.text = "Welcome: " + String(currentUser!["FirstName"]) + " " + String(currentUser!["LastName"])
        }
        else
        {
            self.performSegueWithIdentifier("goSignIn", sender: self)
        }
    }
    
    // Module to update location
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let newLocation = locations.last!
        location = newLocation
    }
    
    
    func showLocationServicesDeniedAlert()
    {
        let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(okAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    // Module to get location
    func getLocation()
    {
        
        let authStatus = CLLocationManager.authorizationStatus()
        
        if authStatus == .Denied || authStatus == .Restricted
        {
            showLocationServicesDeniedAlert()
            return
        }
        if authStatus == .NotDetermined
        {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    // Capturing and filtering the Parse Data
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
    {
          let currentUser = PFUser.currentUser()
        if(currentUser != nil)
        {
            lat_ = Double((location?.coordinate.latitude)!)
            long_ = Double((location?.coordinate.longitude)!)
            let query = PFQuery(className: "_User")
            query.whereKey("BloodGroup", equalTo: bloodTypeInput.text!)
            query.whereKey("Latitude", lessThan: lat_ + 0.60)
            query.whereKey("Latitude", greaterThan: lat_ - 0.60)
            query.whereKey("Longitude", greaterThan: long_ - 0.60)
            query.whereKey("Longitude", lessThan: long_ + 0.60)
            let currentUser = PFUser.currentUser()
            query.whereKey("objectId", notEqualTo: (currentUser?.valueForKey("objectId"))!)
            do
            {
                try arrayOfPFObject = query.findObjects() as [PFObject]
            }
            catch
            {
                // TODO: Exception Handling
            }
        let navigationController = segue.destinationViewController as! UINavigationController
        let dest = navigationController.topViewController as! MultipleAnnotationViewController
        dest.arrayOfPFObject = arrayOfPFObject
        }
        else{}
    }
    
}

