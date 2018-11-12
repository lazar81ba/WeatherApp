//
//  MapViewController.swift
//  weather_app
//
//  Created by Student on 08.11.2018.
//  Copyright © 2018 agh. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet var map: MKMapView!
    let regionRadius: CLLocationDistance = 10000
    var city :City?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        if let currentCity = city{
            initialLocation = CLLocation(latitude: currentCity.latitude, longitude: currentCity.longitude)
        }
        centerMapOnLocation(location: initialLocation)
        // Do any additional setup after loading the view.
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
