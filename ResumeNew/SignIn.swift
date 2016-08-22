//*************************************************************************//
//                                                                         //
//     File Name:     SignIn.swift                                         //
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
 *  Module for Signing In a user
 *
 */

//Main Class
class SignIn
{
    var userName: String?
    var password: String?
    
    // Setter of user id and password
    init(user: String, pass: String)
    {
        self.userName = user
        self.password = pass
    }
    
    // Checking for empty fields and credentials
    func signInUser() throws
    {
        guard hasEmptyFields() else {
            throw  Error.EmptyField
        }
        guard checkUserCredentials() else {
            throw Error.IncorrectSignIn
        }
    }
    
    // Checking if any of the fields are empty
    func hasEmptyFields() -> Bool
    {
        if !userName!.isEmpty && !password!.isEmpty
        {
            return true
        }
        return false
    }
    
    // Checking whether user Id and Password matches with that of stored in Parse
    func checkUserCredentials() -> Bool
    {
        do
        {
            try PFUser.logInWithUsername(userName!, password: password!)
        }
        //TODO: Error Handling
        catch
        {
            
        }
        if(PFUser.currentUser() != nil)

        {
            return true
        }
        return false
    }
    
}
