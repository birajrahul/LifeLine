//**************************************************************************//
//                                                                          //
//     File Name:     TableViewCell.swift                                    //
//     App Name:      LifeLine                                              //
//     Created by     Tanuj Nayanam, Rahul Biraj on 11/23/15.               //
//     Copyright ©    2015 Tanuj Nayanam,Rahul Biraj All rights reserved.   //
//     Course Name:   Mobile Applicaton Programming                         //
//     CourseCode:    CSE - 651 FALL 2015                                   //
//     Language:      Swift 2.1                                             //
//     Tools:         Xcode Version 7.0.1                                   //
//     DevelopedOn:   OS X Yosemite 10.10.5                                 //
//     Device Suport: IPhones                                               //
//                                                                          //
//**************************************************************************//

/*
*  This module represents the table cell and contains donor's details
*
*/

import UIKit

class TableViewCell: UITableViewCell
{
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var Name: UILabel!
    
    var mytelephonenumber : String!
    
    // Module for calling Donor's Number
    @IBAction func Call(sender: AnyObject)
    {
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://" + mytelephonenumber)!)
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }

}
