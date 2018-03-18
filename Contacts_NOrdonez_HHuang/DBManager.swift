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
        if let dirDocument = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
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
        var contacts: [Contact]! = [Contact]()

        if openDatabase() {
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
                    switch isFavInt {
                    case 0:
                        isFav = false
                    case 1:
                        isFav = true
                    default:
                        isFav = false
                    }
                    let contact = Contact(id: Int(result.int(forColumn: field_ContactID)),
                            name: result.string(forColumn: field_ContactName),
                            lastName: result.string(forColumn: field_ContactLastName),
                            num1: result.string(forColumn: field_ContactNum1),
                            num2: result.string(forColumn: field_ContactNum2),
                            email: result.string(forColumn: field_ContactEmail),
                            isFav: isFav)

                   /* if contacts == nil {
                        contacts = [Contact]()
                    }*/
                    contacts.append(contact)
                }
            } catch {
                print(error.localizedDescription)
            }
            database.close()
        }

        return contacts
    }

    func deleteContact(_ contactToRemove: Contact) -> Bool {

        if openDatabase() {
            let query: String = "DELETE FROM CONTACTS WHERE \(field_ContactID)=?"

            //Borramos el contacto con id que se le pase
            if !database.executeUpdate(query, withArgumentsIn: [contactToRemove.id]) {
                print(database.lastError().localizedDescription)
                database.close()
                return false
            }
            database.close()
        }

        return true
    }


    func deleteContact(withId: Int) -> Bool {

        if openDatabase() {
            let query: String = "DELETE FROM CONTACTS WHERE \(field_ContactID)=?"

            //Borramos el contacto con id que se le pase
            if !database.executeUpdate(query, withArgumentsIn: [withId]) {
                print(database.lastError().localizedDescription)
                database.close()
                return false
            }
            database.close()
        }

        return true
    }

    func insertContact(_ contact: Contact) -> Bool {
        if openDatabase() {
            let query: String = "INSERT INTO CONTACTS (\(field_ContactName) , \(field_ContactLastName),\(field_ContactNum1), \(field_ContactNum2), \(field_ContactEmail), \(field_ContactIsFav)) VALUES (?,?,?,?,?,?)"
            let favInt = contact.isFav! ? 1 : 0
            do {
                try database.executeUpdate(query, values: [
                    contact.name,
                    contact.lastName,
                    contact.num1,
                    contact.num2,
                    contact.email,
                    favInt
                ])
            } catch {
                print(error.localizedDescription)
                database.close()
                return false
            }
            database.close()
        }
        return true
    }

    func updateContact(_ contact: Contact) -> Bool {
        if openDatabase() {
            let queryUpdate = "UPDATE CONTACTS SET \(field_ContactName) = ? , \(field_ContactLastName) = ? , \(field_ContactNum1) = ? , \(field_ContactNum2) = ? , \(field_ContactEmail) = ? , \(field_ContactIsFav) = ? WHERE \(field_ContactID) = ?"
            let favInt = contact.isFav! ? 1 : 0
            do {
                try database.executeUpdate(queryUpdate, values: [
                    contact.name,
                    contact.lastName,
                    contact.num1,
                    contact.num2,
                    contact.email,
                    favInt,
                    contact.id
                ])
            } catch {
                print(error.localizedDescription)
                database.close()
                return false
            }
            database.close()
        }
        return true
    }

    func getContact(withId: Int) -> Contact? {
        let query = "SELECT * FROM CONTACTS WHERE \(field_ContactID) = ?"

        if openDatabase() {
            defer { //Defer es como el finally de un try catch, pero para cualquier bloque. Se ejecuta despues de acabar el bloque de código. Así no hay que llamar varias veces database.close()
                database.close()
            }
            let contact: Contact?
            do {
                let result = try database.executeQuery(query, values: [withId])
                if result.next() {
                    let isFavInt = result.int(forColumn: field_ContactIsFav)
                    let isFav: Bool
                    switch isFavInt {
                    case 0:
                        isFav = false
                    case 1:
                        isFav = true
                    default:
                        isFav = false
                    }
                    contact = Contact(id: Int(result.int(forColumn: field_ContactID)),
                            name: result.string(forColumn: field_ContactName),
                            lastName: result.string(forColumn: field_ContactLastName),
                            num1: result.string(forColumn: field_ContactNum1),
                            num2: result.string(forColumn: field_ContactNum2),
                            email: result.string(forColumn: field_ContactEmail),
                            isFav: isFav)

                } else {
                    contact = nil
                }
            } catch {
                print(error.localizedDescription)
                contact = nil
            }
        }
        return nil
    }
}
