//
//  DataBaseConnection.swift
//  CarService
//
//  Created by Egor on 18.11.2017.
//  Copyright © 2017 Egor. All rights reserved.
//

import Foundation
import SQLite

final class DataBase{
    
    static let shared = DataBase()
    
    private init(){
        
    }
    
    //1 - может упасть
    var connection = try! Connection("\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!)/db.sqlite3")
    //2 - еботня опциональная
    func connect() -> Connection?{
        do{
            return try Connection("\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!)/db.sqlite3")
        } catch{
            print("Can't connect to data base \(error.localizedDescription)")
        }

        print("Can't connect to data base (error2)")
        return nil
    }
}
