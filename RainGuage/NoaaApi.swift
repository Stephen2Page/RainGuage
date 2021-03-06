//
//  NoaaApi.swift
//  RainGuage
//
//  Created by Stephen Page on 9/22/19.
//  Copyright © 2019 Stephen Page. All rights reserved.
//

import Foundation

class NoaaApi {
    let baseUrlString = "https://www.ncdc.noaa.gov/cdo-web/api/v2/"
    let apiToken = "ziMIGvgahTwfkCfNuNddJzhksloolzEj"
    var endpoint = String()

    init(endpoint: String) {
        self.endpoint = endpoint
    }
    
    func Get(parameters: String) -> NoaaData {
        let urlString = baseUrlString + endpoint + parameters
        print(urlString)
        
        var noaaData = NoaaData(metadata: nil, results: nil)
        
        // Generated by Postman
        let headers = [
            "token": apiToken,
            "cache-control": "no-cache",
        ]
        
        let request = NSMutableURLRequest(
            url: NSURL(string: urlString )! as URL,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0
        )
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let semaphore = DispatchSemaphore(value: 0)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            guard let data  = data else { return }
            do {
                // Deserialize JSON
                let decoder = JSONDecoder()
                noaaData = try decoder.decode(NoaaData.self, from: data)
//              print(noaaData.results[0].datatype!)
            } catch let err {
                print("Err", err)
            }
            semaphore.signal()
        })
        dataTask.resume()
        _ = semaphore.wait(wallTimeout: .distantFuture)
        return noaaData
    }
}
