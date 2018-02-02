//
//  Alerts.swift
//  SV Queuer
//
//  Created by Kevin Lopez on 2/2/18.
//  Copyright © 2018 Silicon Villas. All rights reserved.
//

import UIKit

struct Alerts {

    static let defaultErrorTitle = "Ruh roh"
    static let defaultErrorMessage = "\nMaybe check your internet?"

    static func presentGenericErrorAlert(on viewController: UIViewController, error: String) {
        presentSimpleAlert(on: viewController, title: defaultErrorTitle, message: error + defaultErrorMessage)
    }

    static func presentSimpleAlert(on viewController: UIViewController, title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        viewController.present(alertController, animated: true, completion: nil)
    }
}
