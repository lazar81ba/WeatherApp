//
//  ViewController.swift
//  weather_app
//
//  Created by Student on 11.10.2561 BE.
//  Copyright © 2561 BE agh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherState: UITextField!
    @IBOutlet weak var minTemperature: UITextField!
    @IBOutlet weak var maxTemperature: UITextField!
    @IBOutlet weak var wind: UITextField!
    @IBOutlet weak var pressure: UITextField!
    @IBOutlet weak var rain: UITextField!
    @IBOutlet weak var previewButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var weatherApiResponse : [[String : Any]] = []
    var dayIndex = 0
    let format = ".2"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getApiData(urlAdress: "https://www.metaweather.com/api/location/44418/")
    }
    
    func getApiData(urlAdress : String) {
        guard let url = URL(string: urlAdress) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            
            if let dictionary = json as? [String:Any]{
                if let weather_data = dictionary["consolidated_weather"] as? [[String:Any]]{
                    self.weatherApiResponse = weather_data
                    self.updateView()
                    
                }
            }
            
            }.resume()
    }
    
    func initializeCities(urlAdresses : [String]) {
        
    }
    
    
    
    
    func prepareImage(imgName : String) {
        let urlString = "https://www.metaweather.com/static/img/weather/png/64/" + imgName + ".png"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                self.weatherImage.image = UIImage(data : data)
            }
            
            }.resume()
    }
    
    func updateView(){
        DispatchQueue.main.async {
            let dayData = self.weatherApiResponse[self.dayIndex]
            self.date.text = (dayData["applicable_date"] as? String)
            self.weatherState.text = (dayData["weather_state_name"] as? String)
            self.minTemperature.text = (((dayData["min_temp"] as? Double)?.format(f: self.format))?.description ?? "") + " °C"
            self.maxTemperature.text = (((dayData["max_temp"] as? Double)?.format(f: self.format))?.description ?? "") + " °C"
            self.wind.text = (((dayData["wind_speed"] as? Double)?.format(f: self.format))?.description ?? "") + " km/h"

            self.pressure.text = (((dayData["air_pressure"] as? Double)?.format(f: self.format))?.description ?? "") + " hPa"
            self.rain.text = ((dayData["predictability"] as? Int)?.description ?? "") + " %"
            self.prepareImage(imgName: dayData["weather_state_abbr"] as? String ?? "c")
            
            self.updateButtons()
        
        }
        return
    }
    
    func updateButtons() {
        if self.dayIndex >= self.weatherApiResponse.count - 1 {
            self.nextButton.isEnabled = false
            return
        }
        if self.dayIndex <= 0 {
            self.previewButton.isEnabled = false
            return
        }
        
        self.nextButton.isEnabled = true
        self.previewButton.isEnabled = true
        
    }
    
    
    @IBAction func nextDayAction(_ sender: Any) {
        self.dayIndex += 1
        self.updateView()
    
    }
    
    @IBAction func previewDayAction(_ sender: Any) {
        self.dayIndex -= 1
        self.updateView()
    }
}



extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}

