//
//  AllEmployeesVC.swift
//  CarService
//
//  Created by Egor on 19.12.2017.
//  Copyright © 2017 Egor. All rights reserved.
//

import UIKit

class AllEmployeesVC: UITableViewController {

    
    var employees = [Employee]()
    
    fileprivate func registeCell() {
        let nib = UINib(nibName: "ClientCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: clientCellID)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        registeCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Employee.selectAll { retrievedEmployees in
            self.employees = retrievedEmployees
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: clientCellID, for: indexPath) as! ClientCell
        
        let employee = employees[indexPath.row]
        
        cell.idLabel.text = "\(employee.login)"
        cell.profileImageView.image = UIImage.fromDatatypeValue(employee.image)
        cell.nameLabel.text = "Name: \(employee.name) \(employee.surname)"
        cell.phoneLabel.text = "Phone: \(employee.phone) Passport: \(employee.passport)"
        cell.licenseLabel.text = "Postion: \(employee.position)"
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            Employee.delete(byLogin: employees[indexPath.row].login)
            employees.remove(at: indexPath.row)
            tableView.reloadData()
            
            employeeDeleteAlert()
        }
    }

    fileprivate func employeeDeleteAlert() {
        let alert = UIAlertController(title: "Employee has been dismissed", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}
