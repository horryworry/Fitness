//
//  NewRunViewController.swift
//  Fitness
//
//  Created by Atay Sultangaziev on 8/1/18.
//  Copyright © 2018 Atay Sultangaziev. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class NewRunViewController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    private var run: Run!
    
    private let locationManager = LocationManager.shared
    private var seconds = 0
    private var timer: Timer?
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var locationList: [CLLocation] = []
    
    private func polyLine() -> MKPolyline {
        
        if locationList.isEmpty {
            print("locationList is empty")
            return MKPolyline()
        }
        
        let coords: [CLLocationCoordinate2D] = locationList.map { location in
            return CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
        
        
        return MKPolyline(coordinates: coords, count: coords.count)
    }
    
    private func loadMap() {
        mapView.delegate = self
        guard
            locationList.count > 0,
            let region = mapRegion()
            else {
                return
        }
        
        mapView.setRegion(region, animated: true)
        mapView.add(polyLine())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    @IBAction func startButtontapped(_ sender: UIButton) {
        startRun()
    }
    
    @IBAction func stopButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Your run is saved",
                                                message: "Thank me later",
                                                preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
            _ = self.navigationController?.popToRootViewController(animated: true)
        })
        present(alertController, animated: true)
        stopRun()
    }
    
    private func startRun() {
        startButton.isHidden = true
        stopButton.isHidden = false
        
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
        updateDisplay()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.eachSecond()
        }
        startLocationUpdates()
    }
    
    private func stopRun() {
        locationManager.stopUpdatingLocation()
        timer?.invalidate()
        saveRun()
    }
    
    private func saveRun() {
        let newRun = Run(context: CoreDataHelper.context)
        newRun.distance = distance.value
        newRun.duration = Int16(seconds)
        newRun.timestamp = Date()
        
        for location in locationList {
            let locationObject = Location(context: CoreDataHelper.context)
            locationObject.timestamp = location.timestamp
            locationObject.latitude = location.coordinate.latitude
            locationObject.longitude = location.coordinate.longitude
            newRun.addToLocations(locationObject)
        }
        
        CoreDataHelper.saveContext()
        
        run = newRun
    }
    
    private func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
    }
    
    func eachSecond() {
        seconds += 1
        updateDisplay()
    }
    
    private func updateDisplay() {
        let formattedDistance = FormatDisplay.distance(distance)
        let formattedTime = FormatDisplay.time(seconds)
        
        distanceLabel.text = "Distance:  \(formattedDistance)"
        timeLabel.text = "Time:  \(formattedTime)"
    }
    
    private func mapRegion() -> MKCoordinateRegion? {
        guard locationList.count > 0
            else {
                print("mapRegion returns nil")
                return nil
                
        }
        
        let latitudes = locationList.map { location -> Double in
            return location.coordinate.latitude
        }
        
        let longitudes = locationList.map { location -> Double in
            return location.coordinate.longitude
        }
        
        let maxLat = latitudes.max()!
        let minLat = latitudes.min()!
        let maxLong = longitudes.max()!
        let minLong = longitudes.min()!
        
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                            longitude: (minLong + maxLong) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.3,
                                    longitudeDelta: (maxLong - minLong) * 1.3)
        return MKCoordinateRegion(center: center, span: span)
    }
    
    
    
}
extension NewRunViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
            
            if let lastLocation = locationList.last {
                let delta = newLocation.distance(from: lastLocation)
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
            }
            
            locationList.append(newLocation)
        }
        loadMap()
    }
}

extension NewRunViewController: MKMapViewDelegate {
    internal func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .black
        renderer.lineWidth = 3
        return renderer
    }
}
