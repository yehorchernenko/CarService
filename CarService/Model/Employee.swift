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
    var passport: String
    var isAdmin: Bool
    var login: String
    var password: String
    
    init(image: Blob, name: String,surname: String,position: String,adress: String,phone: String,passport: String,isAdmin: Bool = false,login: String,password: String) {
        self.image = image
        self.name = name
        self.surname = surname
        self.position = position
        self.adress = adress
        self.phone = phone
        self.passport = passport
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
    static let passportExpression = Expression<String>("passport")
    static let isAdminExpression = Expression<Bool>("isAdmin")
    static let loginExpression = Expression<String>("login")//primary key
    static let passwordExpression = Expression<String>("password")
    
    
    //CREATE TABLE Employee IF NOT EXISTS(login NOT NULL PRIMARY KEY VARCHAR(255), password....

    class func createTable(){
        let createTable = table.create(ifNotExists: true) { table in
            table.column(loginExpression, primaryKey: true)
            table.column(passwordExpression)
            table.column(imageExpression)
            table.column(nameExpression)
            table.column(surnameExpression)
            table.column(positionExpression)
            table.column(adressEpxression)
            table.column(phoneExpression)
            table.column(passportExpression)
            table.column(isAdminExpression)
        }
        
        do{
            try DataBase.shared.connection.run(createTable)
        } catch {
            print("Can't create Employee table")
        }
    }
    
    class func insert(_ employee: Employee){
        let insert = table.insert(
                loginExpression <- employee.login,
                passwordExpression <- employee.password,
                imageExpression <- employee.image,
                nameExpression <- employee.name,
                surnameExpression <- employee.surname,
                positionExpression <- employee.position,
                adressEpxression <- employee.adress,
                phoneExpression <- employee.phone,
                passportExpression <- employee.passport,
                isAdminExpression <- employee.isAdmin
        )
        print(insert)
        
        do{
            try DataBase.shared.connection.run(insert)
            print(">>New data were inserted")
            
        } catch {
            print(">>DataBase inserting error: \(error.localizedDescription)")
        }
    }
    
    //SELECT login,password FROM Owner;
    class func login(_ login: String, password: String) -> Bool?{
        do{
            for owner in try DataBase.shared.connection.prepare(table.select(loginExpression,passwordExpression,isAdminExpression)){
                
                if owner[loginExpression] == login && owner[passwordExpression] == password && owner[isAdminExpression]{
                    return true //admin
                }
                
                if owner[loginExpression] == login && owner[passwordExpression] == password{
                    return false //employee
                }
                
            }
            
        } catch {
            print(">> Throw error when login employee: \(error.localizedDescription)")
        }
        return nil
    }
    
    //SELECT * FROM Owner WHERE login == ownerLogin LIMIT 1
    class func selectAllFrom(login: String) -> Employee?{
        do{
            let request = table.where(login == loginExpression).limit(1)
            
            if let employeeRow = try DataBase.shared.connection.pluck(request){
                let employee = Employee(image: employeeRow[imageExpression], name: employeeRow[nameExpression], surname: employeeRow[surnameExpression], position: employeeRow[positionExpression], adress: employeeRow[adressEpxression], phone: employeeRow[phoneExpression], passport: employeeRow[passportExpression], isAdmin: employeeRow[isAdminExpression], login: employeeRow[loginExpression], password: employeeRow[passwordExpression])

                return employee
            }
            
        } catch{
            print(">> Throw error when select all information for employee login: \(error.localizedDescription)")
        }
        
        return nil
    }
    
}
