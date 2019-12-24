//
//  GeoLocation.swift
//  RainGuage
//
//  Created by Stephen Page on 9/22/19.
//  Copyright © 2019 Stephen Page. All rights reserved.
//

import Foundation
import CoreLocation

class GeoLocation {
    let geocoder = CLGeocoder()
    
    /// Geocode string
    ///
    /// - parameter string: The string to geocode.
    /// - parameter completionHandler: The closure that is called asynchronously (i.e. later) when the geocoding is done.
    func AddressLookup(string: String, completionHandler: @escaping (CLLocationCoordinate2D?, Error?) -> ()) {
        
        geocoder.geocodeAddressString(string) { placemarks, error in
            if error != nil {
                print(error!)
            }

            if let placemark = placemarks?.first {
                completionHandler(placemark.location!.coordinate, error)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    // From https://stackoverflow.com/a/31127466
    // bearing refers to the direction that you want to advance, in degrees, so for north: bearing = 0, for east: bearing = 90, for southwest: bearing = 225,
    func locationWithBearing(bearing:Double, distanceMeters:Double, origin:CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let distRadians = distanceMeters / (6372797.6) // earth radius in meters

        let rbearing = bearing * Double.pi / 180.0 // converting to radians

        let lat1 = origin.latitude * Double.pi / 180
        let lon1 = origin.longitude * Double.pi / 180

        let lat2 = asin(sin(lat1) * cos(distRadians) + cos(lat1) * sin(distRadians) * cos(rbearing))
        let lon2 = lon1 + atan2(sin(rbearing) * sin(distRadians) * cos(lat1), cos(distRadians) - sin(lat1) * sin(lat2))

        return CLLocationCoordinate2D(latitude: lat2 * 180 / Double.pi, longitude: lon2 * 180 / Double.pi)
    }
}
