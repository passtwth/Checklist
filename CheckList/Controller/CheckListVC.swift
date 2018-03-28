//
//  CheckListVC.swift
//  CheckList
//
//  Created by HuangMing on 2018/3/17.
//  Copyright © 2018年 Fruit. All rights reserved.
//

import UIKit

import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CheckListVC: SwipeCellVC {
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBarUI.delegate = self
        //searchBarUI.showsCancelButton = true
        
        let checkNib = UINib(nibName: "CheckCell", bundle: nil)
        self.tableView.register(checkNib, forCellReuseIdentifier: "CheckCell")
        
        tableView.rowHeight = 60

        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)) // filePath
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let selecteColor = HexColor(hexString: selecteCategory.colorHex!)
        
        guard let navigationBar = navigationController?.navigationBar else {
            fatalError("Error navigationBar")
        }
        navigationBar.barTintColor = selecteColor
        let contrastColor = ContrastColorOf(backgroundColor: selecteColor, returnFlat: true)
        navigationBar.tintColor = contrastColor
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: contrastColor]
        title = selecteCategory.name
        searchBarUI.barTintColor = selecteColor
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = itemArray?[indexPath.row].title ?? "Nothing list"
        // Configure the cell...
        
        let selectColor = HexColor(hexString: selecteCategory.colorHex!)
        let darken = selectColor.darken(byPercentage: CGFloat(indexPath.row) / CGFloat((itemArray?.count)!) )
        //print("\(CGFloat(indexPath.row) / CGFloat((itemArray?.count)!))")
        cell.backgroundColor = darken
        cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: darken, isFlat: true)
        cell.accessoryType = itemArray![indexPath.row].checkMark ? .checkmark : .none
        
        return cell
    }

    override func updateDeletion(with indexpath: IndexPath) {
        let delection = {
            self.realm.delete(self.selecteCategory.items[indexpath.row])
        }
        doTryRealmData(complete: delection)
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
    
    //MARK: saving loading
    
    
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







