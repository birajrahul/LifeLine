//*************************************************************************//
//                                                                         //
//     File Name:     SearchBloodViewController.swift                      //
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
 *  Module to find the Right Blood Type from the database and filter according to blood seeker current location and range
 *
 */

import UIKit
import MapKit
import CoreLocation

// Protocol: helps in passing value back to SingUpViewController from MapViewController. Part of Delegate
class SearchBloodViewController: UIViewController, UITextFieldDelegate,  CLLocationManagerDelegate
{
    var arrayOfPFObject: [PFObject] = [PFObject]()
    var arrayOfLocationCoordinates: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
    var arrayOfFirstNameOfDonor = [String]()
    var arrayOfDonorAddress = [String]()
    var lat_: Double = 0
    var long_: Double = 0
    var location: CLLocation?
    var firstNameOfDonor: String = ""
    var donorAddress: String = ""
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var bloodType: UITextField!
    @IBAction func search(sender: UIButton){}
    
    // Method to noify if service is denied
    func showLocationServicesDeniedAlert()
    {
        let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(okAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // Method to get User Location
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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        getLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let newLocation = locations.last!
        location = newLocation
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
    {
        lat_ = Double((location?.coordinate.latitude)!)
        long_ = Double((location?.coordinate.longitude)!)
        let query = PFQuery(className: "_User")
        query.whereKey("BloodGroup", equalTo: bloodType.text!)
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
        let dest: MultipleAnnotationViewController   = segue.destinationViewController   as! MultipleAnnotationViewController
        dest.arrayOfPFObject = arrayOfPFObject
    }
    
}

