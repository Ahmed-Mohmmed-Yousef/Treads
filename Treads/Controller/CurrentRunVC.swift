//
//  CurrentRunVC.swift
//  Treads
//
//  Created by Ahmed on 7/26/19.
//  Copyright © 2019 Ahmed, ORG. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class CurrentRunVC: LocationVC {

    @IBOutlet weak var swipBGImage: UIImageView!
    @IBOutlet weak var sliderImgView: UIImageView!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var paceLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var pauseBtn: UIButton!
    
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var timer = Timer()
    var coordinateLocations = List<Location>()
    var runDistance = 0.0
    var pace = 0
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let swip = UIPanGestureRecognizer(target: self, action: #selector(endReunSwiped(sinder:)))
        sliderImgView.addGestureRecognizer(swip)
        sliderImgView.isUserInteractionEnabled = true
        swip.delegate = self as? UIGestureRecognizerDelegate
    }
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
        manager?.distanceFilter = 10
        startRun()
    }
    
    func startRun(){
        manager?.startUpdatingLocation()
        startTimer()
        pauseBtn.setImage(#imageLiteral(resourceName: "pauseButton"), for: .normal)
    }
    
    func endRun(){
        manager?.stopUpdatingLocation()
        Run.addRunToRealm(pace: pace, distance: runDistance, duration: counter, locations: coordinateLocations)
    }
    
    func pauseRun(){
        startLocation = nil
        lastLocation = nil
        timer.invalidate()
        manager?.stopUpdatingLocation()
        pauseBtn.setImage(#imageLiteral(resourceName: "resumeButton"), for: .normal)
    }
    func startTimer(){
        durationLbl.text = counter.formatTimeDurationToString()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounter(){
        counter += 1
        durationLbl.text =  counter.formatTimeDurationToString()
    }
    
    func calcPace(time seconds: Int, miles: Double) -> String {
        pace = Int(Double(seconds) / miles)
        return pace.formatTimeDurationToString()
    }
    
    @IBAction func puaseBtnPressed(_ sender: UIButton) {
        if timer.isValid{
            pauseRun()
        } else {
            startRun()
        }
    }
    
    @objc func endReunSwiped(sinder: UIPanGestureRecognizer){
        let minAdjust: CGFloat = 80
        let maxAdjust: CGFloat = 130
        if sliderImgView == sinder.view{
            if sinder.state == .began || sinder.state == .changed{
                let traslation = sinder.translation(in: self.view)
                if sliderImgView.center.x >= (swipBGImage.center.x - minAdjust) && sliderImgView.center.x <= (swipBGImage.center.x + maxAdjust){
                    sliderImgView.center = CGPoint(x: sliderImgView.center.x + traslation.x, y: sliderImgView.center.y)
                } else if sliderImgView.center.x >= (swipBGImage.center.x + maxAdjust){
                    sliderImgView.center.x = swipBGImage.center.x + maxAdjust
                    // End Run Code here
                    endRun()
                    dismiss(animated: true, completion: nil)
                } else {
                    sliderImgView.center.x = swipBGImage.center.x - minAdjust
                }
                
                sinder.setTranslation(CGPoint.zero, in: self.view)
            } else if  sinder.state == .ended {
                UIView.animate(withDuration: 0.1) { [weak self] in
                    guard let self = self else { return }
                    self.sliderImgView.center.x = self.swipBGImage.center.x - minAdjust
                }
            }
        }
    }
}

extension CurrentRunVC: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            checkLocationAuthStatus()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if startLocation == nil{
            startLocation = locations.first
        } else if let location = locations.last{
            runDistance += location.distance(from: startLocation)
            let newLocation = Location(latitude: Double(lastLocation.coordinate.latitude), logitude: Double(lastLocation.coordinate.longitude))
            coordinateLocations.insert(newLocation, at: 0)
            distanceLbl.text = "\(runDistance.metersToMilies(places: 2))"
            if counter > 0 && runDistance > 0{
                paceLbl.text = calcPace(time: counter, miles: runDistance.metersToMilies(places: 2))
            }
        }
        lastLocation = locations.last
    }
}
