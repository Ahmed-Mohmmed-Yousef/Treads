//
//  FirstViewController.swift
//  Treads
//
//  Created by Ahmed on 7/25/19.
//  Copyright © 2019 Ahmed, ORG. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import RealmSwift

class BeginRunVC: LocationVC {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAuthStatus()
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        manager?.delegate = self
        manager?.startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupMapView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        manager?.stopUpdatingLocation()
    }
    
    func setupMapView(){
        if let overly = addLastLineToMap(){
            if mapView.overlays.count > 0 {
                mapView.removeOverlays(mapView.overlays)
            }
            mapView.addOverlay(overly)
        } else{
            centerMapOnUserLocation()
        }
        
    }
    
    func addLastLineToMap() -> MKPolyline? {
        guard let lastRun = Run.getAllRuns()?.first else { return nil }
        var coordinare = [CLLocationCoordinate2D]()
        for location in lastRun.locations{
            coordinare.append(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.logitude))
        }
        
        mapView.userTrackingMode = .none
        mapView.setRegion(centerMapOnPrevRoute(locations: lastRun.locations), animated: true)
        
        return MKPolyline(coordinates: coordinare, count: lastRun.locations.count)
    }
    
    func centerMapOnUserLocation(){
        mapView.userTrackingMode = .follow
        let coordinate = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(coordinate, animated: true)
    }
    
    func centerMapOnPrevRoute(locations: List<Location>) -> MKCoordinateRegion{
        guard let initailLoc = locations.first else { return MKCoordinateRegion() }
        var minLat = initailLoc.latitude
        var minLng = initailLoc.logitude
        var maxLat = minLat
        var maxLng = minLng
        
        for location in locations{
            minLat = min(minLat, location.latitude)
            minLng = min(minLng, location.logitude)
            maxLat = max(maxLat, location.latitude)
            maxLng = max(maxLng, location.logitude)
        }
        
        return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLng + maxLng) / 2), span: MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.4, longitudeDelta: (maxLng - minLng ) * 1.4))
    }
 
    @IBAction func locatinCenterBtnPressed(_ sender: UIButton) {
        centerMapOnUserLocation()
    }
    
}
extension BeginRunVC: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            checkLocationAuthStatus()
            mapView.showsUserLocation = true
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polyline = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        renderer.lineWidth = 4
        return renderer
    }
    
}
