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
    
    //CREATE TABLE Owner IF NOT EXISTS(login NOT NULL PRIMARY KEY VARCHAR(255), password....
    class func createTable(){
        let createTable = table.create(ifNotExists: true) {table in
            table.column(loginExpression, primaryKey: true)
            table.column(passwordExpression)
            table.column(profileImageExpression)
            table.column(nameExpression)
            table.column(surnameExpression)
            table.column(driverLicenseExpression)
            table.column(passportExpression)
            table.column(phoneExpression)
        }
        
        do{
            try DataBase.shared.connection.run(createTable)
        } catch {
            print("Can't create Owner table")
        }
        
    }
    
    //INSERT INTO Owner (login,password....) VALUES (.......)
    class func insert(_ owner: Owner){
        let insert = table.insert(loginExpression <- owner.login,
                               passwordExpression <- owner.password,
                               profileImageExpression <- owner.profileImage,
                               nameExpression <- owner.name,
                               surnameExpression <- owner.surname,
                               driverLicenseExpression <- owner.driverLicense,
                               passportExpression <- owner.passport,
                               phoneExpression <- owner.phone)

        do{
            try DataBase.shared.connection.run(insert)
            print("New data were inserted")
            
        } catch {
            print("DataBase inserting error: \(error.localizedDescription)")
        }
    }
    
    //SELECT login,password FROM Owner;
    class func login(_ login: String, password: String) -> Bool{
        do{
            for owner in try DataBase.shared.connection.prepare(table.select(loginExpression,passwordExpression)){
                
                if owner[loginExpression] == login && owner[passwordExpression] == password{
                    return true
                }
                
            }
            
        } catch {
            print("Throw error when login owner: \(error.localizedDescription)")
        }
        return false
    }
    
    //SELECT * FROM Owner WHERE login == ownerLogin LIMIT 1
    class func selectAll(owners: @escaping([Owner]) -> Void){
        var retrievedOwners = [Owner]()
        
        do{
            for ownerRow in try DataBase.shared.connection.prepare(table){
                
                let owner = Owner(profileImage: ownerRow[profileImageExpression], name: ownerRow[nameExpression], surname: ownerRow[surnameExpression], driverLicense: ownerRow[driverLicenseExpression], passport: ownerRow[passportExpression], phone: ownerRow[phoneExpression], login: ownerRow[loginExpression], password: ownerRow[passwordExpression])
                
                retrievedOwners.append(owner)
            }
        } catch{
            print("error at selectAll in Owner")
        }
        
        DispatchQueue.main.async {
            owners(retrievedOwners)
        }
    }
    
    class func selectForUserlogin( login: String) -> Owner?{
        do{
            let request = table.where(login == loginExpression).limit(1)
            
            if let ownerRow = try DataBase.shared.connection.pluck(request){
                
                let owner = Owner(profileImage: ownerRow[profileImageExpression], name: ownerRow[nameExpression], surname: ownerRow[surnameExpression], driverLicense: ownerRow[driverLicenseExpression], passport: ownerRow[passportExpression], phone: ownerRow[phoneExpression], login: ownerRow[loginExpression], password: ownerRow[passwordExpression])
                return owner
            }
            
        } catch{
            print("Throw error when select all information for owner login: \(error.localizedDescription)")
        }
        
        return nil
    }

    //UPDATE
    
    class func update(owner: Owner){
        let alice = table.where(loginExpression == owner.login)
        
        do{
            try DataBase.shared.connection.run(alice.update(passwordExpression <- owner.password,
                                                            profileImageExpression <- owner.profileImage,
                                                            nameExpression <- owner.name,
                                                            surnameExpression <- owner.surname,
                                                            driverLicenseExpression <- owner.driverLicense,
                                                            passportExpression <- owner.passport,
                                                            phoneExpression <- owner.phone))
        } catch {
            print(">error owner updating error")
        }
    }
    
}


