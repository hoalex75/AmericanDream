//
//  FakeResponseData.swift
//  AmericanDreamTests
//
//  Created by Alex on 08/03/2019.
//  Copyright © 2019 Alexandre Holet. All rights reserved.
//

import Foundation

class FakeResponseData {
    static var correctData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "ExchangeRate", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static let incorrectData = "erreur".data(using: .utf8)!
    
    static let responseOK = HTTPURLResponse(url: URL(string: "http://www.openclassrooms.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    static let responseKO = HTTPURLResponse(url: URL(string: "http://www.openclassrooms.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)
    
    class ExchangeRateError: Error {}
    static let error = ExchangeRateError()
    
}
