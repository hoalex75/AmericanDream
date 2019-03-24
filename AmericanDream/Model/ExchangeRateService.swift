//
//  ExchangeRateService.swift
//  AmericanDream
//
//  Created by Alex on 03/03/2019.
//  Copyright © 2019 Alexandre Holet. All rights reserved.
//

import Foundation

class ExchangeRateService {
    static var shared = ExchangeRateService()
    
    private static let urlApi = URL(string: "http://data.fixer.io/api/latest?access_key=98312c5648eafa487324aba893d79bcc&symbols=usd")!
    private static let apiKey = "98312c5648eafa487324aba893d79bcc"
    private init() {}
    private var task: URLSessionDataTask?
    var rate : Double?
    private var session = URLSession(configuration: .default)
    init(session: URLSession){
        self.session = session
    }
    
    func getExchangeRate(callback: @escaping (Bool,Double?) -> Void) {
//        var request = URLRequest(url: ExchangeRateService.urlApi)
//        request.httpMethod = "POST"
//        let body = "access_key=\(ExchangeRateService.apiKey)&symbols=usd"
//        request.httpBody = body.data(using: .utf8)
        
        
        task?.cancel()
        task = session.dataTask(with: ExchangeRateService.urlApi) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false,nil)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false,nil)
                    return
                }
                
                guard let exchangeRate = try? JSONDecoder().decode(ExchangeRate.self, from: data) else {
                    callback(false,nil)
                    return
                }
                self.rate = exchangeRate.rates["USD"]
                callback(true,self.rate)
            }
        }
        task?.resume()
    }
    
    func calculate(_ numberGiven: Double) -> Double{
        let result: Double = rate!*numberGiven
        return result.roundedToASpecificNumberAfterComa(numberOfNumbersAfterComa: 2)
    }
    
    func sendResult(numberToChange: String?,callback: (Bool,Double?) -> Void) {
        guard let numberToChange = numberToChange else {
            callback(false,nil)
            return
        }
        let numberToChangeWithDots = numberToChange.transformComaIntoDots()
        guard let changingNumber = Double(numberToChangeWithDots) else {
            callback(false,nil)
            return
        }
        let result = calculate(changingNumber)
        callback(true,result)
    }
}

struct ExchangeRate {
    let success: Bool
    let base: String
    let rates : [String:Double]
    
    init(success: Bool, base: String, rates: [String:Double]) {
        self.success = success
        self.base = base
        self.rates = rates
    }
}

extension ExchangeRate: Decodable {
    enum ExchangeRateKeys: String, CodingKey {
        case success = "success"
        case base = "base"
        case rates = "rates"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ExchangeRateKeys.self) // defining our (keyed) container
        let success: Bool = try container.decode(Bool.self, forKey: .success) // extracting the data
        let base: String = try container.decode(String.self, forKey: .base) // extracting the data
        let rates: [String:Double] = try container.decode([String:Double].self, forKey: .rates) // extracting the data
        
        self.init(success: success, base: base, rates: rates) // initializing our struct
    }
}


