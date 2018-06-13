//
//  PaymentVC.swift
//  Dash Transportation
//
//  Created by James Yang on 6/12/18.
//  Copyright © 2018 Dash Transportation. All rights reserved.
//

// TODO: Initialized payment context here, but should be in home screen!!!
import UIKit
import Firebase
import FirebaseAuth
import Stripe

class PaymentVC: UIViewController, STPPaymentContextDelegate {
    
    private let paymentContext: STPPaymentContext
    private let customerContext: STPCustomerContext
    
    @IBOutlet weak var paymentButton: UIButton!
    @IBOutlet weak var totalCostLabel: UILabel!
    
    var totalTimeInSec: Double = Double()
    let costInCents = 25.0
    var totalCost: Double = Double()
    let basePrice = 100.0 // $1
    
    required init?(coder aDecoder: NSCoder) {
        customerContext = STPCustomerContext(keyProvider: MainAPIClient.shared)
        paymentContext = STPPaymentContext(customerContext: customerContext)
        
        super.init(coder: aDecoder)
        
        paymentContext.delegate = self
        paymentContext.hostViewController = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        totalCost = calculateTotalCost() + basePrice
        print("Total Cost \(totalCost)")
        print("Total Time \(totalTimeInSec)")

        displayCost()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func calculateTotalCost() -> Double {
        
         // 25/60 for .25 for 1 min
        let centPerSec = costInCents/60
        let totalCostInCents = round(centPerSec * totalTimeInSec)
        
        
        return totalCostInCents
    }
    @IBAction func completeCharge(_ sender: Any) {
        self.paymentContext.requestPayment()
        print("DID PAY")
    }
    
    // MARK: Helpers
    
    // GUI for the card
    func reloadPaymentButtonContent(_ paymentContext: STPPaymentContext) {
        // DEBUG:
        if (paymentContext.selectedPaymentMethod == nil) {
            print("PAYMENT METHOD IS NIL AND NOT SAVED")
            print(paymentContext.paymentMethods)
        }
        else {
            print("PAYMENT METHOD IS SAVED")
        }
        
        // Check if there is a selected payment method, if not set default
        guard let selectedPaymentMethod = paymentContext.selectedPaymentMethod else {
            // Show default image, text, and color
            let paymentIcon = UIImage(named: "Payment.png")
            self.paymentButton.setImage(paymentIcon, for: .normal)
            self.paymentButton.setTitle("Payment", for: .normal)
            //paymentButton.setTitleColor(.riderGrayColor, for: .normal)
            return
        }
        
        // Show selected payment method image, label, and darker color
        self.paymentButton.setImage(paymentContext.selectedPaymentMethod?.image, for: .normal)
        self.paymentButton.setTitle(paymentContext.selectedPaymentMethod?.label, for: .normal)
        //paymentButton.setTitleColor(.riderDarkBlueColor, for: .normal)
    }

    
    private func presentPaymentMethodsViewController() {
        guard !STPPaymentConfiguration.shared().publishableKey.isEmpty else {
            // Present error immediately because publishable key needs to be set
            let message = "Please assign a value to `publishableKey` before continuing. See `AppDelegate.swift`."
            //present(UIAlertController(message: message), animated: true)
            print(message)
            return
        }
        
        // Present the Stripe payment methods view controller to enter payment details
        self.paymentContext.presentPaymentMethodsViewController()
    }
    
    private func displayCost() {
        //var costStr = String(totalCost)
        //var costString = NSMutableString(string: costStr)
        var totalCostInDol = totalCost / 100
        
        //costString.insert(".", at: costString.length - 2)
        
        var costStr = String(totalCostInDol)
        var costString = NSMutableString(string: costStr)
        costString.insert("$", at: 0)
        self.totalCostLabel.text = costString.substring(to: costString.length)
        
    }
    
    
    // MARK: STPPaymentContextDelegate
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
    }
    
    // This method is called when a user selects a new payment method
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        // chooses Payment image icon
        reloadPaymentButtonContent(paymentContext)
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        print("GOT IN PAYMENT RESULTS")
        
        var ref: FIRDatabaseReference!
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        
        
        ref = FIRDatabase.database().reference()
        
        ref.child("users").child(userID!).child("customerID").observeSingleEvent(of: .value, with: { (snapshot) in
            let customerId = snapshot.value as! String
            
            
            MainAPIClient.shared.completeCharges(paymentResult, amount: Int(self.totalCost), description: "", customerId: customerId)
            self.performSegue(withIdentifier: "goBackToHome", sender: nil)
        })
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        
        print("IN ERROR")
        
        print(error)
    }
    
    @IBAction func changePaymentMethodTapped(_ sender: Any) {
        self.presentPaymentMethodsViewController()
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
