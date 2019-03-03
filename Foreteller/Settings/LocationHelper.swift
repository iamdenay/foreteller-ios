//
//  Repository.swift
//  Foreteller
//
//  Created by Atabay Ziyaden on 1/12/19.
//  Copyright © 2019 IcyFlame Studios. All rights reserved.
//

import Foundation
import CoreLocation

class LocationHelper : NSObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var currentLocation : CLLocationCoordinate2D?
    var completion : ((CLAuthorizationStatus?) -> ())?

    
    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?)
        -> Void ) {
        print("LOCATION CALLED")
        if let lastLocation = self.locationManager.location {
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(lastLocation,
                                            completionHandler: { (placemarks, error) in
                if error == nil {
                    print("LOCATION SUCCESS")
                    let firstLocation = placemarks?[0]
                    completionHandler(firstLocation)
                }
                else {
                    print("LOCATION ERROR OCCURED")
                    completionHandler(nil)
                }
            })
        }
        else {
            completionHandler(nil)
        }
    }
    
    func askPermission(completion: @escaping (CLAuthorizationStatus?) -> ()){
        self.completion = completion
        self.startUpdating()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdating(){
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = manager.location!.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        print("CHANGED")
        self.completion!(status)
    }
}

