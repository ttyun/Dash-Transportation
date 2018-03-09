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
import GoogleMaps //api used to display our map using Google Maps API
import GooglePlaces //api used to get current location of device



// TO-DO : Only checks if the email is verified once; Need to find a way
// to constantly refresh so that isEmailVerified is updated

class HomeVC: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        //defines map, and zooms in on a particular area defined by 'withLatitude' and 'longitude'
        let camera = GMSCameraPosition.camera(withLatitude: 35.3002115, longitude: -120.661867, zoom: 16.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        //makes our viewController a full screen map
        view = mapView
        
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true

        
        
        //defines a marker for our map, and places a pointer on specific latitude and longitude
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 35.298499, longitude: -120.659908)
        marker.title = "Scooter"
        marker.map = mapView
        
        
        let secondMarker = GMSMarker()
        secondMarker.position = CLLocationCoordinate2D(latitude: 35.301924, longitude: -120.663826)
        secondMarker.title = "Scooter"
        secondMarker.map = mapView
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
