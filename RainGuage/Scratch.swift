//
//  Scratch.swift
//  RainGuage
//
//  Created by Stephen Page on 9/3/17.
//  Copyright © 2017 Stephen Page. All rights reserved.
//

import Foundation


// HTTP GET alternate
/*
    let urlString = "http://jsonplaceholder.typicode.com/users/1"
    // need to assemble parameters
    // need to attach parameters to urlString
    guard let requestUrl = URL(string:urlString) else { return }
    var request = URLRequest(url:requestUrl)
    // need to attack token (api license)
    // Or it could be a single Authorization Token value
    //request.addValue("Token token=884288bae150b9f2f68d8dc3a932071d", forHTTPHeaderField: "Authorization")
    request.addValue("token=ziMIGvgahTwfkCfNuNddJzhksloolzEj", forHTTPHeaderField: "Authorization")

    let task = URLSession.shared.dataTask(with: request) {
        (data, response, error) in
        if error == nil,let usableData = data {
            print(usableData) //JSONSerialization
        }
    }
    task.resume()
 */
