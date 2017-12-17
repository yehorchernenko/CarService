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
    
    let picker = UIImagePickerController()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let ownerLogin = login{
            ownerTextField.text = ownerLogin
        }
        
        setGesture()
        Car.createTable()
        
        picker.delegate = self
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
        
        let car = Car(owner: ownerLogin, brand: brand, model: model, serialNumber: serialNumber, image: image, color: color)
        
        Car.insert(car)
        
        
        navigationController?.popViewController(animated: true)
    }
    
    private func setGesture(){
        let imageViewGesture = UITapGestureRecognizer(target: self, action: #selector(showImagePicker))
        carImage.addGestureRecognizer(imageViewGesture)
    }
    
    @objc private func showImagePicker(recognizer: UIGestureRecognizer){
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
}

extension CarVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        carImage.image = chosenImage
        dismiss(animated:true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
