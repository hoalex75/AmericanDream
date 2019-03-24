//
//  AmericanDreamTests.swift
//  AmericanDreamTests
//
//  Created by Alex on 03/03/2019.
//  Copyright © 2019 Alexandre Holet. All rights reserved.
//

import XCTest
@testable import AmericanDream

class ExchangeRateServiceTestCase: XCTestCase {
    var shared = ExchangeRateService.shared
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    // MARK: -Calculate Logic
    func testGivenANumberAndTheRate_WhenMultiplyThem_ThenResultIsGivenWithOnlyTwoNumbersAfterComa() {
        let rate = 1.11344
        shared.rate = rate
        let numberGiven = 20.56
        
        let result = shared.calculate(numberGiven)
        
        XCTAssertEqual(result, 22.89)
    }
    
    func testGivenStringWithComa_WhenTransformFuncIsApplied_ThenStringWithDots() {
        let given = "123,456"
        
        let result = given.transformComaIntoDots()
        
        XCTAssertEqual(result, "123.456")
    }

    // MARK: -Exchange Rate Services
    func testExchangeRateServiceWithCorrectDatas() {
        FakeResponseData.requestType = FakeResponseData.RequestType.exchangeRate
        let sessionFake = URLSessionFake(data: FakeResponseData.correctData, response: FakeResponseData.responseOK, error: nil)
        let exchangeRateService = ExchangeRateService(session: sessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for Queue Change")
        exchangeRateService.getExchangeRate { (success, rate) in
            XCTAssert(success)
            XCTAssertEqual(rate, 1.12183)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testExchangeServiceWithError() {
        FakeResponseData.requestType = FakeResponseData.RequestType.exchangeRate
        let sessionFake = URLSessionFake(data: FakeResponseData.correctData, response: FakeResponseData.responseOK, error: FakeResponseData.error)
        let exchangeRateService = ExchangeRateService(session: sessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for Queue Change")
        exchangeRateService.getExchangeRate { (success, rate) in
            XCTAssert(!success)
            XCTAssertNil(rate)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testExchangeServiceWithBadResponse() {
        FakeResponseData.requestType = FakeResponseData.RequestType.exchangeRate
        let sessionFake = URLSessionFake(data: FakeResponseData.correctData, response: FakeResponseData.responseKO, error: nil)
        let exchangeRateService = ExchangeRateService(session: sessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for Queue Change")
        exchangeRateService.getExchangeRate { (success, rate) in
            XCTAssert(!success)
            XCTAssertNil(rate)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testExchangeServiceWithIncorrectDatas() {
        FakeResponseData.requestType = FakeResponseData.RequestType.exchangeRate
        let sessionFake = URLSessionFake(data: FakeResponseData.incorrectData, response: FakeResponseData.responseOK, error: nil)
        let exchangeRateService = ExchangeRateService(session: sessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for Queue Change")
        exchangeRateService.getExchangeRate { (success, rate) in
            XCTAssert(!success)
            XCTAssertNil(rate)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    // MARK: -Weather Services
    func testWeatherServiceWithCorrectDatas() {
        FakeResponseData.requestType = .weather
        let sessionFake = URLSessionFake(data: FakeResponseData.correctData, response: FakeResponseData.responseOK, error: nil)
        let weatherService = WeatherForecastService(session: sessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for Queue Change")
        weatherService.getCurrentWeatherConditions(whichLocation: .NewYork) { (success) in
            XCTAssert(success)
            XCTAssertNotNil(weatherService.weatherConditionsNewYork)
            XCTAssertEqual(weatherService.weatherConditionsNewYork?.weather[0].description, "ciel dégagé")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testWeatherServiceWithError() {
        FakeResponseData.requestType = .weather
        let sessionFake = URLSessionFake(data: FakeResponseData.correctData, response: FakeResponseData.responseOK, error: FakeResponseData.error)
        let weatherService = WeatherForecastService(session: sessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for Queue Change")
        weatherService.getCurrentWeatherConditions(whichLocation: .NewYork) { (success) in
            XCTAssert(!success)
            XCTAssertNil(weatherService.weatherConditionsNewYork)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testWeatherServiceWithBadResponse() {
        FakeResponseData.requestType = .weather
        let sessionFake = URLSessionFake(data: FakeResponseData.correctData, response: FakeResponseData.responseKO, error: nil)
        let weatherService = WeatherForecastService(session: sessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for Queue Change")
        weatherService.getCurrentWeatherConditions(whichLocation: .NewYork) { (success) in
            XCTAssert(!success)
            XCTAssertNil(weatherService.weatherConditionsNewYork)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testWeatherServiceWithIncorrectDatas() {
        FakeResponseData.requestType = .weather
        let sessionFake = URLSessionFake(data: FakeResponseData.incorrectData, response: FakeResponseData.responseOK, error: nil)
        let weatherService = WeatherForecastService(session: sessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for Queue Change")
        weatherService.getCurrentWeatherConditions(whichLocation: .NewYork) { (success) in
            XCTAssert(!success)
            XCTAssertNil(weatherService.weatherConditionsNewYork)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    
    // MARK: -Translation Services
    func testTranslationServiceWithCorrectDatas(){
        FakeResponseData.requestType = .translation
        let sessionFake = URLSessionFake(data: FakeResponseData.correctData, response: FakeResponseData.responseOK, error: nil)
        let translationService = TranslationService(session: sessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change")
        translationService.translate(textToTranslate: "Tu es nerveux Jack !") { (success, translateSentence) in
            XCTAssert(success)
            XCTAssertNotNil(translateSentence)
            XCTAssertEqual(translateSentence, "You're nervous Jack!")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func textTranslationServiceWithErrors() {
        FakeResponseData.requestType = .translation
        let sessionFake = URLSessionFake(data: FakeResponseData.correctData, response: FakeResponseData.responseOK, error: FakeResponseData.error)
        let translationService = TranslationService(session: sessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.translate(textToTranslate: "Tu es nerveux Jack !") { (success, translatedText) in
            XCTAssert(!success)
            XCTAssertNil(translatedText)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func textTranslationServiceWithBadResponse() {
        FakeResponseData.requestType = .translation
        let sessionFake = URLSessionFake(data: FakeResponseData.correctData, response: FakeResponseData.responseKO, error: nil)
        let translationService = TranslationService(session: sessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.translate(textToTranslate: "Tu es nerveux Jack !") { (success, translatedText) in
            XCTAssert(!success)
            XCTAssertNil(translatedText)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func textTranslationServiceWithIncorrectDatas() {
        FakeResponseData.requestType = .translation
        let sessionFake = URLSessionFake(data: FakeResponseData.incorrectData, response: FakeResponseData.responseOK, error: nil)
        let translationService = TranslationService(session: sessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.translate(textToTranslate: "Tu es nerveux Jack !") { (success, translatedText) in
            XCTAssert(!success)
            XCTAssertNil(translatedText)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
}
