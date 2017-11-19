//
//  UIViewController + SomethongGoWrongAlert.swift
//  CarService
//
//  Created by Egor on 19.11.2017.
//  Copyright © 2017 Egor. All rights reserved.
//

import UIKit

extension UIViewController{
    final func somethingGoWrongAlert(message: String){
        let alert = UIAlertController(title: "Something go wrong.", message: message, preferredStyle: .alert)
        let alertOKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(alertOKAction)
        present(alert, animated: true, completion: nil)
    }
}
