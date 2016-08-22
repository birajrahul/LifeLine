//************************************************************************//
//                                                                        //
//     File Name:     MultipleAnnotationViewController.swift              //
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
 *  File to show the annotations for matching Blood Type donor in the MapView
 *
 */

import UIKit
import MapKit
import MessageUI

class MultipleAnnotationViewController: UIViewController, MKMapViewDelegate, MFMailComposeViewControllerDelegate
{
    var arrayOfPFObject: [PFObject] = [PFObject]()
    var s = [String]()
    var lat_ :Double = 0
    var long_ :Double = 0
    let currentUser = PFUser.currentUser()
    var pinAnnotationView:MKPinAnnotationView!
    
    @IBOutlet weak var dispAnnotation: MKMapView!          // Outlet for Annotations
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        dispAnnotation.delegate = self
        for coordinateItem in arrayOfPFObject
        {
            let pointAnnotation = MKPointAnnotation()
            self.lat_ = coordinateItem["Latitude"] as! Double
            self.long_ = coordinateItem["Longitude"] as! Double
            pointAnnotation.coordinate = CLLocationCoordinate2D(latitude:  self.lat_, longitude: self.long_)
            dispAnnotation.addAnnotation(pointAnnotation)
            pointAnnotation.title =  String(coordinateItem["LastName"]) + ", Loc: " + String(coordinateItem["Address"])    // Setting the text for annotations
            // Module to zoom the Map
            let miles = 10.0
            let scalingFactor =  abs(( cos ( 2*M_PI*pointAnnotation.coordinate.latitude/360.0  ) ) )
            var span = MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 0)
            span.latitudeDelta = miles/69.0
            span.longitudeDelta = miles/(scalingFactor * 69.0)
            let region = MKCoordinateRegionMake(pointAnnotation.coordinate, span)
            [ self.dispAnnotation.setRegion(region, animated: true)]
        }
    }
    
    // Notify all function to notify all the PFObject User
    @IBAction func Notifyall(sender: AnyObject)
    {
        for coordinateItem in arrayOfPFObject
        {
            s.append(coordinateItem["email"] as! String)   // Appending all the email
        }
        for _ in arrayOfPFObject
        {
            let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail()
            {
                self.presentViewController(mailComposeViewController, animated: true, completion: nil)
            }
            else
            {
                self.showSendMailErrorAlert()
            }
            let mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "TableView"
        {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! TableViewController
            controller.arrayOfPFObject = arrayOfPFObject
        }
    }

    // Configuring E-Mail
    func configuredMailComposeViewController() -> MFMailComposeViewController
    {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(s)
        mailComposerVC.setSubject("Please register to the Liferline App")
        mailComposerVC.setMessageBody("Hi , You can save someone's life by registering to this app, Thank you", isHTML: false)
        return mailComposerVC
    }
    
    func alertpopup() -> UIAlertController
    {
        let alertview = UIAlertController(title: "Email sent", message: "Thank you very much", preferredStyle: .Alert)
        alertview.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(alertAction) -> Void in self.dismissViewControllerAnimated(true, completion: nil)}  ))
        alertview.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        return alertview
    }
        
    func showSendMailErrorAlert()
    {
        let sendMailErrorAlert = UIAlertController(title: "Oops!", message:"This feature isn't available right now", preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default)
        {
            _ in
        }
        sendMailErrorAlert.addAction(action)
    }
    
    // Composing Email
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?)
    {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // Map View for Annotations
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
    {
        guard !(annotation is MKUserLocation)
        else
        {
            return nil
        }
        let identifier = "com.domain.app.something"
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView
        if annotationView == nil
        {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.pinTintColor = UIColor.redColor()
            annotationView?.image = UIImage(named: "b.png");
            annotationView?.canShowCallout = true
        }
        else
        {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
}
    


