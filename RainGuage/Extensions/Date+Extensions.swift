//
//  Date+Extensions.swift
//  RainGuage
//
//  Created by Stephen Page on 3/31/18.
//  Copyright © 2018 Stephen Page. All rights reserved.
//

import Foundation

// Convert date to string based on provided format 
extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
