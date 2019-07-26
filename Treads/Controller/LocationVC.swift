//
//  LocationVC.swift
//  Treads
//
//  Created by Ahmed on 7/25/19.
//  Copyright © 2019 Ahmed, ORG. All rights reserved.
//

import UIKit
import MapKit
//import CoreLocation

class LocationVC: UIViewController, MKMapViewDelegate {
    
    var manager: CLLocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CLLocationManager()
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        manager?.activityType = .fitness
    }
    
    func checkLocationAuthStatus(){
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse{
            manager?.requestWhenInUseAuthorization()
        }
    }
    

}
