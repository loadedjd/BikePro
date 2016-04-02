//
//  ViewController.swift
//  BikePro
//
//  Created by Jared Williams on 3/31/16.
//  Copyright © 2016 Jared Williams. All rights reserved.
//

import UIKit
import MapKit
import AVFoundation

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var mapCamera = MKMapCamera()
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    let locationObject = locationLogic()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.showsCompass = false
        
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(ViewController.updateGui), userInfo: nil, repeats: true)
        mapView.setUserTrackingMode(MKUserTrackingMode.FollowWithHeading, animated: true)
        mapView.showsTraffic = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.blueColor()
            renderer.lineWidth = 4
            return renderer

        
        
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
        //updateCamera()
        updatePolyLine()
    }
    
    @IBAction func flashlighButtonPressed(sender: AnyObject) {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do {
           try device.lockForConfiguration()
        }//make sure no other app is using torch
        catch {
              print("uh oh")
        }
        
        if device.hasTorch {
            if device.torchMode == AVCaptureTorchMode.On {
                device.torchMode = AVCaptureTorchMode.Off
            }
            
            else {
                device.torchMode = AVCaptureTorchMode.On
            }
        }
    }
    
    
    @IBAction func centerButtonPressed(sender: AnyObject) {
        centerMap()
    }
    
    
    @IBAction func infoButtonPressed(sender: AnyObject) {
        let alert = UIAlertController(title: "Info", message: "Average Speed: \(self.locationObject.formattedAvgSpeedString) MPH\n Distance Traveled: \(self.locationObject.formattedDistanceString) Miles", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
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
    
    func updateCamera() {
        print(self.locationObject.currentLocationDirection)
        if self.mapView.camera.heading == self.locationObject.currentLocationDirection {
            print("not")
        }
        
        if self.mapView.camera.heading != self.locationObject.currentLocationDirection {
            self.mapCamera = MKMapCamera(lookingAtCenterCoordinate: mapView.region.center, fromDistance: self.locationObject.span * 2, pitch: 0, heading: self.locationObject.currentLocationDirection)
            self.mapView.setCamera(self.mapCamera, animated: true)

        }
    }
    
    func updatePolyLine() {
        mapView.addOverlay(self.locationObject.polyLine)
    }
}

