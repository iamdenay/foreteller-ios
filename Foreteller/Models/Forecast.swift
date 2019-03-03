

import Foundation
import ObjectMapper

class Forecast : Mappable {
    var time:Double?
    var summary:String?
    var icon:String?
    var temperature:Int?
    var temperatureMin:Int?
    var temperatureMax:Int?
    var humidity:Double?
    var pressure:Double?
    var visibility:Double?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        time <- map["time"]
        summary <- map["summary"]
        icon <- map["icon"]
        temperature <- map["temperature"]
        temperatureMin <- map["temperatureMin"]
        temperatureMax <- map["temperatureMax"]
        humidity <- map["humidity"]
        pressure <- map["pressure"]
        visibility <- map["visibility"]
    }
}
