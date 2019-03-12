//
//  WeatherViewController.swift
//  AmericanDream
//
//  Created by Alex on 12/03/2019.
//  Copyright © 2019 Alexandre Holet. All rights reserved.
//

import UIKit
import MapKit

class WeatherViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherConditionsLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    private var locationManager = CLLocationManager()
    private var sharedFromWeather = WeatherForecastService.shared
    private var latitude, longitude: CLLocationDegrees?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sharedFromWeather.getCurrentWeatherConditions { (success) in
            if success {
                guard let weatherCondtions = self.sharedFromWeather.weatherConditions else {
                    return
                }
                self.cityName.text = weatherCondtions.name
                self.weatherConditionsLabel.text = weatherCondtions.weather[0].description.capitalized
                self.currentTemperatureLabel.text = "\(weatherCondtions.main.temp) °C"
                self.minTemperatureLabel.text = "\(weatherCondtions.main.tempMin) °C"
                self.maxTemperatureLabel.text = "\(weatherCondtions.main.tempMax) °C"
            }
        }
        initializeLocation()
        print("location : \(latitude) \(longitude)")
        stopAcquiringLocation()
        // Do any additional setup after loading the view.
    }
}

extension WeatherViewController {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        latitude = locValue.latitude
        longitude = locValue.longitude
    }
    
    private func initializeLocation() {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    private func stopAcquiringLocation() {
        locationManager.stopUpdatingLocation()
    }
}
