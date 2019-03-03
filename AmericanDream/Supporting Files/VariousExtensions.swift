//
//  VariousExtensions.swift
//  AmericanDream
//
//  Created by Alex on 03/03/2019.
//  Copyright © 2019 Alexandre Holet. All rights reserved.
//

import Foundation

extension Double {
    func roundedToASpecificNumberAfterComa(numberOfNumbersAfterComa: Int) -> Double {
        let factorOfMultiplication = pow(10,Double(numberOfNumbersAfterComa))
        var numberRounded = self.rounded(.towardZero)
        let numberInferiorToOne = self - numberRounded
        var numberToRound = numberInferiorToOne * factorOfMultiplication
        numberToRound.round()
        numberRounded += numberToRound/factorOfMultiplication
        return numberRounded
    }
}
