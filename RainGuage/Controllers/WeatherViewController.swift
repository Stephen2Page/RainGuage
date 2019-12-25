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
    
    @IBOutlet weak var dateInput: UIDatePicker!
    @IBOutlet weak var txtZipCode: UITextField!
    
    @IBOutlet weak var txtRainfall: UILabel!
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocationCoordinate2D!
    var offsetDistance: Double = 20000 // in meters
    
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
        
        var latLongCoordinates = CLLocationCoordinate2D()

        if isStringEmpty(inputValue: txtZipCode.text!) //== true
        {
            return
        }
        
        let zipCode = txtZipCode.text!  // Need to verify this is a zipcode only

        // checkLocationAuth() // needed for using location service

        GeoLocation().AddressLookup(string: zipCode) { coordinates, error in
            latLongCoordinates = coordinates ?? CLLocationCoordinate2D()

            // Confirm valid coordinates
            let stationId = self.getStation(origin: latLongCoordinates)
            self.getRainfall(stationid: stationId)
            
        }
    }

    
    func getStation(origin: CLLocationCoordinate2D) -> String {
        // create HTTP request for stations
        // "https://www.ncdc.noaa.gov/cdo-web/api/v2/stations/?datasetid=GHCND&sortfield=datacoverage&sortorder=desc&extent=41.3815552,-81.9000105,41.5815552,-81.7000105"
        
        
        // create HTTP request to get station
        // need to determine station -- Could also use &locationid=ZIP:44114 but need to validate data is available in that zip code
        // OR use request station with extent and datatype parameters
        let dataSetId = "datasetid=GHCND" // Daily Summaries
        let dataTypeId = "&datatypeid=PRCP" // Percipitation (may also want to look at SNOW)
        let sortfield = "&sortfield=datacoverage"
        let sortorder = "&sortorder=desc"
        let startDate = "&startdate=\(self.dateInput.date.toString(dateFormat: "yyyy-MM-dd"))"

        let swBound: CLLocationCoordinate2D = GeoLocation().locationWithBearing(bearing: 225, distanceMeters: self.offsetDistance, origin: origin)
        let neBound: CLLocationCoordinate2D = GeoLocation().locationWithBearing(bearing: 45, distanceMeters: self.offsetDistance, origin: origin)
        let extent: String = "&extent=\(swBound.latitude),\(swBound.longitude),\(neBound.latitude),\(neBound.longitude)"
        
        // Probably want to include requested date -7 as the startdate parameter
        let parameters: String = "?" + dataSetId + dataTypeId + startDate + sortfield + sortorder + extent
        
        let noaaStations = NoaaApi(endpoint: "stations").Get(parameters: parameters)

        // Need a better way of choosing the station. Currently sorting on datacoverage
        // var stationId = "GHCND:USW00004853" // Burke Lakefront
        let stationId = noaaStations.results != nil ? (noaaStations.results?[0].id)! : ""
        return stationId
    }
    
    
    func getRainfall(stationid: String) {
        // create HTTP request retrieving data
        // "https://www.ncdc.noaa.gov/cdo-web/api/v2/data?datasetid=GHCND&startdate=2017-08-20&enddate=2017-08-25&stationid=GHCND%3AUSW00004853"
        var rainfallAmount = String() //

        let dataSetId = "datasetid=GHCND" // Daily Summaries
        let dataTypeId = "&datatypeid=PRCP" // Percipitation (may also want to look at SNOW)
        let units = "&units=standard" // This could be set from a settings screen
        let station = "&stationid=\(stationid)"

        // need validatidateion and assembly of dates -- Needs to be date only format 2018-01-16
        let startDate = self.dateInput.date.toString(dateFormat: "yyyy-MM-dd")
        let endDate = self.dateInput.date.toString(dateFormat: "yyyy-MM-dd")
        let dateRange = "&startdate=\(startDate)&enddate=\(endDate)"

        let parameters = "?" + dataSetId + dataTypeId + dateRange + station + units
        let noaaData = NoaaApi(endpoint: "data").Get(parameters: parameters)
        // Need to validate that we did not get an empty response
        rainfallAmount = noaaData.results != nil ? (noaaData.results?[0].value?.description)! : "0"
        // Truncate to two decimal places
        self.txtRainfall.text = rainfallAmount + "\""
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

