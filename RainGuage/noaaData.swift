//
//  noaaData.swift
//  RainGuage
//
//  Created by Stephen Page on 4/1/18.
//  Copyright © 2018 Stephen Page. All rights reserved.
//

import Foundation

struct NoaaData: Codable {
    let metadata: Metadata
    let results: [Result]
}

struct  Metadata: Codable {
    let resultSet: ResultSet?
}

struct ResultSet: Codable {
    let offset: Int?
    let count: Int?
    let limit: Int?
}

//struct Results: Codable {
//    let result = [Result]()
//}

struct Result: Codable {
    let date: String? // ISO format
    let datatype: String?
    let station: String?
    let attributes: String? // csv
    let value: Int?
}


// sample
/*
{
    "metadata": {
        "resultset": {
            "offset": 1,
            "count": 9,
            "limit": 100
        }
    },
    "results": [
        {
        "date": "2018-03-01T00:00:00",
        "datatype": "AWND",
        "station": "GHCND:USW00004853",
        "attributes": ",,W,",
        "value": 88
        },
        {
        "date": "2018-03-01T00:00:00",
        "datatype": "PRCP",
        "station": "GHCND:USW00004853",
        "attributes": ",,W,",
        "value": 348
        }
    ]
}
 */
