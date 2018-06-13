//
//  MainAPIClient.swift
//  Dash Transportation
//
//  Created by Tyler Yun on 3/9/18.
//  Copyright © 2018 Dash Transportation. All rights reserved.
//
import UIKit
import Stripe
import Alamofire
import Firebase
import FirebaseAuth

class MainAPIClient: NSObject, STPEphemeralKeyProvider {
    
    static let shared = MainAPIClient()
    
    var baseURL = "https://us-central1-dash-transportation.cloudfunctions.net/api1"
    
    private func getEphemeralKey(customerID: String, apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        
        print("CUSTOMER ID: ---------- \(customerID)")
        
        print(apiVersion)
        
        let url = self.baseURL + "/ephemeral_keys/\(apiVersion)/\(customerID)"
        Alamofire.request(url, method: .post)
            .validate(statusCode: 200..<300)
            .responseJSON { responseJSON in
                switch responseJSON.result {
                case .success(let json):
                    print("API WORKS!!!!")
                    completion(json as? [String: AnyObject], nil)
                case .failure(let error):
                    print("API DOES NOT WORK \(error)")
                    completion(nil, error)
                }
        }
    }
    
    // MARK: STPEphemeralKeyProvider
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        
        // Reference to Database
        var ref: FIRDatabaseReference
        
        // Reference to Customer ID
        var customerID : String = ""
        
        // Path for the Database
        ref = FIRDatabase.database().reference()
        
        // Create a reference user path using the current user id
        let userRef = ref.child("users").child((FIRAuth.auth()?.currentUser?.uid)!)
        
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let userDict = snapshot.value as! NSDictionary
            
            customerID = userDict["customerID"] as! String
            print("UID: \((FIRAuth.auth()?.currentUser?.uid)!)")
            print(customerID)
            
            self.getEphemeralKey(customerID: customerID, apiVersion: apiVersion, completion: completion)
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func completeCharges(_ result: STPPaymentResult, amount: Int,
                         description: String, customerId: String) {
        
        print("Amount: ---------- \(amount)")
        print("CID: \(customerId)")
        print(description)
        
        let url = self.baseURL + "/payment/createCharge/\(result.source.stripeID)/\(amount)/\(description)/\(customerId)"
        print(url)
        Alamofire.request(url, method: .post)
            .validate(statusCode: 200..<300)
            .responseJSON { responseJSON in
                switch responseJSON.result {
                case .success(let json):
                    print("API WORKS!!!!")
                //completion(json as? [String: AnyObject], nil)
                case .failure(let error):
                    print("API DOES NOT WORK \(error)")
                    //completion(nil, error)
                }
        }
    }
}
