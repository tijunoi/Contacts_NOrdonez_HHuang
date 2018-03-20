//
//  Contact.swift
//  Contacts_NOrdonez_HHuang
//
//  Created by Nil Ordoñez Romera on 15/3/18.
//  Copyright © 2018 NilHangjie. All rights reserved.
//

import Foundation

struct Contact {
    var id: Int
    var name: String?
    var lastName: String?
    var num1: String?
    var num2: String?
    var email: String?
    var isFav: Bool?

    var fullName: String {
        return "\(name ?? "") \(lastName ?? "")"
    }
}
