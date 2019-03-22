//
//  BackgroundImage.swift
//  AmericanDream
//
//  Created by Alex on 16/03/2019.
//  Copyright © 2019 Alexandre Holet. All rights reserved.
//

import UIKit

protocol FunctionsForViewControllers {
    func getBackgroundImage(imageName: String) -> UIImageView
    func createAlert(message: String) -> UIAlertController
}

extension FunctionsForViewControllers {
    func getBackgroundImage(imageName: String) -> UIImageView{
        let backgroundImage = UIImageView(frame : UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: imageName)
        backgroundImage.contentMode = UIView.ContentMode.scaleToFill
        return backgroundImage
    }
    
    func createAlert(message: String) -> UIAlertController {
        let alertVC = UIAlertController(title: "Erreur", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertVC.addAction(action)
        return alertVC
    }
}
