//
//  Repository.swift
//  Foreteller
//
//  Created by Atabay Ziyaden on 1/12/19.
//  Copyright © 2019 IcyFlame Studios. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class Repository {
    
    fileprivate let url = "\(Globals.authUrl)/\(Globals.key)"
    
    func getPopular(lat:Double, lon:Double,completion: @escaping (Result?, Error?) -> ()){
        let resUrl = "\(url)/\(lat),\(lon)"
        
        let parameters: Parameters = [
            "units": "si"
        ]
        
        Alamofire.request(resUrl, parameters: parameters).responseObject { (response: DataResponse<Result>) in
            print("Request: \(String(describing: response.request!))")
            print("Response: \(String(describing: response.response!))")
            print("Error: \(String(describing: response.error))")
            print("Result: \(response.result)")
            
            if let res = response.result.value {
                completion(res, response.error)
            } else {
                completion(nil, response.error)
            }
            
        }
    }
}
