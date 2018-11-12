//
//  City.swift
//  weather_app
//
//  Created by Bartek on 05/11/2018.
//  Copyright © 2018 agh. All rights reserved.
//

import UIKit

class City {
    var name : String
    var temperature : String
    var weatherState : String
    var woeid : String
    var longitude: Double
    var latitude: Double
    
    init(name: String, temperature : String, weatherState : String, woeid: String, longitude: Double, latitude: Double){
        self.name = name
        self.temperature = temperature
        self.weatherState = weatherState
        self.woeid = woeid
        self.longitude = longitude
        self.latitude = latitude
    }

}
