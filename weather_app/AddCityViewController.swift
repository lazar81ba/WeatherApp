//
//  AddCityViewController.swift
//  weather_app
//
//  Created by Bartek on 06/11/2018.
//  Copyright © 2018 agh. All rights reserved.
//

import UIKit
import os.log

class AddCityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var search: UIButton!
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var cities = [AddCity]()
    var readyCity : AddCity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        guard let query = textField.text else {
            return
        }
        let formattedQuery = query.replacingOccurrences(of: " ", with: "%20")
        guard let url = URL(string: "https://www.metaweather.com/api/location/search/?query=\(formattedQuery)") else {
            assertionFailure("URL init failed")
            return
        }
        cities.removeAll()
        searchCities(url: url)
    }
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    private func searchCities(url: URL){
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let data = data else { return }
            
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            
            if let dictionary = json as? [[String:Any]]{
                for word in dictionary{
                    if let name = word["title"] as? String{
                        if let woeid = word["woeid"] as? Int{
                            self.cities += [AddCity(cityName: name, woeid: String(woeid))]
                            
                        }
                    }
                }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                
            }
            
            }.resume()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "AddCityTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AddCityTableViewCell  else {
            fatalError("The dequeued cell is not an instance of AddCityTableViewCell.")
        }
        
        let city  = self.cities[indexPath.row]
        
        cell.cityName.text = city.cityName
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        readyCity = cities[indexPath.row]
        self.performSegue(withIdentifier: "UnwindToCityList", sender: self)
    }
    

}


