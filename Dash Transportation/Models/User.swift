
//
//  User.swift
//  Dash Transportation
//
//  Created by Tyler Yun on 2/24/18.
//  Copyright © 2018 Dash Transportation. All rights reserved.
//
import UIKit

// User Object to hold user-related info
class User: NSObject {
    var email : String
    var username : String
    var firstName : String
    var lastName : String
    var userStatus : Int
    var customerID: String
    
    init(email: String, username: String, firstName: String, lastName: String, userStatus: Int, customerID: String) {
        self.email = email
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.userStatus = userStatus
        self.customerID = customerID
    }
    
    // Helper function to create a Model using Firebase's Dictionary format
    func convertAnyObject() -> Any {
        return [
            "email": email,
            "username": username,
            "firstName": firstName,
            "lastName": lastName,
            "userStatus": userStatus,
            "customerID": customerID
        ]
    }
}
