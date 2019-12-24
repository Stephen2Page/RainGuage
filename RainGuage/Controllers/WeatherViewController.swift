//
//  ViewController.swift
//  RainGuage
//
//  Created by Stephen Page on 8/27/17.
//  Copyright © 2017 Stephen Page. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation


class WeatherViewController: UIViewController {

    let api = "ziMIGvgahTwfkCfNuNddJzhksloolzEj"
    
    @IBOutlet weak var dateInput: UIDatePicker!
    @IBOutlet weak var txtZipCode: UITextField!
    
    @IBOutlet weak var txtRainfall: UILabel!
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // locationManagerStart()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnGetRain(_ sender: Any) {
        
        var rainfallAmount = String() //
        var latLongCoordinates = CLLocationCoordinate2D()

        if isStringEmpty(inputValue: txtZipCode.text!) //== true
        {
            return
        }
        
        let zipCode = txtZipCode.text!  // Need to verify this is a zipcode only
        // need to determine station -- Could also use &locationid=ZIP:44114 but need to validate data is available in that zip code
        // OR use request station with extent and datatype parameters
        // Use Google Maps to get extent lat & long
        
        // checkLocationAuth() // needed for using location service

        GeoLocation().AddressLookup(string: zipCode) { coordinates, error in
            latLongCoordinates = coordinates ?? CLLocationCoordinate2D()
            let offsetCoordinates = GeoLocation().locationWithBearing(bearing: 225, distanceMeters: 1000, origin: latLongCoordinates)
            
            let station = "&stationid=GHCND:USW00004853" // Burke Lakefront
            // create HTTP request to get station
            
            
            
            // create HTTP request retrieving data
            // "https://www.ncdc.noaa.gov/cdo-web/api/v2/data?datasetid=GHCND&startdate=2017-08-20&enddate=2017-08-25&stationid=GHCND%3AUSW00004853"

            let dataSetId = "datasetid=GHCND" // Daily Summaries
            let dataTypeId = "&datatypeid=PRCP" // Percipitation (may also want to look at SNOW)
            let units = "&units=standard" // This could be set from a settings screen
            
            // need validatidateion and assembly of dates -- Needs to be date only format 2018-01-16
            let startDate = self.dateInput.date.toString(dateFormat: "yyyy-MM-dd")
            let endDate = self.dateInput.date.toString(dateFormat: "yyyy-MM-dd")
            let dateRange = "&startdate=\(startDate)&enddate=\(endDate)"
            
            let parameters = "?" + dataSetId + dataTypeId + dateRange + station + units
            let noaaData = NoaaApi(endpoint: "data").Get(parameters: parameters)
            // Need to validate that we did not get an empty response
            rainfallAmount = noaaData.results != nil ? (noaaData.results?[0].value?.description)! : "0"
            self.txtRainfall.text = rainfallAmount + "\""
        }
        

    }

    func isStringEmpty(inputValue:String) -> Bool
    {
        var stringValue = inputValue
 
        // Make sure user did not submit any number of empty spaces
        stringValue = stringValue.trimmingCharacters(in: .whitespaces)
        
        if(stringValue.isEmpty == true)
        {
            return true
        }
        
        return false
    }
    
    private func locationManagerStart(){
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.requestWhenInUseAuthorization()
            locationManager!.delegate = self
        }
        
        locationManager!.startMonitoringSignificantLocationChanges()
    }
    
    private func locationManagerStop(){
        if locationManager != nil {
            locationManager!.stopMonitoringSignificantLocationChanges()
        }
    }
    
    private func checkLocationAuth() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager!.location?.coordinate
            
            if (currentLocation != nil) {
                // set location coordinates (just following an example
            } else {
                // check again
                checkLocationAuth()
            }
        } else {
            locationManager?.requestWhenInUseAuthorization()
            checkLocationAuth()
        }
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func  locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
}

