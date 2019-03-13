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
    @IBOutlet weak var citySegmentedControl: UISegmentedControl!
    
    
    private var locationManager = CLLocationManager()
    private var sharedFromWeather = WeatherForecastService.shared
    private var latitude, longitude: CLLocationDegrees?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sharedFromWeather.getCurrentWeatherConditions(whichLocation: .NewYork) { (success) in
            if success {
                guard let weatherCondtions = self.sharedFromWeather.weatherConditionsNewYork else {
                    return
                }
                self.displayWeatherConditions(weatherConditions: weatherCondtions)
                self.sharedFromWeather.getCurrentWeatherConditions(whichLocation: .Paris) { (successParis) in
                    if successParis {
                        self.initializeLocation()
                        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
                            self.stopAcquiringLocation()
                            self.sharedFromWeather.getCurrentWeatherConditions(whichLocation: .currentPosition, latitude: Double(self.latitude!), longitude: Double(self.longitude!), callback: { (successCurrent) in
                                if successCurrent {}
                            })
                        }
                    }
                }
            }
        }
        
    }
    
    @IBAction func actualize() {
        print("location : \(String(describing: latitude)) \(String(describing: longitude))")
    }
    
    @IBAction func cityChanged() {
        switch citySegmentedControl.selectedSegmentIndex {
            case 0:
                displayWeatherConditions(weatherConditions: sharedFromWeather.weatherConditionsNewYork!)
            case 1:
                displayWeatherConditions(weatherConditions: sharedFromWeather.weatherConditionsParis!)
            case 2:
                displayWeatherConditions(weatherConditions: sharedFromWeather.weatherConditionsCurrentPosition!)
            default:
                break
        }
    }
    
    private func displayWeatherConditions(weatherConditions: dataCurrentWeather) {
        cityName.text = weatherConditions.name
        weatherConditionsLabel.text = weatherConditions.weather[0].description.capitalized
        currentTemperatureLabel.text = "\(weatherConditions.main.temp) °C"
        minTemperatureLabel.text = "\(weatherConditions.main.tempMin) °C"
        maxTemperatureLabel.text = "\(weatherConditions.main.tempMax) °C"
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
