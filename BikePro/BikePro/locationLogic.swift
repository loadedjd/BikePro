//
//  locationLogic.swift
//  BikePro
//
//  Created by Jared Williams on 3/31/16.
//  Copyright © 2016 Jared Williams. All rights reserved.
//

import Foundation
import MapKit

class locationLogic: NSObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    var lastLocation = CLLocation()
    var currentSpeed = Double()
    var span: CLLocationDistance = 1000
    var isStationary = false
    var hasRunOnce = false
    var distanceTraveled = Double()
    var hasFoundLastLocation = false
    var formattedDistanceString = NSString()
    var currentHeading = CLHeading()
    var currentLocationDirection = CLLocationDirection()
    var coordinateArray = [CLLocationCoordinate2D]()
    var speedArray = [Double]()
    var avgSpeed = 0.0
    var speedCount = 0
    var formattedAvgSpeedString = NSString()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        formattedAvgSpeedString = NSString(string: "0") //initiate to 0 at beginning so user doesnt see nan at info press
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations.last!
        self.currentSpeed = locations.last!.speed * 2.2369362920544
        if !(locations.last!.speed * 2.2369362920544 < 1.0) {
            self.speedArray.append(self.currentSpeed)
            self.speedCount += 1
        }
                
        determineIfStationary()
        determineDistance()
        determineAvgSpeed(self.speedArray)
        coordinateArray = [self.lastLocation.coordinate, self.currentLocation.coordinate]
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.currentLocationDirection = newHeading.trueHeading
    }
    
    func determineIfStationary() {
        if self.currentSpeed * 2.2369362920544 < 2 {
            self.isStationary = true
        }
        
        else {
            isStationary = false
        }
    }
    
    func determineDistance() {
        if self.hasFoundLastLocation == false {
            self.lastLocation = self.currentLocation
            self.hasFoundLastLocation = true
            
            self.formattedDistanceString = NSString(format: "%.1f", self.distanceTraveled)
        }
        
        else {
            self.distanceTraveled += self.currentLocation.distanceFromLocation(self.lastLocation) * 0.000621371
            self.lastLocation = self.currentLocation
            self.formattedDistanceString = NSString(format: "%.1f", self.distanceTraveled)
        }
        
    }
    
    func determineAvgSpeed(array: [Double]) -> Double{
        if array.count == 0 { //Keeps From Setting String to Nan from empty speed array
            self.formattedAvgSpeedString = NSString(string: "0.0")
            return 0.0
        }
        var sum = 0.0
        for speed in array {
            sum+=speed
        }
        self.formattedAvgSpeedString = NSString(format: "%.1f", sum/Double(self.speedCount))
        return sum/Double(self.speedCount)
    }
}