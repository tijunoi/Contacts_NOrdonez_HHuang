//
//  ViewController.swift
//  Contacts_NOrdonez_HHuang
//
//  Created by Nil Ordoñez Romera on 13/3/18.
//  Copyright © 2018 NilHangjie. All rights reserved.
//

import UIKit
import Hero

class ViewController: UIViewController {

    let dataBaseFileName = "contacts.db"
    var dataBasePath:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDataBase()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //Get documents device directory path and set to the dataBasePath property
    func setUpDataBase(){
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
                }
                userDB.close()
            }else{
                print(userDB.lastError().localizedDescription)
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

