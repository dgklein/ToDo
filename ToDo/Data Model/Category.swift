//
//  Category.swift
//  ToDo
//
//  Created by Dara Klein on 7/29/18.
//  Copyright © 2018 Dara Klein. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    //forward relationship
    let items = List<Item>()
}
