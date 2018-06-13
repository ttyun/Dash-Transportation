//
//  TrackRideVC.swift
//  Dash Transportation
//
//  Created by Jong Wan Kim on 6/12/18.
//  Copyright © 2018 Dash Transportation. All rights reserved.
//

import UIKit

class TrackRideVC: UIViewController {
    
    var seconds = 0.0;
    var timer = Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    
    @IBOutlet weak var rideTimer: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        runTimer()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func finishRide(_ sender: Any) {
        
        // Stops the timer
        timer.invalidate()
        
        
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds += 1
        rideTimer.text = "\(seconds)"
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "payment" {
            let paymentVC : PaymentVC = segue.destination as! PaymentVC
            print("GOT IN HERE \(seconds)")
            paymentVC.totalTimeInSec = seconds
        }
        
    }
    

}
