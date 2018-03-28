//
//  Category.swift
//  CheckList
//
//  Created by HuangMing on 2018/3/26.
//  Copyright © 2018年 Fruit. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryList: Object {
    @objc dynamic var name: String = "Default list name"
    @objc dynamic var colorHex: String?
    let items = List<Item>()
    
    
}
