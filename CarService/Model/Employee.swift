//
//  Employee.swift
//  CarService
//
//  Created by Egor on 21.10.2017.
//  Copyright © 2017 Egor. All rights reserved.
//

import UIKit
import SQLite

class Employee{
    var image: Blob
    var name: String
    var surname: String
    var position: String
    var adress: String
    var phone: String
    var isAdmin: Bool
    var login: String
    var password: String
    
    init(image: Blob, name: String,surname: String,position: String,adress: String,phone: String,isAdmin: Bool = false,login: String,password: String) {
        self.image = image
        self.name = name
        self.surname = surname
        self.position = position
        self.adress = adress
        self.phone = phone
        self.isAdmin = isAdmin
        self.login = login
        self.password = password
    }
    
    
    static let table = Table("Employee")
    
    static let imageExpression = Expression<Blob>("image")
    static let nameExpression = Expression<String>("name")
    static let surnameExpression = Expression<String>("surname")
    static let positionExpression = Expression<String>("position")
    static let adressEpxression = Expression<String>("adress")
    static let phoneExpression = Expression<String>("phone")
    static let isAdminExpression = Expression<Bool>("isAdmin")
    static let loginExpression = Expression<String>("login")//primary key
    static let passwordEpression = Expression<String>("password")
    
    
    //CREATE TABLE Employee IF NOT EXISTS(login NOT NULL PRIMARY KEY VARCHAR(255), password....

    class func createTable(){
        let createTable = table.create(ifNotExists: true) { table in
            table.column(loginExpression, primaryKey: true)
            table.column(passwordEpression)
            table.column(imageExpression)
            table.column(nameExpression)
            table.column(surnameExpression)
            table.column(positionExpression)
            table.column(adressEpxression)
            table.column(phoneExpression)
            table.column(isAdminExpression)
        }
        
        do{
            try DataBase.shared.connection.run(createTable)
        } catch {
            print("Can't create Employee table")
        }
    }
    
}
