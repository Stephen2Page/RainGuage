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
    
    func AddressLookup(address: String) -> CLLocationCoordinate2D {
//        var lat = CLLocationDegrees()
//        var long = CLLocationDegrees()
        var coordinates = CLLocationCoordinate2D()
        let geocoder = CLGeocoder()

        geocoder.geocodeAddressString(address) { (placemark, error) in
            if((error) != nil){
                print(error!)
            }
            if let placemark = placemark?.first {
                coordinates = placemark.location!.coordinate
//              lat = placemark.location!.coordinate.latitude
//              long = placemark.location!.coordinate.longitude
            }
        }
        
        return coordinates
    }
}
