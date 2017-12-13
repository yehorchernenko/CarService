//
//  OwnerProfileVC.swift
//  CarService
//
//  Created by Egor on 05.11.2017.
//  Copyright © 2017 Egor. All rights reserved.
//

import UIKit
import SQLite

class OwnerProfileVC: UIViewController {
    
    //MARK: - Properties
    var login: String?
    let carCellNib = UINib(nibName: "CarCell", bundle: nil)
    var cars = [Car]()
    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var driverLicenseTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passportTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func addCarButtonPressed(_ sender: UIButton) {}
        
    @IBAction func logOutButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func serviceButtonTaped(_ sender: Any) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(carCellNib, forCellReuseIdentifier: carCellIdentifier)
        
        fillTextFields()
        //print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadCars()
    }
    
    private func fillTextFields(){
        //SELECT * FROM Owner WHERE login == ownerLogin LIMIT 1

        if let ownerLogin = login,
            let owner = Owner.selectAllFrom(login: ownerLogin){
            
            nameTextField.text = owner.name
            surnameTextField.text = owner.surname
            driverLicenseTextField.text = String(owner.driverLicense)
            phoneTextField.text = owner.phone
            passportTextField.text = owner.passport
            loginTextField.text = owner.login
            passwordTextField.text = owner.password
            profileImageView.image = UIImage.fromDatatypeValue(owner.profileImage)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let carVC = segue.destination as? CarVC{
            carVC.login = loginTextField.text
        }
        
        if let serviceVC = segue.destination as? ServiceVC{
            serviceVC.ownerLogin = loginTextField.text
        }
    }
    
    //MARK: Retrieve owner cars
    
    private func loadCars(){
        if let login = login{
            Car.retrieveCarsForOwner(login: login) { [weak self] cars in
                self?.cars = cars
                self?.tableView.reloadData()
            }
        }
    }

}

extension OwnerProfileVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: carCellIdentifier, for: indexPath) as! CarCell
        cell.carImageView.image = UIImage.fromDatatypeValue(cars[indexPath.row].image)
        cell.serialNumberLabel.text = "\(cars[indexPath.row].serialNumber)"
        cell.brandLabel.text = cars[indexPath.row].brand
        cell.modelLabel.text = cars[indexPath.row].model
        cell.ownerLabel.text = cars[indexPath.row].owner
        return cell
    }
}
