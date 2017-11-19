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
    class func createTable() -> String{
        let createTable = Car.table.create(ifNotExists: true) { (table) in
            table.column(Car.serialNumberExpression, primaryKey: true)
            table.column(Car.ownerExpression)
            table.column(Car.brandExpression)
            table.column(Car.modelExpression)
            table.column(Car.imageExpression)
            table.column(Car.colorExpression)
            
            table.foreignKey(Car.ownerExpression, references: Owner.table, Owner.loginExpression)
        }
        return createTable
    }
    
    //INSERT INTO Car (owner,brand.....) VALUES (......)
    class func insert(owner: String, brand: String, model: String,serialNumber: Int, image: Blob, color: String) -> Insert{
        let insert = self.table.insert(Car.serialNumberExpression <- serialNumber,
                                       Car.ownerExpression <- owner,
                                       Car.brandExpression <- brand,
                                       Car.modelExpression <- model,
                                       Car.imageExpression <- image,
                                       Car.colorExpression <- color)
        return insert
    }
    
    
    
}
