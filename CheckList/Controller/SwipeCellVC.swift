//
//  SwipeCellVC.swift
//  CheckList
//
//  Created by HuangMing on 2018/3/28.
//  Copyright © 2018年 Fruit. All rights reserved.
//

import UIKit
import SwipeCellKit


class SwipeCellVC: UITableViewController, SwipeTableViewCellDelegate  {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.updateDeletion(with: indexPath)
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "TrashIcon")
        
        return [deleteAction]
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        
        options.expansionStyle = .destructive
        return options
    }
    
    func updateDeletion(with indexpath: IndexPath) {
        print("do something")
    }
    
  
}
