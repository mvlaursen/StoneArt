//
//  UIViewController+Alert.swift
//  StoneArt
//
//  Created by Mike Laursen on 4/7/20.
//  Copyright © 2020 Appamajigger. All rights reserved.
//

import UIKit

extension UIViewController {
    class AlertControllerWithResignActiveObservation: UIAlertController {
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Apple's Human Interface Guidelines for alerts on iOS recommend
            // dismissing any visible alerts when the user goes to the Home
            // screen.
            //
            // For iOS 9 and later, in the case where this UIAlertController is
            // dismissed by the user, we do not need to explicitly remove the
            // observer.
            NotificationCenter.default.addObserver(self, selector: #selector(onWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        }
                
        @objc private func onWillResignActive() {
            NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func alertWithOKAction(title: String, message: String) {
        let alertController = AlertControllerWithResignActiveObservation(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true)
    }
}
