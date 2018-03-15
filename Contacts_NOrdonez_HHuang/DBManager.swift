//
//  DBManager.swift
//  Contacts_NOrdonez_HHuang
//
//  Created by Nil Ordoñez Romera on 15/3/18.
//  Copyright © 2018 NilHangjie. All rights reserved.
//

import UIKit

class DBManager: NSObject {
    //Creamos un singleton de la database
    static let shared: DBManager = DBManager()
    
    //Campos de la BBDD
    let field_ContactID = "ID"
    let field_ContactName = "NAME"
    let field_ContactLastName = "LASTNAME"
    let field_ContactNum1 = "NUM1"
    let field_ContactNum2 = "NUM2"
    let field_ContactEmail = "EMAIL"
    let field_ContactIsFav = "ISFAV"
    //-----------------
    
    let databaseFileName = "contacts.db"
    var pathToDatabase: String!
    var database: FMDatabase!
    
    override init() {
        super.init()
        let fileManager = FileManager()
        if let dirDocument = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first{
            let dataBaseURL = dirDocument.appendingPathComponent(databaseFileName)
            pathToDatabase = dataBaseURL.path
        }
    }

    func openDatabase() -> Bool {
        if database == nil {
            if FileManager.default.fileExists(atPath: pathToDatabase) {
                database = FMDatabase(path: pathToDatabase)
            }
        }
        
        if database != nil {
            if database.open() {
                return true
            }
        }
        
        return false
    }
    
    func getContacts() -> [Contact] {
        var contacts: [Contact]!

        if openDatabase(){
            let query: String = "SELECT * FROM CONTACTS ORDER BY \(field_ContactName) asc"

         
//            if let result = database.executeQuery(query, withArgumentsInArray: nil) {
//
//            }
            //No funciona con swift optionals, de momento lo hacemos con try catch
            do {
                let result = try database.executeQuery(query, values: nil)
                
                while result.next() {
                    
                    let isFavInt = result.int(forColumn: field_ContactIsFav)
                    var isFav: Bool
                    switch isFavInt{
                    case 0:
                        isFav = false
                    case 1:
                        isFav = true
                    default:
                        isFav = false
                    }
                    let contact = Contact(id: Int(result.int(forColumn: field_ContactID)), name: result.string(forColumn: field_ContactName), lastName: result.string(forColumn: field_ContactLastName), num1: result.string(forColumn: field_ContactNum1), num2: result.string(forColumn: field_ContactNum2), email: result.string(forColumn: field_ContactEmail), isFav: isFav)
                }
            } catch {
                print(error.localizedDescription)
            }

        }

        return contacts
    }
}
