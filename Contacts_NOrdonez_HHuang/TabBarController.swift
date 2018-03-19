//
//  TabBarController.swift
//  Contacts_NOrdonez_HHuang
//
//  Created by Nil Ordoñez Romera on 14/3/18.
//  Copyright © 2018 NilHangjie. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    let dataBaseFileName = "contacts.db"
    var dataBasePath:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatabase()
        // Do any additional setup after loading the view.
    }
    
    func setupDatabase(){
        print("Hola")
        let fileManager = FileManager()
        if let dirDocument = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first{
            let dataBaseURL = dirDocument.appendingPathComponent(dataBaseFileName)
            dataBasePath = dataBaseURL.path
            
            //Create if not exists the database (users.db) or get the reference in dataBAsePath
            let userDB = FMDatabase(path: dataBasePath)
            
            let createStatement = """
            CREATE TABLE IF NOT EXISTS CONTACTS (
                ID INTEGER PRIMARY KEY,
                NAME TEXT,
                LASTNAME TEXT,
                NUM1 TEXT,
                NUM2 TEXT,
                EMAIL TEXT,
                ISFAV INTEGER)
            """
            
            if userDB.open(){
                if !userDB.executeStatements(createStatement){
                    print(userDB.lastError().localizedDescription)
                } else {
                    print("Se ha creado la bbdd")
                }
                
                
                do {
                    let rs = try userDB.executeQuery("SELECT COUNT(*) FROM CONTACTS", values: nil)
                    while rs.next() {
                        let currentData = rs.int(forColumnIndex: 0)
                        if currentData > 0 {
                            print("Ya existen datos, no se importan los datos de ejemplo")
                        } else {
                            //Añadimos datos de ejemplo para mostrar la aplicacion
                            insertDemoData(in: userDB)
                        }
                    
                    }
                } catch {
                    print("failed: \(error.localizedDescription)")
                }
                
        
                
                
                userDB.close()
            }else{
                print(userDB.lastError().localizedDescription)
            }
            
        }
    }
    
    func insertDemoData(in db: FMDatabase) {
        let demoInserts = [
        "INSERT INTO CONTACTS (ID, NAME, LASTNAME, NUM1, NUM2, EMAIL, ISFAV) VALUES (1, 'Nil', 'Ordoñez', '+34686764028', null, 'nilordonez.7@gmail.com', 0);",
        "INSERT INTO CONTACTS (ID, NAME, LASTNAME, NUM1, NUM2, EMAIL, ISFAV) VALUES (2, 'Juan', 'Palomo', '64737847', null, 'yomeloguiso@gmail.com', 0);",
        "INSERT INTO CONTACTS (ID, NAME, LASTNAME, NUM1, NUM2, EMAIL, ISFAV) VALUES (3, 'Maria', 'Manzanares', '4234243', null, 'mariamagdalena@gmail.com', 1);",
        "INSERT INTO CONTACTS (ID, NAME, LASTNAME, NUM1, NUM2, EMAIL, ISFAV) VALUES (4, 'Ramona', 'Ramirez', '94783783', null, 'jamones96@mail.com', 0);"
        ]
        
        for statement in demoInserts {
            do {
               try db.executeUpdate(statement, values: nil)
            } catch {
                print("Database insert errror: \(error)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
