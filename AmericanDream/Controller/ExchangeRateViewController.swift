//
//  ExchangeRateViewController.swift
//  AmericanDream
//
//  Created by Alex on 02/03/2019.
//  Copyright © 2019 Alexandre Holet. All rights reserved.
//

import UIKit

class ExchangeRateViewController: UIViewController {
    @IBOutlet weak var exchangeRate: UILabel!
    @IBOutlet weak var amountToExchange: UITextField!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var calculateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleActivityIndicator(shown: true)
        ExchangeRateService.shared.getExchangeRate { (success, rate) in
            if success {
                self.exchangeRate.text = "\(rate!)"
            }
            self.toggleActivityIndicator(shown: false)
        }
    }
    
    @IBAction func calculateAmount() {
        ExchangeRateService.shared.sendResult(numberToChange: amountToExchange.text) { (success, resultNumber) in
            if success {
                result.text = "\(resultNumber!) Dollars."
            }
        }
    }
    
    
    
    private func toggleActivityIndicator(shown: Bool) {
        calculateButton.isHidden = shown
        activityIndicator.isHidden = !shown
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ExchangeRateViewController: UITextFieldDelegate {
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        amountToExchange.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
