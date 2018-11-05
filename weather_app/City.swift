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
    
    init(name: String, temperature : String, weatherState : String){
        self.name = name
        self.temperature = temperature
        self.weatherState = weatherState
    }

}
