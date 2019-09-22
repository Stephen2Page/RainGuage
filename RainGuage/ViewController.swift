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


class ViewController: UIViewController {

    let api = "ziMIGvgahTwfkCfNuNddJzhksloolzEj"
    
    @IBOutlet weak var dateInput: UIDatePicker!
    @IBOutlet weak var txtZipCode: UITextField!
    
    @IBOutlet weak var txtRainfall: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        
        let zipCode = txtZipCode.text!
        // need to determine station -- Could also use &locationid=ZIP:44114 but need to validate data is available in that zip code
        // OR use request station with extent and datatype parameters
        // Use Google Maps to get extent lat & long
        
        latLongCoordinates = GeoLocation().AddressLookup(address: zipCode)
        
        let station = "&stationid=GHCND:USW00004853" // Burke Lakefront

        // create HTTP request retrieving data
        // "https://www.ncdc.noaa.gov/cdo-web/api/v2/data?datasetid=GHCND&startdate=2017-08-20&enddate=2017-08-25&stationid=GHCND%3AUSW00004853"

        let dataSetId = "datasetid=GHCND" // Daily Summaries
        let dataTypeId = "&datatypeid=PRCP" // Percipitation (may also want to look at SNOW)
        let units = "&units=standard" // This could be set from a settings screen
        
        // need validatidateion and assembly of dates -- Needs to be date only format 2018-01-16
        let startDate = dateInput.date.toString(dateFormat: "yyyy-MM-dd")
        let endDate = dateInput.date.toString(dateFormat: "yyyy-MM-dd")
        let dateRange = "&startdate=\(startDate)&enddate=\(endDate)"
        
        let parameters = "?" + dataSetId + dataTypeId + dateRange + station + units
        let noaaData = NoaaApi(endpoint: "data").Get(parameters: parameters)
        // Need to validate that we did not get an empty response
        rainfallAmount = noaaData.results != nil ? (noaaData.results?[0].value?.description)! : "0"
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
}

