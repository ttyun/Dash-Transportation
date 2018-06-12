//
//  HomeExtendedVC.swift
//  Dash Transportation
//
//  Created by Tyler Yun on 3/9/18.
//  Copyright © 2018 Dash Transportation. All rights reserved.
//

import UIKit
import Stripe

class HomeExtendedVC: UIViewController, STPPaymentContextDelegate {
    
    private let paymentContext: STPPaymentContext
    private let customerContext: STPCustomerContext
    
    @IBOutlet weak var paymentButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        customerContext = STPCustomerContext(keyProvider: MainAPIClient.shared)
        paymentContext = STPPaymentContext(customerContext: customerContext)
    
        super.init(coder: aDecoder)
        
        paymentContext.delegate = self
        paymentContext.hostViewController = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Helpers
    
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
    
    // MARK: STPPaymentContextDelegate
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
    }
    
    // This method is called when a user selects a new payment method
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        // chooses Payment image icon
        reloadPaymentButtonContent(paymentContext)
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        
    }
    
    @IBAction func handlePaymentButtonTapped(_ sender: Any) {
        self.presentPaymentMethodsViewController()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Pay" {
            
            if(paymentContext == nil) {
                print("OMG ITS NIL")
            }
            
            let paymentVC : PaymentVC =  segue.destination as! PaymentVC
            paymentVC.paymentContext = paymentContext
        }
    }

}
