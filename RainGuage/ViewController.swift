//
//  ViewController.swift
//  RainGuage
//
//  Created by Stephen Page on 8/27/17.
//  Copyright © 2017 Stephen Page. All rights reserved.
//

import UIKit
import Foundation


class ViewController: UIViewController {

    let api = "ziMIGvgahTwfkCfNuNddJzhksloolzEj"
    let baseURL = URL(string: "https://www.ncdc.noaa.gov/cdo-web/api/v2/")
    
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
        
        if isStringEmpty(inputValue: txtZipCode.text!) //== true
        {
            return
        }
        
        let zipCode = txtZipCode.text
        // need to determine station -- Could also use &locationid=ZIP:44114 but need to validate data is available in that zip code
        // OR use request station with extent and datatype parameters
        // Use Google Maps to get extent lat & long
        let station = "&stationid=GHCND:USW00004853" // Burke Lakefront
        
        
        // create HTTP request retrieving data
        // "https://www.ncdc.noaa.gov/cdo-web/api/v2/data?datasetid=GHCND&startdate=2017-08-20&enddate=2017-08-25&stationid=GHCND%3AUSW00004853"
        var urlString = "https://www.ncdc.noaa.gov/cdo-web/api/v2/data"
        var rainfallAmount = String() //
        
        let dataSetId = "?datasetid=GHCND" // Daily Summaries
        let dataTypeId = "&datatypeid=PRCP" // Percipitation (may also want to look at SNOW)
        let units = "&units=standard" // This could be set from a settings screen
        
        // need validatidateion and assembly of dates -- Needs to be date only format 2018-01-16
        let startDate = dateInput.date.toString(dateFormat: "yyyy-MM-dd")
        let endDate = dateInput.date.toString(dateFormat: "yyyy-MM-dd")
        let dateRange = "&startdate=\(startDate)&enddate=\(endDate)"

//        let limit = "&limit=100" // default is 25. Should only get one result
        
        // need to assemble parameters
        let parameters = dataSetId + dataTypeId + dateRange + station + units
        // need to attach parameters to urlString
        urlString = urlString + parameters
        
        // Generated by Postman
        let headers = [
            "token": "ziMIGvgahTwfkCfNuNddJzhksloolzEj",
            "cache-control": "no-cache",
            //"postman-token": "7d18bad9-581a-d845-6be7-bd60e93c8f6e"
        ]
        print(urlString)
        let request = NSMutableURLRequest(
            url: NSURL(string: urlString )! as URL,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0
        )
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            guard let data  = data else { return }
//            let dataAsString = String(data: data, encoding: .utf8)
//            print(dataAsString)
            do {
                // Deserialize JSON
                let decoder = JSONDecoder()
                let noaaData = try decoder.decode(NoaaData.self, from: data)
//                print(noaaData.results[0].datatype!)
                // Need to validate that we did not get an empty response
                rainfallAmount = (noaaData.results[0].value?.description)!
                
            } catch let err {
                print("Err", err)
            }
            
//            if (error != nil) {
//                print(error ?? "Unknown error on httpRequest")
//            } else {
//                let httpResponse = response as? HTTPURLResponse
//                print(httpResponse ?? "ERROR in response to httpResponse")
//            }
            // Render Results
            DispatchQueue.main.async {
                self.txtRainfall.text = rainfallAmount + "\""
                }
        })

        dataTask.resume()
    }
    
    func isStringEmpty(inputValue:String) -> Bool
    {
        var returnValue = false
        var stringValue = inputValue
        
//        if stringValue.isEmpty == true
//        {
//            returnValue = true
//            return returnValue
//        }
        // Make sure user did not submit any number of empty spaces
        stringValue = stringValue.trimmingCharacters(in: .whitespaces)
        
        if(stringValue.isEmpty == true)
        {
            returnValue = true
            return returnValue
            
        }
        return returnValue
    }
}

