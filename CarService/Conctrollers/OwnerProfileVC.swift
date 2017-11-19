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
    
    @IBAction func unwindToProfile(segue: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(carCellNib, forCellReuseIdentifier: carCellIdentifier)
        
        fillTextFields()
        

        //print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        retrieveCars { [weak self] (cars) in
            self?.cars = cars
            self?.tableView.reloadData()
        }
    }
    
    private func fillTextFields(){
        if let ownerLogin = login{
            //SELECT * FROM Owner WHERE login == ownerLogin LIMIT 1
            let ownerTable = Owner.table.where(Owner.loginExpression == ownerLogin).limit(1)
            
            do{
                let owner = try DataBase.shared.connection.pluck(ownerTable)
                
                nameTextField.text = owner?[Owner.loginExpression]
                surnameTextField.text = owner?[Owner.surnameExpression]
                driverLicenseTextField.text = String(describing: owner?[Owner.driverLicenseExpression])
                phoneTextField.text = owner?[Owner.phoneExpression]
                loginTextField.text = owner?[Owner.loginExpression]
                passwordTextField.text = owner?[Owner.passwordExpression]
                passportTextField.text = owner?[Owner.passportExpression]
                
                if let imageBlob = owner?[Owner.profileImageExpression]{
                profileImageView.image = UIImage.fromDatatypeValue(imageBlob)
                }
                
                
            } catch {
                print("Error during filling profile text fieds: \(error.localizedDescription)")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let carVC = segue.destination as? CarVC{
            carVC.login = loginTextField.text
        }
    }
    
    //MARK: Retrieve owner cars
    
    private func retrieveCars(cars: @escaping ([Car]) -> Void){
        guard let ownerLogin = login else {return}
        var retrivedCars = [Car]()
        do{
            for ownerCar in try DataBase.shared.connection.prepare(Car.table.filter(Car.ownerExpression == ownerLogin)){
                
                if ownerCar[Car.ownerExpression] == ownerLogin{
                    let car = Car(owner: ownerCar[Car.ownerExpression], brand: ownerCar[Car.brandExpression], model: ownerCar[Car.modelExpression], serialNumber: ownerCar[Car.serialNumberExpression], image: ownerCar[Car.imageExpression], color: ownerCar[Car.colorExpression])
                
                    //print(ownerCar)
                    retrivedCars.append(car)
                }
            }
        } catch{
            print("Car retrieve error: \(error.localizedDescription)")
        }
        
        DispatchQueue.main.async {
            cars(retrivedCars)
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
