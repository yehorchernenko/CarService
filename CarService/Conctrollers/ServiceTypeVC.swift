//
//  ServiceTypeVC.swift
//  CarService
//
//  Created by Egor on 04.12.2017.
//  Copyright © 2017 Egor. All rights reserved.
//

import UIKit

class ServiceTypeVC: UIViewController {

    var serviceTypes = [ServiceType]()
    let categoryCellNib = UINib(nibName: "CategoryCell", bundle: nil)

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(categoryCellNib, forCellReuseIdentifier: categoryCellIdentifier)

        ServiceType.createTable()

        loadServiceTypes()
        
    }
    
    //MARK: - Methods
    @IBAction func addButtonPressed(_ sender: Any) {
        guard let category = categoryTextField.text, !category.isEmpty,
            let description = descriptionTextField.text, !description.isEmpty,
            let priceText = priceTextField.text, !priceText.isEmpty,
            let price = Double(priceText)
            else{
                somethingGoWrongAlert(message: "Please fill all gaps")
                return
        }
        
        let newServiceType = ServiceType(id: nil, name: category, description: description, price: price)
        
        ServiceType.insert(newServiceType)
        
        loadServiceTypes()
        
        categoryTextField.text = ""
        descriptionTextField.text = ""
        priceTextField.text = ""
    }
 
    private func loadServiceTypes(){
        ServiceType.selectAll { [weak self] (serviceTypes) in
            self?.serviceTypes = serviceTypes
            self?.tableView.reloadData()
        }
    }
}

extension ServiceTypeVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: categoryCellIdentifier, for: indexPath) as! CategoryCell
        let serviceType = serviceTypes[indexPath.row]
        
        cell.idLabel.text = "ID: \(String(describing: serviceType.id!))"
        cell.nameLabel.text = serviceType.name
        cell.descriptionLabel.text = serviceType.description
        cell.priceLabel.text = "Price: \(serviceType.price) usd."
        
        return cell
    }
}
