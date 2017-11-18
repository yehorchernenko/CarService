//
//  Owner.swift
//  CarService
//
//  Created by Egor on 21.10.2017.
//  Copyright © 2017 Egor. All rights reserved.
//

import Foundation
import SQLite

class Owner{
    let profileImage: Blob
    let name: String
    let surname: String
    let driverLicense: Int
    let passport: String
    let phone: String
    let login: String
    let password: String
    
    init(profileImage: Blob, name:String,surname: String, driverLicense: Int, passport: String, phone: String, login: String, password: String) {
        self.profileImage = profileImage
        self.name = name
        self.surname = surname
        self.driverLicense = driverLicense
        self.passport = passport
        self.phone = phone
        self.login = login
        self.password = password
    }
    
    static let table = Table("Owner")
 
    static let profileImageExpression = Expression<Blob>("profileImage")
    static let nameExpression = Expression<String>("name")
    static let surnameExpression = Expression<String>("surname")
    static let driverLicenseExpression = Expression<Int>("driverLicense")
    static let passportExpression = Expression<String>("passport")
    static let phoneExpression = Expression<String>("phone")
    static let loginExpression = Expression<String>("login") //primary key
    static let passwordExpression = Expression<String>("password")

    
    //CREATE TABLE Owner (login NOT NULL PRIMARY KEY VARCHAR(255), password....
    class func createTable() -> String{
        let createTable = Owner.table.create {table in
            table.column(Owner.loginExpression, primaryKey: true)
            table.column(Owner.passwordExpression)
            table.column(Owner.profileImageExpression)
            table.column(Owner.nameExpression)
            table.column(Owner.surnameExpression)
            table.column(Owner.driverLicenseExpression)
            table.column(Owner.passportExpression)
            table.column(Owner.phoneExpression)
        }
        return createTable
    }
    
    //INSERT INTO Owner (login,password....) VALUES (.......)
    class func insert(profileImage: Blob, name:String,surname: String, driverLicense: Int, passport: String, phone: String, login: String, password: String) -> Insert{
        let insert = self.table.insert(Owner.loginExpression <- login,
                               Owner.passwordExpression <- password,
                               Owner.profileImageExpression <- profileImage,
                               Owner.nameExpression <- name,
                               Owner.surnameExpression <- surname,
                               Owner.driverLicenseExpression <- driverLicense,
                               Owner.passportExpression <- passport,
                               Owner.phoneExpression <- phone)
        return insert
    }
    

}


