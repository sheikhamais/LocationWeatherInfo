//
//  Climate.swift
//  Task 5
//
//  Created by Amais Sheikh on 05/11/2020.
//  Copyright © 2020 AmaisSheikh. All rights reserved.
//

import Foundation
import SwiftyJSON

class Climate
{
    var cityName: String
    var temperatureMin: Double
    var temperatureMax: Double
    var humidity: Double
    
    init(json: JSON)
    {
        let cityName = json["name"].string
        var minTemp = json["main"]["temp_min"].double
        var maxTemp = json["main"]["temp_max"].double
        let humidity = json["main"]["humidity"].double
        
        if minTemp != nil, maxTemp != nil
        {
            minTemp = Double(Int((minTemp! - 273.15) * 10)) / 10.0
            maxTemp = Double(Int((maxTemp! - 273.15) * 10)) / 10.0
        }
        
        self.cityName = cityName ?? ""
        self.temperatureMin = minTemp ?? 0
        self.temperatureMax = maxTemp ?? 0
        self.humidity = humidity ?? 0
    }
}
