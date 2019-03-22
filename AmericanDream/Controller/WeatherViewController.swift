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
        requestWeatherNewYork(display: true)
        
    }
    
    private func requestWeatherNewYork(display: Bool) {
        sharedFromWeather.getCurrentWeatherConditions(whichLocation: .NewYork) { (success) in
            if success {
                guard let weatherCondtions = self.sharedFromWeather.weatherConditionsNewYork else {
                    self.createAndDisplayAlerts(message: "Erreur serveur, le serveur a été joint mais a envoyé une réponse incorrecte.")
                    return
                }
                if display {
                    self.displayWeatherConditions(weatherConditions: weatherCondtions)
                }
                self.requestWeatherParis()
            } else {
                self.createAndDisplayAlerts(message: "Erreur de connection réseau, échec de l'obtention de la météo NewYorkaise.")
            }
        }
    }
    
    private func requestWeatherParis() {
        sharedFromWeather.getCurrentWeatherConditions(whichLocation: .Paris) { (successParis) in
            if successParis {
                self.requestWeatherCurrentPosition()
            } else {
                self.createAndDisplayAlerts(message: "Erreur de connection réseau, échec de l'obtention de la météo parisienne.")
            }
        }
    }
    
    private func requestWeatherCurrentPosition() {
        initializeLocation()
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
            self.stopAcquiringLocation()
            guard let latitudeToUse = self.latitude,let longitudeToUse = self.longitude else {
                self.createAndDisplayAlerts(message: "Erreur lors de l'acquisition de votre position, impossible d'afficher la météo locale.")
                return
            }
            self.sharedFromWeather.getCurrentWeatherConditions(whichLocation: .currentPosition, latitude: Double(latitudeToUse), longitude: Double(longitudeToUse), callback: { (successCurrent) in
                if successCurrent {}
            })
        }
    }
    
    @IBAction func actualize() {
        requestWeatherNewYork(display: false)
        displayCorrespondingWeather()
    }
    
    @IBAction func cityChanged() {
        displayCorrespondingWeather()
    }
    
    private func displayCorrespondingWeather() {
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

extension WeatherViewController: FunctionsForViewControllers {
    
    private func setBackgroundImage() {
        let backgroundImage = getBackgroundImage(imageName: "weatherBackground")
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    private func createAndDisplayAlerts(message: String){
        let alertVC = createAlert(message: message)
        present(alertVC, animated: true, completion: nil)
    }
}
