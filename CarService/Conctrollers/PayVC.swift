//
//  PayVC.swift
//  CarService
//
//  Created by Egor on 20.12.2017.
//  Copyright © 2017 Egor. All rights reserved.
//

import UIKit

class PayVC: UIViewController {

    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var mainInfoVIew: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    var service: ExtendedService!
    

    @IBAction func payButtonPressed(_ sender: UIButton) {
        guard let id = service.id else {
            somethingGoWrongAlert(message: "Can't to pay")
            return
        }
        Service.delete(byCarSerialNumber: nil, serviceType: nil, selfId: id)
        
        screenShotMethod()
        showAlert()
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Tahnk you for paying", message: "Service has been removed. Check your bill in Photo Library", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func screenShotMethod() {
        //Create the UIImage
        UIGraphicsBeginImageContext(mainInfoVIew.frame.size)
        mainInfoVIew.layer.render(in: UIGraphicsGetCurrentContext()!)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return
        }
        UIGraphicsEndImageContext()
        
        //Save it to the camera roll
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    
    //MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.brandLabel.text = "Brand: \(service.carBrand)"
        self.modelLabel.text = "Model: \(service.carModel)"
        self.dateLabel.text = "Date: \(incomeDate(service.date))"
        self.priceLabel.text = "Price: \(service.typePrice) USD."
        self.textView.text = """
        Service name: \(service.typeName)
        Description: \(service.typeDescription)
        Performer: \(service.employeeName) \(service.employeeSurname)
        """
    }
    
    private func incomeDate(_ date: Date) -> String{
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd-MM-yyyy"
        
        return dateFormater.string(from: date)
    }

}
