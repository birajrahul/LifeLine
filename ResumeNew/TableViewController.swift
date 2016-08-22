//**************************************************************************//
//                                                                          //
//     File Name:     TableViewController.swift                             //
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
*  This module shows the donor contact in Tabular View
*
*/

import UIKit

class TableViewController: UITableViewController                         
{
    let cellIdentifier = "TableViewCell"
    var arrayOfPFObject: [PFObject] = [PFObject]()

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // Returning the number of sections in the table view
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrayOfPFObject.count
    }
    
     // Returning table view with contents to be shown
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TableViewCell
        let coordinateItem = arrayOfPFObject[indexPath.row]
        cell.Name.text = String(coordinateItem["FirstName"]) + "  " + String(coordinateItem["LastName"])
        cell.address.text = String(coordinateItem["Address"])
        cell.mytelephonenumber = String(coordinateItem["Phone"])
        return cell
    }

}
