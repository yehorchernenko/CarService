//
//  ClientsVC.swift
//  CarService
//
//  Created by Egor on 19.12.2017.
//  Copyright © 2017 Egor. All rights reserved.
//

import UIKit

class ClientsVC: UITableViewController {
    
    var owners = [Owner]()

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
        Owner.selectAll { retrievedOwners in
            self.owners = retrievedOwners
            self.tableView.reloadData()
            
        }
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return owners.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: clientCellID, for: indexPath) as! ClientCell
        
        let owner = owners[indexPath.row]
        
        cell.idLabel.text = "\(owner.login)"
        cell.profileImageView.image = UIImage.fromDatatypeValue(owner.profileImage)
        cell.nameLabel.text = "Name: \(owner.name) \(owner.surname)"
        cell.phoneLabel.text = "Phone: \(owner.phone)"
        cell.licenseLabel.text = "Driver license: \(owner.driverLicense)"
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
        }
    }


}
