//
//  BackgroundImage.swift
//  AmericanDream
//
//  Created by Alex on 16/03/2019.
//  Copyright © 2019 Alexandre Holet. All rights reserved.
//

import UIKit

protocol BackgroundImage {
    func getBackgroundImage(imageName: String) -> UIImageView
}

extension BackgroundImage {
    func getBackgroundImage(imageName: String) -> UIImageView{
        let backgroundImage = UIImageView(frame : UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: imageName)
        backgroundImage.contentMode = UIView.ContentMode.scaleToFill
        return backgroundImage
    }
}
