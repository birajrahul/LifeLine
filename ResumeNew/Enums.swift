//************************************************************************//
//                                                                        //
//     File Name:     Enums.swift                                         //
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
 *  Module for Error handling, Enums Creation
 *
 */

enum Error: ErrorType
{
    case EmptyField
    case PasswordDoNotMatch
    case InvalidEmail
    case UserNameTaken
    case IncorrectSignIn
    case InvalidPassword
    case InvalidBloodType
}

// Handling Error Enums
extension Error: CustomStringConvertible
{
    var description: String
    {
        switch self
        {
            case.EmptyField: return "Please fill in all the details"
            case.PasswordDoNotMatch: return "Password do not match"
            case.InvalidEmail: return "Please enter a valid email"
            case.UserNameTaken: return "Username already taken"
            case.IncorrectSignIn: return "Username or Password is incorrect"
            case.InvalidPassword: return "Enter password in correct format"
            case.InvalidBloodType: return "Enter a correct Blood Type [ O+, O-, A+, A-, B+, B-, AB+, AB-]"
        }
    }
    
}
