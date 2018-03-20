//
//  ContactDetailViewController.swift
//  Contacts_NOrdonez_HHuang
//
//  Created by Nil Ordoñez Romera on 20/3/18.
//  Copyright © 2018 NilHangjie. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {


    var currentContact: Contact?

    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var number1Label: UILabel!
    @IBOutlet weak var num2Label: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        if let contact = currentContact {
            self.fullNameLabel.text = contact.fullName
            self.emailLabel.text = contact.email
            self.number1Label.text = contact.num1
            self.num2Label.text = contact.num2
            self.navigationItem.title = contact.fullName
        }

        // Do any additional setup after loading the view.
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
