//
//  VerifyVC.swift
//  Dash Transportation
//
//  Created by Tyler Yun on 2/25/18.
//  Copyright © 2018 Dash Transportation. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleMaps

// NOTE : Email Verification has a delay compared with the Refresh Button

class VerifyVC: UIViewController {

    @IBOutlet var verifyLabel: UILabel!
    @IBOutlet weak var verifyStatus: UILabel!
    
    @IBOutlet var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        verifyLabel.lineBreakMode = .byWordWrapping // or NSLineBreakMode.ByWordWrapping
        verifyLabel.numberOfLines = 0
        

        // Do any additional setup after loading the view.
        checkIfEmailVerified()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateButton() {
        registerButton.setTitleColor(UIColor.gray, for: UIControlState.highlighted)
        
    }
    
    @IBAction func registrationAction(_ sender: Any) {
        performSegue(withIdentifier: "back_to_register", sender: self)
    }
    
    func checkIfEmailVerified() {
        // Refresh the user
        FIRAuth.auth()?.currentUser?.reload()
        
        // Determine if the email has been verified or not
        if !(FIRAuth.auth()?.currentUser?.isEmailVerified)! {
            print("Still Not Verified")
        }
        else {
            verifyStatus.text = "Email Verified... Redirecting"
            
            // Go to the Home Page
            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "Home")
            
            self.present(homeVC!, animated: true, completion: nil)
        }
    }

    @IBAction func checkIfEmailVerified(_ sender: Any) {
        checkIfEmailVerified()
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
