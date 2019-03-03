



import Foundation
import UIKit
import CoreLocation

struct Globals {
    static var authUrl = "https://api.darksky.net/forecast"
    static var key = "7425ef4eefc95db29d111899b4251c53"
    static var defaults: UserDefaults {
        get {
            return UserDefaults(suiteName: "cities")!
        }
    }
    static var imageByWeather : [String:UIImage] = [
        "clear-day":#imageLiteral(resourceName: "sun"),
        "clear-night":#imageLiteral(resourceName: "sun"),
        "rain":#imageLiteral(resourceName: "drops"),
        "snow":#imageLiteral(resourceName: "snowflake"),
        "wind":#imageLiteral(resourceName: "kite"),
        "sleet":#imageLiteral(resourceName: "snowflake"),
        "fog":#imageLiteral(resourceName: "kite"),
        "cloudy":#imageLiteral(resourceName: "cloudy"),
        "partly-cloudy-day":#imageLiteral(resourceName: "cloudy"),
        "partly-cloudy-night":#imageLiteral(resourceName: "cloudy")
    ]
    
    static var colorsSunny = [
        UIColor(red: 0.94, green: 0.63, blue: 0.63, alpha: 1).cgColor,
        UIColor(red: 0.94, green: 0.66, blue: 0.24, alpha: 1).cgColor
    ]
    
    static var colorsRainy = [
        UIColor(red: 0.59, green: 0.69, blue: 0.97, alpha: 1).cgColor,
        UIColor(red: 0.08, green: 0.19, blue: 0.52, alpha: 1).cgColor
    ]
    
    static var colorsSnowy = [
        UIColor(red: 0.5, green: 0.86, blue: 0.95, alpha: 1).cgColor,
        UIColor(red: 0.22, green: 0.53, blue: 0.93, alpha: 1).cgColor
    ]
    
    static var colorsWindy = [
        UIColor(red: 0.74, green: 0.77, blue: 0.95, alpha: 1).cgColor,
        UIColor(red: 0.6, green: 0.4, blue: 0.76, alpha: 1).cgColor
    ]
    
    static var colorsCloudyPartly = [
        UIColor(red: 0.51, green: 0.87, blue: 0.97, alpha: 1).cgColor,
        UIColor(red: 0.07, green: 0.57, blue: 0.83, alpha: 1).cgColor
    ]
    
    static var colorsCloudyHeavy = [
        UIColor(red: 0.74, green: 0.77, blue: 0.95, alpha: 1).cgColor,
        UIColor(red: 0.6, green: 0.4, blue: 0.76, alpha: 1).cgColor
    ]
    
    static var colorsByWeather : [String:[CGColor]] = [
        "clear-day":colorsSunny,
        "clear-night":colorsSunny,
        "rain":colorsRainy,
        "snow":colorsSnowy,
        "wind":colorsWindy,
        "sleet":colorsSnowy,
        "fog":colorsWindy,
        "cloudy":colorsCloudyHeavy,
        "partly-cloudy-day":colorsCloudyPartly,
        "partly-cloudy-night":colorsCloudyPartly
    ]
    
    
    
    static func getCities() -> [String]? {
        return defaults.object(forKey: "cities") as? [String]
    }

}
