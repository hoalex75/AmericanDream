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

    func testGivenANumberAndTheRate_WhenMultiplyThem_ThenResultIsGivenWithOnlyTwoNumbersAfterComa() {
        let rate = 1.11344
        shared.rate = rate
        let numberGiven = 20.56
        
        let result = shared.calculate(numberGiven)
        
        XCTAssertEqual(result, 22.89)
    }

}
