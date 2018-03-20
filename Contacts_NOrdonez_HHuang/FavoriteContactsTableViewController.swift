//
//  FavoriteContactsTableViewController.swift
//  Contacts_NOrdonez_HHuang
//
//  Created by Nil Ordoñez Romera on 19/3/18.
//  Copyright © 2018 NilHangjie. All rights reserved.
//

import UIKit

class FavoriteContactsTableViewController: UITableViewController {

    var contacts: [Contact]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Se recargan los contactos cuando aparece en la pantalla para tener siempre la información actualizada
        contacts = DBManager.shared.getFavoriteContacts()
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
        // #warning Incomplete implementation, return the number of rows
        if let contactos = contacts {
            return contactos.count
        }
        return 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteContactCell", for: indexPath)

        let item = contacts?[indexPath.row]

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
            if var itemToRemoveFromFavorites = contacts?[indexPath.row] {
                itemToRemoveFromFavorites.isFav = false
                if DBManager.shared.updateContact(itemToRemoveFromFavorites) {
                    contacts?.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }

            }
            //Unwrappeo la array porque no se llamaría al método eliminar si no hubieran cells en la tableview, lo que significa que la array existe

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? UIViewController {
            if let cdvc = viewController as? ContactDetailViewController {
                if let sender = sender as? UITableViewCell {
                    let indexPath = tableView.indexPath(for: sender)!
                    cdvc.currentContact = contacts![indexPath.row]
                }
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
