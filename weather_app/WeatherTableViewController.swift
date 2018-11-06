//
//  WeatherTableViewController.swift
//  weather_app
//
//  Created by Bartek on 05/11/2018.
//  Copyright © 2018 agh. All rights reserved.
//

import UIKit

class WeatherTableViewController: UITableViewController {

    var cities = [City]()
    let format = ".2"
    var city : City?
    
    
    public func loadCities(){
        loadCity(woeid: "44418",name: "Londyn")
        loadCity(woeid: "523920",name: "Warszawa")
        loadCity(woeid: "638242",name: "Berlin")

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ViewControllerSegue") {
            let vc = segue.destination as! ViewController
            vc.city = city
        }
    }

    
    @IBAction func unwindToCityList(sender: UIStoryboardSegue) {
        if let source = sender.source as? AddCityViewController, let sourceCity = source.readyCity {
            loadCity(woeid: sourceCity.woeid, name: sourceCity.cityName)
            tableView.reloadData()
        }
    }
    
    public func loadCity(woeid : String, name: String) {
        
        guard let url = URL(string: "https://www.metaweather.com/api/location/" + woeid + "/") else { return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
                guard let data = data else { return }
                
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                
                if let dictionary = json as? [String:Any]{
                    if let weather_data = dictionary["consolidated_weather"] as? [[String:Any]]{
                        var dayData = weather_data[0]
                        var temp = (((dayData["min_temp"] as? Double)?.format(f: self.format))?.description ?? "") + " °C/"
                        temp += (((dayData["max_temp"] as? Double)?.format(f: self.format))?.description ?? "") + " °C"
                        let state = dayData["weather_state_abbr"] as? String ?? "c"
                        let city = City(name: name, temperature: temp, weatherState: state, woeid : woeid)
                        self.cities += [city]
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }

                }
            }
            
            }.resume()
        
    }
    
    private func prepareImage(imgName : String, cell : CityTableViewCell) {
        let urlString = "https://www.metaweather.com/static/img/weather/png/64/" + imgName + ".png"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                cell.photoImageView.image = UIImage(data : data)
            }
            
            }.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadCities()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CityTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CityTableViewCell  else {
            fatalError("The dequeued cell is not an instance of CityTableViewCell.")
        }

            
            let city  = self.cities[indexPath.row]
            
            cell.cityName.text = city.name
            cell.temperature.text = city.temperature
            self.prepareImage(imgName: city.weatherState, cell: cell)
        
        
        return cell
    }

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        city = cities[indexPath.row]
        self.performSegue(withIdentifier: "ViewControllerSegue", sender: self)
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
