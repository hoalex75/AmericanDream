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

        // Do any additional setup after loading the view.
    }
    
    @IBAction func calculateAmount() {
        toggleActivityIndicator(shown: true)
        ExchangeRateService.shared.getExchangeRate { (success, rate) in
            if success {
                self.exchangeRate.text = "\(rate!)"
            }
            self.toggleActivityIndicator(shown: false)
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
