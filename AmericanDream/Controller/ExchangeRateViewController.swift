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
        setBackgroundImage()
        toggleActivityIndicator(shown: true)
        ExchangeRateService.shared.getExchangeRate { (success, rate) in
            if success {
                self.exchangeRate.text = "\(rate!)"
            } else {
                self.createAndDisplayAlerts(message: "Erreur de connection réseau, échec de l'obtention du taux de change du jour.")
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

extension ExchangeRateViewController: FunctionsForViewControllers {
    
    private func setBackgroundImage() {
        let backgroundImage = getBackgroundImage(imageName: "exchangeBackground")
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    private func createAndDisplayAlerts(message: String){
        let alertVC = createAlert(message: message)
        present(alertVC, animated: true, completion: nil)
    }
}
