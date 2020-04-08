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
    
    func alertWithSettingsAndOKActions(title: String, message: String) {
        let alertController = AlertControllerWithResignActiveObservation(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Settings", style: .default, handler: {
                _ in
                if let url = URL.init(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
        }))
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true)
    }
    
    func alertWithOKActionAndOptionalTimeout(title: String, message: String, timeout: TimeInterval? = nil) {
        let alertController = AlertControllerWithResignActiveObservation(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        if let timeout = timeout {
            Timer.scheduledTimer(withTimeInterval: timeout, repeats: false, block: { (_) in
                self.dismiss(animated: true, completion: nil)
            })
        }
        self.present(alertController, animated: true)
    }
}
