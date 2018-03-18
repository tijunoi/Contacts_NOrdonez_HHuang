//
//  AllContactsTableViewController.swift
//  Contacts_NOrdonez_HHuang
//
//  Created by Nil Ordoñez Romera on 13/3/18.
//  Copyright © 2018 NilHangjie. All rights reserved.
//

import UIKit

class AllContactsTableViewController: UITableViewController {

    var contacts: [Contact]?

    //Para insertar el nuevo coo cuando vuelva de new contact
    var newContact: Contact?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("se ha conectado la view")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        contacts = DBManager.shared.getContacts()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of row
        if let count = contacts?.count {
            return count
        }
        return 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllContactCell", for: indexPath)

        let item = contacts?[indexPath.row]

        // let item: Contact = //contactManager.getContacts()[indexPath.row]
        // Configure the cell...
        // Update contact name
        cell.textLabel?.text = item?.fullName
        // Update phone number
        cell.detailTextLabel?.text = item?.num1
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if let itemToRemove = contacts?[indexPath.row] {
                if DBManager.shared.deleteContact(itemToRemove) { //Solo se borra en la tableview si se ha borrado correctament en la bd, sino peta
                    contacts?.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
            //Unwrappeo la array porque no se llamaría al método eliminar si no hubieran cells en la tableview, lo que significa que la array existe

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    @IBAction func backFromNewContact(segue: UIStoryboardSegue){
        if let aNewContact = newContact {
            //settear a nil para asignar luego otro new contact, sino se insertaria siempre el mismo
            self.newContact = nil

            if DBManager.shared.insertContact(aNewContact) {
                contacts = DBManager.shared.getContacts()
                tableView.reloadData()
            }
        }
    }
    
    


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
