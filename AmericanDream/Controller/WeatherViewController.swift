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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var refreshButton: UIButton!
    
    
    private var locationManager = CLLocationManager()
    private var sharedFromWeather = WeatherForecastService.shared
    private var latitude, longitude: CLLocationDegrees?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundImage()
        requestWeatherNewYork(display: true)
        
    }
    
    private func requestWeatherNewYork(display: Bool) {
        toggleActivityIndicator(shown: true)
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
                self.toggleActivityIndicator(shown: false)
            }
        }
    }
    
    private func requestWeatherParis() {
        sharedFromWeather.getCurrentWeatherConditions(whichLocation: .Paris) { (successParis) in
            if successParis {
                self.requestWeatherCurrentPosition()
            } else {
                self.createAndDisplayAlerts(message: "Erreur de connection réseau, échec de l'obtention de la météo parisienne.")
                self.toggleActivityIndicator(shown: false)
            }
        }
    }
    
    private func requestWeatherCurrentPosition() {
        initializeLocation()
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
            self.stopAcquiringLocation()
            guard let latitudeToUse = self.latitude,let longitudeToUse = self.longitude else {
                self.createAndDisplayAlerts(message: "Erreur lors de l'acquisition de votre position, impossible d'afficher la météo locale. Vérifiez que l'application ait accès à votre position quand cette dernière est active.")
                self.toggleActivityIndicator(shown: false)
                return
            }
            self.sharedFromWeather.getCurrentWeatherConditions(whichLocation: .currentPosition, latitude: Double(latitudeToUse), longitude: Double(longitudeToUse), callback: { (successCurrent) in
                if successCurrent {}
                self.toggleActivityIndicator(shown: false)
            })
        }
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        refreshButton.isHidden = shown
        activityIndicator.isHidden = !shown
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
            guard let weatherConditions = sharedFromWeather.weatherConditionsNewYork else {
                createAndDisplayAlerts(message: "Vérifiez bien que vous soyez bien connecté à internet pour pouvoir obtenir la météo newyorkaise.")
                return
            }
            displayWeatherConditions(weatherConditions: weatherConditions)
        case 1:
            guard let weatherConditions = sharedFromWeather.weatherConditionsParis else {
                createAndDisplayAlerts(message: "Vérifiez bien que vous soyez bien connecté à internet pour pouvoir obtenir la météo parisienne.")
                return
            }
            displayWeatherConditions(weatherConditions: weatherConditions)
        case 2:
            guard let weatherConditions = sharedFromWeather.weatherConditionsCurrentPosition else {
                createAndDisplayAlerts(message: "Vérifiez bien que l'application ait accès à votre position pour avoir la météo locale.")
                citySegmentedControl.selectedSegmentIndex = 0
                displayCorrespondingWeather()
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
        } else {
            createAndDisplayAlerts(message: "Impossible d'obtenir votre position. Vérifiez que l'application ait accès à votre position quand cette dernière est active.")
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
