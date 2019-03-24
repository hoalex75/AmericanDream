//
//  WeatherForecastService.swift
//  AmericanDream
//
//  Created by Alex on 12/03/2019.
//  Copyright © 2019 Alexandre Holet. All rights reserved.
//

import Foundation

class WeatherForecastService {
    static var shared = WeatherForecastService()
    private static var newYorkId = "id=5128581"
    private static var parisId = "id=2988507"

    private init() {}
    private var task: URLSessionDataTask?
    var weatherConditionsNewYork: dataCurrentWeather?
    var weatherConditionsParis: dataCurrentWeather?
    var weatherConditionsCurrentPosition: dataCurrentWeather?
    private var session = URLSession(configuration: .default)
    
    private static var urlApi = "http://api.openweathermap.org/data/2.5/weather?units=metric&lang=fr&appid=8d2f72c4af31a1d3bfaaee4d236a4588"
    
    init(session: URLSession){
        self.session = session
    }
    
    func  getCurrentWeatherConditions(whichLocation: WhichLocation,latitude: Double = 0, longitude: Double = 0,callback: @escaping (Bool) -> Void) {
//        var request = URLRequest(url: WeatherForecastService.urlApi)
//        request.httpMethod = "POST"
//        let body = "id=5128581&units=metric&lang=fr&appid=8d2f72c4af31a1d3bfaaee4d236a4588"
//        request.httpBody = body.data(using: .utf8)
        let urlOnWhichRequest = urlToRequest(whichLocation: whichLocation, latitude: latitude, longitude: longitude)
        
        task?.cancel()
        task = session.dataTask(with: urlOnWhichRequest, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print("ici1, \(String(describing: error))")
                    callback(false)
                    return
                }
                guard let responsio = response as? HTTPURLResponse, responsio.statusCode == 200 else {
                    print("ici2, \(String(describing: response))")
                    callback(false)
                    return
                }
                guard let conditions = try? JSONDecoder().decode(dataCurrentWeather.self, from: data) else {
                    print("ici3 + \(whichLocation)")
                    callback(false)
                    return
                }
                
                switch whichLocation {
                case .Paris:
                    self.weatherConditionsParis = conditions
                case .NewYork:
                    self.weatherConditionsNewYork = conditions
                case .currentPosition:
                    self.weatherConditionsCurrentPosition = conditions
                }
                
                callback(true)
            }
        })
        task?.resume()
    }
}


extension WeatherForecastService {
    enum WhichLocation {
        case currentPosition
        case NewYork
        case Paris
    }
    
    private func urlToRequest(whichLocation: WhichLocation,latitude: Double, longitude: Double) -> URL {
        var url: URL
        switch whichLocation {
        case .NewYork:
            url = URL(string: WeatherForecastService.urlApi + "&\(WeatherForecastService.newYorkId)")!
        case .Paris:
            url = URL(string: WeatherForecastService.urlApi + "&\(WeatherForecastService.parisId)")!
        case .currentPosition:
            let stringURL = WeatherForecastService.urlApi + "&lat=\(latitude)&lon=\(longitude)"
            print(stringURL)
            url = URL(string: stringURL)!
        }
        return url
    }
}

struct dataCurrentWeather : Decodable {
    let name: String
    let weather: [Weather]
    let main: WeatherMain
    
    init(name: String, weather: [Weather], main: WeatherMain) { // default struct initializer
        self.name = name
        self.weather = weather
        self.main = main
    }
}

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    
    init(id: Int, main: String, description: String) { // default struct initializer
        self.id = id
        self.main = main
        self.description = description
    }
}

struct WeatherMain {
    let temp: Double
    let pressure: Int
    let humidity: Int
    let tempMin: Double
    let tempMax: Double
    
    init(temp: Double, pressure: Int, humidity: Int, tempMin: Double, tempMax: Double) {
        self.temp = temp
        self.pressure = pressure
        self.humidity = humidity
        self.tempMin = tempMin
        self.tempMax = tempMax
    }
}

extension WeatherMain: Decodable {
    enum WeatherMainKeys: String, CodingKey {
        case temp = "temp"
        case pressure = "pressure"
        case humidity = "humidity"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: WeatherMainKeys.self) // defining our (keyed) container
        let temp: Double = try container.decode(Double.self, forKey: .temp) // extracting the data
        let pressure: Int = try container.decode(Int.self, forKey: .pressure)
        let humidity: Int = try container.decode(Int.self, forKey: .humidity)
        let tempMin: Double = try container.decode(Double.self, forKey: .tempMin)
        let tempMax: Double = try container.decode(Double.self, forKey: .tempMax)
        
        self.init(temp: temp, pressure: pressure, humidity: humidity, tempMin: tempMin, tempMax: tempMax) // initializing our struct
    }
}
