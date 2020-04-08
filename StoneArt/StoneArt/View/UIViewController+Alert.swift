//
//  UIViewController+Alert.swift
//  StoneArt
//
//  Created by Mike Laursen on 4/7/20.
//  Copyright © 2020 Appamajigger. All rights reserved.
//

import UIKit

extension UIViewController {
    func alertWithOKAction(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true)
    }
}
