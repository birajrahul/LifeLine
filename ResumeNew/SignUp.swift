//*************************************************************************//
//                                                                         //
//     File Name:     SignUp.swift                                         //
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
 *  Model to store User SignUp Information to database
 *
 */

// Source Code: https://www.youtube.com/watch?v=nsVrfcAmitc&index=1&list=PLum6kTc8U8Cibv6tbEGNG5311oV_-PPDf
// Main Class

class SignUp: NSObject
{
    // Instance variables
    var firstName: String?
    var lastName: String?
    var address: String?
    var age: Int?
    var phoneNumber: Int?
    var bloodGroup: String?
    var userName: String?
    var userEmail: String?
    var password: String?
    var confirmPassword: String?
    var userLatitude: Double?
    var userLongitude: Double?
    var array: [PFObject] = [PFObject]()
    
    // Initilization
    // Receives all the SignUp Page info. SignUpViewController controller creates this Models object and pass the values entered by user through this constructor
    init(fName: String, lName: String, age: Int, phoneNumber: Int, uName: String, email: String, pass: String, confirmPass: String, bGroup: String, latitude: Double, longitude: Double, address: String)
    {
        self.firstName = fName
        self.lastName = lName
        self.age = age
        self.phoneNumber = phoneNumber
        self.bloodGroup = bGroup
        self.userName = uName
        self.userEmail = email
        self.password = pass
        self.confirmPassword = confirmPass
        self.userLatitude = latitude
        self.userLongitude = longitude
        self.address = address
    }
    
    // Error handling
    func signUpUser() throws -> Bool
    {
        guard hasEmptyFields() else {
            throw Error.EmptyField
        }
        guard isValidEmail() else {
            throw Error.InvalidEmail
        }
        guard validatePasswordmatch() else {
            throw Error.PasswordDoNotMatch
        }
        guard checkPasswordSufficientComplexity() else {
            throw Error.InvalidPassword
        }
        guard validateBloodType() else {
            throw Error.InvalidBloodType
        }
        guard storeSuccessfulSignUp() else {
            throw Error.UserNameTaken
        }
        return true
    }
    
    // Checking the validation of entered Blood Type
    func validateBloodType() ->Bool
    {
            if bloodGroup == "O+" || bloodGroup == "O" || bloodGroup == "A+" || bloodGroup == "A-" || bloodGroup == "B+" || bloodGroup == "B-" || bloodGroup == "AB+" || bloodGroup == "AB-"
            {
                return true
            }
            return false
    }
    
    // Checking if any of the field left empty
    func hasEmptyFields() -> Bool
    {
        if !firstName!.isEmpty && !lastName!.isEmpty && !userName!.isEmpty && !userEmail!.isEmpty && !password!.isEmpty && !confirmPassword!.isEmpty && !bloodGroup!.isEmpty
        {
            return true
        }
        return false
    }
    
    // Checking Email Validity
    func isValidEmail() -> Bool
    {
        let emailEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let range = userEmail!.rangeOfString(emailEx, options: .RegularExpressionSearch )
        let result = range != nil ? true : false
        return result
    }
    
    // Checking Password match
    func validatePasswordmatch() -> Bool
    {
        if(password! == confirmPassword)
        {
            return true
        }
        return false
    }
    
    // Checking password complexity
    func checkPasswordSufficientComplexity() -> Bool
    {
        let capitalLetterRegEx = ".*[A-Z]+.*"
        let texttest = NSPredicate(format: "SELF MATCHES %@" , capitalLetterRegEx)
        let capitalResult = texttest.evaluateWithObject(password!)
        print("Capital letter: \(capitalResult)")
        let numberRegEx = ".*[0-9]+.*"
        let textTest2 = NSPredicate(format: "SELF MATCHES %@", numberRegEx)
        let numberResult = textTest2.evaluateWithObject(password!)
        print("Number included \(numberResult)")
        let lengthResult = password!.characters.count >= 8
        print("Passed Length: \(lengthResult)")
        return capitalResult && numberResult && lengthResult
    }
    
    // Stores all the data to Parse
    // Square Brackets represent the columns name in Parse database. Column names are automatically created in online Parse Database
    func storeSuccessfulSignUp() -> Bool
    {
        var success = false
        let user = PFUser()
        user["FirstName"] = firstName!
        user["LastName"] = lastName!
        user["BloodGroup"] = bloodGroup!
        user.username = userName!
        user.email = userEmail!
        user["Latitude"] = userLatitude!
        user["Longitude"] = userLongitude!
        user["Address"] = address!
        user["Age"] = age!
        user.password = password!
        user["Phone"] = phoneNumber!
        do
        {
            try user.signUp()
        }
        //TODO: Error handling
        catch
        {
            
        }
        success = user.isNew        // New instance of created
        return success
    }
    
}

