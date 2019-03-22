//
//  TranslationViewController.swift
//  AmericanDream
//
//  Created by Alex on 10/03/2019.
//  Copyright © 2019 Alexandre Holet. All rights reserved.
//

import UIKit

class TranslationViewController: UIViewController {

    @IBOutlet weak var textToTranslate: UITextField!
    @IBOutlet weak var translatedLabel: UILabel!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        translatedLabel.text = ""
        setBackgroundImage()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func translate() {
        translateText()
    }
    
    private func translateText() {
        guard let text = textToTranslate.text, text != "" else {
            return
        }
        self.toggleActivityIndicator(shown: true)
        TranslationService.shared.translate(textToTranslate: text) { (success, textReceived) in
            if success, let textReceived = textReceived {
                self.translatedLabel.text = textReceived
            } else {
                self.createAndDisplayAlerts(message: "Erreur de connection réseau, échec de l'obtention de la traduction.")
            }
            self.toggleActivityIndicator(shown: false)
        }
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        translateButton.isHidden = shown
        activityIndicator.isHidden = !shown
    }
    
}

extension TranslationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textToTranslate.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField.text == "" {
            translatedLabel.text = ""
        } else {
            translateText()
        }
    }
}

extension TranslationViewController: FunctionsForViewControllers {
    
    private func setBackgroundImage() {
        let backgroundImage = getBackgroundImage(imageName: "translationBackground")
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    private func createAndDisplayAlerts(message: String){
        let alertVC = createAlert(message: message)
        present(alertVC, animated: true, completion: nil)
    }
}
