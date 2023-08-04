//
//  DBSetting.swift
//  SqliteExample
//
//  Created by Kürşat Akyürek on 31.07.2023.
//

import Foundation
import SQLite3

final class DBSetting{
    let dbPath: String = "personelDB.sqlite"
    var db: OpaquePointer?
    
    init(){
        db = openDB()
        createTables()
        
        
        
    }
    
    func openDB() ->OpaquePointer?{
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dbPath)
        
        var dbPointer: OpaquePointer? = nil
        if sqlite3_open(filePath.path, &dbPointer) != SQLITE_OK{
            print("Error no connect db")
            return nil
        }else{
            return dbPointer
        }
    }
    
    func createTables(){
        let createTableString = "CREATE TABLE IF NOT EXISTS person(Id Integer PRIMARY KEY, name TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK{
            if sqlite3_step(createTableStatement) == SQLITE_DONE{
                print("Personel Table Created")
            }
            
        }else{
            print("Create Table Error statement")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func read() -> [PersonelModel]{
        var personel : [PersonelModel] = []
        let queryStatementString = "SELECT * FROM person;"
        var queryStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK{
            while sqlite3_step(queryStatement) == SQLITE_ROW{
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                
                personel.append(PersonelModel(id: Int(id), name: name))
            }
        }else{
            print("Error Read")
        }
        
        sqlite3_finalize(queryStatement)
        return personel
            
    }
    
    func insert(id: Int, name: String){
        let personel = read()
        for item in personel{
            if item.id == id{
                return
            }
        }
        
        let insertStatementString = "INSERT INTO person (id, name) VALUES (?,?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK{
            sqlite3_bind_int(insertStatement, 1, Int32(id))
            sqlite3_bind_text(insertStatement, 2, (name as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE{
                print("Success Add")
            }else{
                print("Error No Add")
            }
            sqlite3_finalize(insertStatement)
        }
    }
    
}



