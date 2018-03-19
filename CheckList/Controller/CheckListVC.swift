//
//  CheckListVC.swift
//  CheckList
//
//  Created by HuangMing on 2018/3/17.
//  Copyright © 2018年 Fruit. All rights reserved.
//

import UIKit

class CheckListVC: UITableViewController {
    
    var itemArray = [item]()
    let userDefaults = UserDefaults.standard
    let fileManagerPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let checkNib = UINib(nibName: "CheckCell", bundle: nil)
        self.tableView.register(checkNib, forCellReuseIdentifier: "CheckCell")
        
        loadingData()

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        // Configure the cell...
        cell.accessoryType = itemArray[indexPath.row].checkMark ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if itemArray[indexPath.row].checkMark == true {
            itemArray[indexPath.row].checkMark = false
        } else {
            itemArray[indexPath.row].checkMark = true
        }
        self.savingData(indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK: Button UI
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add a new item", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add item", style: UIAlertActionStyle.default) { (action) in
            if let newItemText = textfield.text, !newItemText.isEmpty {
                let newItem = item()
                newItem.title = newItemText
                self.itemArray.append(newItem)
                let index = self.itemArray.index(of: newItem)!
                let indexPath = IndexPath(row: index, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
                
                self.savingData(indexPath: indexPath)
            }
        }
        
        alert.addTextField { (alertTextfield) in
            textfield = alertTextfield
        }
        
        
        alert.addAction(cancel)
        alert.addAction(addAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: saving loading use FileManager PLE
    func savingData(indexPath: IndexPath) {
        let PLE = PropertyListEncoder()
        do {
            let data = try PLE.encode(itemArray)
            try data.write(to: fileManagerPath!)
        } catch {
            print(error.localizedDescription)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func loadingData() {
        let PLE = PropertyListDecoder()
        do {
            let data = try Data(contentsOf: fileManagerPath!)
            itemArray = try PLE.decode([item].self, from: data)
        } catch {
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
    
}









