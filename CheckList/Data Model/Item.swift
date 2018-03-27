//
//  Item.swift
//  CheckList
//
//  Created by HuangMing on 2018/3/26.
//  Copyright © 2018年 Fruit. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = "default"
    @objc dynamic var checkMark: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategoryList = LinkingObjects(fromType: CategoryList.self, property: "items")
}
