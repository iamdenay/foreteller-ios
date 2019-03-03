//
//  Result.swift
//  Foreteller
//
//  Created by Atabay Ziyaden on 1/12/19.
//  Copyright © 2019 IcyFlame Studios. All rights reserved.
//

import Foundation
import ObjectMapper

class Result:Mappable {
    
    var latitude: CLong?
    var longitude: CLong?
    var timezone: String?
    var currently:Forecast?
    var hourly:[Forecast]?
    var daily:[Forecast]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        timezone <- map["timezone"]
        currently <- map["currently"]
        hourly <- map["hourly.data"]
        daily <- map["daily.data"]
    }
}
