//
//  ServiceVC.swift
//  CarService
//
//  Created by Egor on 05.12.2017.
//  Copyright © 2017 Egor. All rights reserved.
//

import UIKit

class ServiceVC: UIViewController {

    @IBOutlet weak var carPicker: UIPickerView!
    @IBOutlet weak var serviceTypePicker: UIPickerView!
    @IBOutlet weak var employeePicker: UIPickerView!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Service.createTable()
    }

}


//MARK: - PickerViewDelegate

extension ServiceVC: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    
    
}
