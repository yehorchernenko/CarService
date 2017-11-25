//
//  CarVC.swift
//  CarService
//
//  Created by Egor on 18.11.2017.
//  Copyright © 2017 Egor. All rights reserved.
//

import UIKit

class CarVC: UIViewController {

    //MARK: - Properties
    var login: String?
    
    //MARK: - Outlets
    @IBOutlet weak var ownerTextField: UITextField!
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var serialNumberTextField: UITextField!
    @IBOutlet weak var colorTextField: UITextField!
    @IBOutlet weak var carImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let ownerLogin = login{
            ownerTextField.text = ownerLogin
        }
        
        do{
            try DataBase.shared.connection.run(Car.createTable())
        } catch {
            print("Can't create Car table")
        }
    }

    @IBAction func addButtonPressed(_ sender: UIButton) {
        guard let ownerLogin = login,
            let brand = brandTextField.text,
            let model = modelTextField.text,
            let serialNumberText = serialNumberTextField.text,
            let serialNumber = Int(serialNumberText),
            let color = colorTextField.text,
            let image = carImage.image?.datatypeValue
        else {
            somethingGoWrongAlert(message: "Please fill all fields.")
            return
        }
        
        let carInsert = Car.insert(owner: ownerLogin, brand: brand, model: model, serialNumber: serialNumber, image: image, color: color)
        
        do{
            try DataBase.shared.connection.run(carInsert)
        } catch{
            print("Can't add new values to 'Car' table error: \(error.localizedDescription)")
        }
        
        navigationController?.popViewController(animated: true)
    }
    
}
