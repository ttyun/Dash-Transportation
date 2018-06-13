//
//  SignUpVC.swift
//  Dash Transportation
//
//  Created by Tyler Yun on 2/24/18.
//  Copyright © 2018 Dash Transportation. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpVC: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet var signUpButton: UIButton!
    
    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "backLogin", sender: self)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        performSegue(withIdentifier: "back_to_home", sender: self)
    }
    
    var sessionState : Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateButton()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateButton() {
        signUpButton.setTitleColor(UIColor.gray, for: UIControlState.highlighted)
        
    }

    @IBAction func signUpUser(_ sender: Any) {
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
            FIRAuth.auth()?.createUser(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
                
                // Alert user if there is an error (by Firebase)
                if error != nil {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                else {
                    print("Successful Sign Up")
                    
                    // Reference to Database
                    var ref: FIRDatabaseReference
                    
                    // Create the users path for the Database
                    ref = FIRDatabase.database().reference(withPath: "users")
                    
                    // Fields to set in Firebase Database
                    let emailText = self.emailField.text
                    let usernameText = self.usernameField.text
                    let firstNameText = self.firstNameField.text
                    let lastNameText = self.lastNameField.text
                    let userStatus = 1
                    let customerID = ""
                    
                    // Pass in the sign up information to our User Object Model; Models/Users.Swift
                    let userModel = User(email: emailText!, username: usernameText!, firstName: firstNameText!, lastName: lastNameText!, userStatus: userStatus, customerID: customerID)
                    
                    // Create a reference user path using the current user id
                    let userRef = ref.child((FIRAuth.auth()?.currentUser?.uid)!)
                    
                    // Set the user reference to be the previously created User Model
                    userRef.setValue(userModel.convertAnyObject())
                    
                    // API call to create and push customer id
                    let otherAPIInstance = OtherAPIClient();
                    
                    // pushed cid onto firebase db through an api call
                    otherAPIInstance.createCustomerID(uid:(FIRAuth.auth()?.currentUser?.uid)!)
                    
                    self.performSegue(withIdentifier: "Login", sender: nil)
                    
                    //self.present(loginVC!, animated: true, completion: nil)
                }
            }
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "Login" {
            let loginVC : LoginVC = segue.destination as! LoginVC
            
            loginVC.sessionState = 1
        }
    }
}

