//
//  LoginVC.swift
//  Dash Transportation
//
//  Created by Tyler Yun on 2/24/18.
//  Copyright © 2018 Dash Transportation. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    // 0 - Means no session
    // 1 - Means there currently is session
    var sessionState : Int = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //print(FIRAuth.auth()?.currentUser?.email)
        print(sessionState)
        if sessionState == 1 {
            FIRAuth.auth()?.currentUser?.sendEmailVerification(completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindBackToLogin(segue : UIStoryboardSegue) {
    }
    
    @IBAction func loginUser(_ sender: Any) {
        // Checks if email or password is empty
        if emailField.text == "" || passwordField.text == "" {
            // If empty, set an error alert message
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password.", preferredStyle: .alert)
            
            // Action button for OK
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            // Present an alert to enter email and pwd
            present(alertController, animated: true, completion: nil)
        }
        else {
            // Create a new account using Firebase Authentication
            FIRAuth.auth()?.signIn(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
                
                // Alert user if there is an error (by Firebase)
                if error != nil {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                else {
                    print("Successful Log In")
                    
                    // Go to the Home Page
                    let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                    
                    self.present(homeVC!, animated: true, completion: nil)
                }
            }
        }
    }
    
//    func test(error) {
//        let alertController = UIAlertController(title: "Success", message: "Please enter your email and password.", preferredStyle: .alert)
//
//        // Action button for OK
//        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//        alertController.addAction(defaultAction)
//
//        // Present an alert to enter email and pwd
//        present(alertController, animated: true, completion: nil)
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
