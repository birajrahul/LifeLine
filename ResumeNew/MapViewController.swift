//*************************************************************************//
//                                                                         //
//     File Name:     MapViewController.swift                              //
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
 *  Module to find address entered by the user and save it to parse Database
 *  Address Entered is passed back to the SignUpViewController for futher processing
 */

import UIKit
import MapKit

// Protocol: helps in passing value back to SingUpViewController from MapViewController. Part of Delegate
protocol MapViewControllerDelegate: class
{
    func addItemFromMapViewController(controller: MapViewController,  loc location: MKPointAnnotation, address addressText: String)
}

// Main Class
class MapViewController: UIViewController, UISearchBarDelegate
{
    weak var delegate: MapViewControllerDelegate?
    
    var searchController:UISearchController!                    // Manages the presentation of searchbar
    var annotation:MKAnnotation!                                // Reference to drawn annotation
    var localSearchRequest:MKLocalSearchRequest!                // This object is prepared and passed to MKLocalSearch object
    var localSearch:MKLocalSearch!                              // It will initiate the search of location entered asynchronously
    var localSearchResponse:MKLocalSearchResponse!              // Search Response is stored in this var
    var error:NSError!                                          // Error if any
    var pointAnnotation:MKPointAnnotation!                      // Work for drawing annotation pin once location found
    var pinAnnotationView:MKPinAnnotationView!                  // Work for drawing annotation pin once location found
    var addressText:String!
    @IBOutlet weak var mapView: MKMapView!                      // Outlet connected to MapView in the UI of MapViewController
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 34.03, longitude: 118.14)      // determining initial map load view
        let span = MKCoordinateSpanMake(100, 80)
        let region = MKCoordinateRegionMake(coordinate, span)
        self.mapView.setRegion(region, animated: true)
    }
    
    // Function triggered on Clicking "Done" in order to Send Location to SingUpViewController
    @IBAction func sendLocation(sender: UIBarButtonItem)
    {
        let location = MKPointAnnotation()
        location.coordinate.latitude = self.pointAnnotation.coordinate.latitude
        location.coordinate.longitude = self.pointAnnotation.coordinate.longitude
        delegate?.addItemFromMapViewController(self, loc: location, address: addressText)
    }
    
    // Function to trigger Search of location and push the result to th outlet of MapViewController named: mapView
    @IBAction func showSearchBar(sender: UIBarButtonItem)
    {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        presentViewController(searchController, animated: true, completion: nil)
    }
    
    // Function gets triggered when Enter Button is clicked from keyboard
    // Source Code: http://sweettutos.com/2015/04/24/swift-mapkit-tutorial-series-how-to-search-a-place-address-or-poi-in-the-map/
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()                                  // Responsible for popping out search bar when search button is clicked
        dismissViewControllerAnimated(true, completion: nil)
        if self.mapView.annotations.count != 0
        {
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        // Inititaion of Search Process asynchronously
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler
        {
            (localSearchResponse, error) -> Void in
            if localSearchResponse == nil
            {
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            // If valid address then draw annotation
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.addressText = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
            // Setting the Zoomness of map
            let miles = 10.0
            let scalingFactor =  abs(( cos ( 2*M_PI*self.pointAnnotation.coordinate.latitude/360.0  ) ) )
            var span = MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 0)
            span.latitudeDelta = miles/69.0
            span.longitudeDelta = miles/(scalingFactor * 69.0)
            let region = MKCoordinateRegionMake(self.pointAnnotation.coordinate, span)
            [self.mapView.setRegion(region, animated: true)]
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
}






