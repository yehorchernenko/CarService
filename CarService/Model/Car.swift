//
//  Car.swift
//  CarService
//
//  Created by Egor on 21.10.2017.
//  Copyright © 2017 Egor. All rights reserved.
//

import Foundation
import SQLite

class Car{
    var owner: String
    var brand: String
    var model: String
    var serialNumber: Int
    var image: Blob
    var color: String
    
    init(owner: String, brand: String, model: String,serialNumber: Int, image: Blob, color: String) {
        self.owner = owner
        self.brand = brand
        self.model = model
        self.serialNumber = serialNumber
        self.image = image
        self.color = color
    }
    
    static let table = Table("Car")
    
    static let ownerExpression = Expression<String>("login")
    static let brandExpression = Expression<String>("brand")
    static let modelExpression = Expression<String>("model")
    static let serialNumberExpression = Expression<Int>("serialNumber")//primary key
    static let imageExpression = Expression<Blob>("image")
    static let colorExpression = Expression<String>("color")
    
    
    //CREATE TABLE Car IF NOT EXISTS (serialNumber NOT NULL PRIMARY KEY VARCHAR(255), FOREIGN KEY(owner) REFERENCES Owner()
    class func createTable(){
        let createTable = table.create(ifNotExists: true) { (table) in
            table.column(serialNumberExpression, primaryKey: true)
            table.column(ownerExpression)
            table.column(brandExpression)
            table.column(modelExpression)
            table.column(imageExpression)
            table.column(colorExpression)
            
            table.foreignKey(Car.ownerExpression, references: Owner.table, Owner.loginExpression)
        }
        do{
            try DataBase.shared.connection.run(createTable)
        } catch {
            print("Can't create Car table")
        }
        
    }
    
    //INSERT INTO Car (owner,brand.....) VALUES (......)
    class func insert(_ car: Car){
        let insert = table.insert(serialNumberExpression <- car.serialNumber,
                                       ownerExpression <- car.owner,
                                       brandExpression <- car.brand,
                                       modelExpression <- car.model,
                                       imageExpression <- car.image,
                                       colorExpression <- car.color)
        do{
            try DataBase.shared.connection.run(insert)
        } catch{
            print("Can't add new values to 'Car' table error: \(error.localizedDescription)")
        }
        
    }
    
    
    //SELECT * FROM Car WHERE login == login
    class func retrieveCarsForOwner(login: String, cars: @escaping ([Car]) -> Void){
        var retrievedCars = [Car]()
        
        do{
            for car in try DataBase.shared.connection.prepare(table.filter(ownerExpression == login)){
                
                let ownerCar = Car(owner: car[ownerExpression], brand: car[brandExpression], model: car[modelExpression], serialNumber: car[serialNumberExpression], image: car[imageExpression], color: car[colorExpression])
                
                retrievedCars.append(ownerCar)
            }
        } catch {
             print("Car retrieve error: \(error.localizedDescription)")
        }
        
        DispatchQueue.main.async {
            cars(retrievedCars)
        }
    }
    
}
