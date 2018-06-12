//
//  PaymentVC.swift
//  Dash Transportation
//
//  Created by Jong Wan Kim on 6/11/18.
//  Copyright © 2018 Dash Transportation. All rights reserved.
//

import UIKit
import Stripe
import Firebase

class PaymentVC: UIViewController, STPPaymentContextDelegate {
    
    var totalCost = 199

    var paymentContext: STPPaymentContext?
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        if paymentContext == nil {
//            print("Nul payment context")
//        }
//        else {
//            print("GOOD PAYMENT CONTEXT")
//        }
//        paymentContext!.delegate = self
//        paymentContext!.hostViewController = self
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if paymentContext == nil {
            print("Nul payment context")
        }
        else {
            print("GOOD PAYMENT CONTEXT")
        }
        
        paymentContext!.delegate = self
        //paymentContext!.hostViewController = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func completeCharge(_ sender: UIButton) {
    
        self.paymentContext!.requestPayment()
        print("DID PAY")
    }
    
    
    // MARK: STPPaymentContextDelegate
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
    }
    
    // This method is called when a user selects a new payment method
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        // chooses Payment image icon
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        print("GOT IN PAYMENT RESULTS")
        
        var ref: FIRDatabaseReference!
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        
        
        ref = FIRDatabase.database().reference()
        
        ref.child("users").child(userID!).child("customerID").observeSingleEvent(of: .value, with: { (snapshot) in
            let customerId = snapshot.value as! String
            
          
            MainAPIClient.shared.completeCharges(paymentResult, amount: self.totalCost, description: "Goingtocompletechargefor199", customerId: customerId)
        })
        
        
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        
        print("IN ERROR")
        
        print(error)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
