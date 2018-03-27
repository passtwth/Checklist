//
//  CheckListVC.swift
//  CheckList
//
//  Created by HuangMing on 2018/3/17.
//  Copyright © 2018年 Fruit. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CheckListVC: UITableViewController {
    
    @IBOutlet weak var searchBarUI: UISearchBar!
    var itemArray: Results<Item>?
    let realm = try! Realm()
    var selecteCategory: CategoryList! {
        didSet {
            loadingData()
        }
    }
    //let userDefaults = UserDefaults.standard
    //let fileManagerPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBarUI.delegate = self
        searchBarUI.showsCancelButton = true
        
        let checkNib = UINib(nibName: "CheckCell", bundle: nil)
        self.tableView.register(checkNib, forCellReuseIdentifier: "CheckCell")
        
        

        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)) // filePath
        
    }
   
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckCell", for: indexPath)
        cell.textLabel?.text = itemArray?[indexPath.row].title ?? "Nothing list"
        // Configure the cell...
        cell.accessoryType = itemArray![indexPath.row].checkMark ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let changeCheckMark = {
            self.selecteCategory.items[indexPath.row].checkMark = !(self.selecteCategory.items[indexPath.row].checkMark)
        }
        doTryRealmData(complete: changeCheckMark)
        
        tableView.reloadRows(at: [indexPath], with: .fade)
        tableView.deselectRow(at: indexPath, animated: true)
        //self.savingData()
        
        
    }
    //MARK: Button UI
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add a new item", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add item", style: UIAlertActionStyle.default) { (action) in
            if let newItemText = textfield.text, !newItemText.isEmpty {
          
                let addNewItem = {
                    let newItem = Item()
                    newItem.title = newItemText
                    newItem.dateCreated = Date()
                    self.selecteCategory.items.append(newItem)
                    self.tableView.reloadData()
                }
                self.doTryRealmData(complete: addNewItem)
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
    
    
    func loadingData() {
        itemArray = selecteCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        
    }
    
    func doTryRealmData(complete: () -> ()) {
        do {
            try realm.write {
                complete()
            }
        } catch {
            print("do try realm error")
        }
    }
    
}

extension CheckListVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        itemArray = itemArray?.filter("title CONTAINS[cd]", searchBarUI.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
        
    }
    /*
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadingData()
        DispatchQueue.main.async {
            self.searchBarUI.resignFirstResponder()
        }
    }
    */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadingData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}







