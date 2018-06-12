//
//  OtherAPIClient.swift
//  Dash Transportation
//
//  Created by Tyler Yun on 3/20/18.
//  Copyright © 2018 Dash Transportation. All rights reserved.
//
// An API client for "other" api calls
//

import UIKit
import Stripe
import Alamofire
import Firebase
import FirebaseAuth

class OtherAPIClient: NSObject {
    
    var baseURL = "https://us-central1-dash-transportation.cloudfunctions.net/api1"
    
    func createCustomerID(uid: String) {
        print("CREATE CID API MANGGGG!!!")
        let url = self.baseURL + "/customer/createCID/\(uid)"
        Alamofire.request(url, method: .post)
            .validate(statusCode: 200..<300)
            .responseJSON { responseJSON in
                switch responseJSON.result {
                case .success(let json):
                    print("WAKANDA WORKS!!!")
                    print("CUSTOMER ID WORKS!!!!:   \(json)")
//                    completion(json as? [String: AnyObject], nil)
                case .failure(let error):
                    print("CUSTOMER ID DOES NOT WORK \(error)")
//                    completion(nil, error)
                }
        }
    }
    
}
