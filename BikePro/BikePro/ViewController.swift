//
//  ViewController.swift
//  BikePro
//
//  Created by Jared Williams on 3/31/16.
//  Copyright © 2016 Jared Williams. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    let locationObject = locationLogic()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(ViewController.updateGui), userInfo: nil, repeats: true)
        mapView.setUserTrackingMode(MKUserTrackingMode.FollowWithHeading, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateGui() {
        if !locationObject.isStationary {
            centerMap()
        }
        if locationObject.hasRunOnce == false {
            centerMap()
            locationObject.hasRunOnce = true
        }
        
        updateSpeed()
        updateDistance()
    }
    
    func centerMap() {
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(locationObject.currentLocation.coordinate, locationObject.span * 2, locationObject.span * 2), animated: true)
    }
    
    func updateSpeed() {
        if locationObject.currentSpeed < 0 {
            self.speedLabel.text = " 0 MPH"
        }
        
        else {
            self.speedLabel.text = String(Int(locationObject.currentSpeed)) + " MPH"
        }
    }
    
    func updateDistance() {
        self.distanceLabel.text = locationObject.formattedDistanceString as String + " Miles"
    }
}

