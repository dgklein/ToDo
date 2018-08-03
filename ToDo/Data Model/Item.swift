//
//  Item.swift
//  ToDo
//
//  Created by Dara Klein on 7/29/18.
//  Copyright © 2018 Dara Klein. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
   @objc dynamic var dateCreated: Date?
    //inverse relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
