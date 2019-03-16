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
        setBackgroundImage()
//        R
//        E
//        F
//        A
//        C
//        T
//        O
// créer bouton rafraichir
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
                            guard let latitudeToUse = self.latitude,let longitudeToUse = self.longitude else {
                                //alert here
                                return
                            }
                            self.sharedFromWeather.getCurrentWeatherConditions(whichLocation: .currentPosition, latitude: Double(latitudeToUse), longitude: Double(longitudeToUse), callback: { (successCurrent) in
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
                guard let weatherConditions = sharedFromWeather.weatherConditionsCurrentPosition else {
                    //display alert
                    return
                }
                displayWeatherConditions(weatherConditions: weatherConditions)
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
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    private func stopAcquiringLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.stopUpdatingLocation()
        }
    }
}

extension WeatherViewController: BackgroundImage {
    
    private func setBackgroundImage() {
        let backgroundImage = getBackgroundImage(imageName: "weatherBackground")
        self.view.insertSubview(backgroundImage, at: 0)
    }
}
