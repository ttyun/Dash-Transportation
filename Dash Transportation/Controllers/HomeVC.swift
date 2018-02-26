//
//  HomeVC.swift
//  Dash Transportation
//
//  Created by Tyler Yun on 2/24/18.
//  Copyright © 2018 Dash Transportation. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

// TO-DO : Only checks if the email is verified once; Need to find a way
// to constantly refresh so that isEmailVerified is updated

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkIfEmailVerified();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkIfEmailVerified() {
        // Refresh the user
        FIRAuth.auth()?.currentUser?.reload()

        // Determine if the email has been verified or not
        if !(FIRAuth.auth()?.currentUser?.isEmailVerified)! {
            // Go to the Verify Page
            let verifyVC = self.storyboard?.instantiateViewController(withIdentifier: "Verify")
            
            self.present(verifyVC!, animated: true, completion: nil)
        }
        else {
            print("VERIFIED")
        }
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