//
//  CheckListVC.swift
//  CheckList
//
//  Created by HuangMing on 2018/3/17.
//  Copyright © 2018年 Fruit. All rights reserved.
//

import UIKit
import CoreData

class CheckListVC: UITableViewController {
    
    @IBOutlet weak var searchBarUI: UISearchBar!
    var itemArray = [Item]()
    var selecteCategory: Category? {
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
        itemArray[indexPath.row].checkMark = !itemArray[indexPath.row].checkMark
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        self.savingData()
        
        
        
    }
    //MARK: Button UI
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add a new item", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add item", style: UIAlertActionStyle.default) { (action) in
            if let newItemText = textfield.text, !newItemText.isEmpty {
                let newItem = Item(context: self.context)
                newItem.title = newItemText
                newItem.checkMark = false
                newItem.parentCategory = self.selecteCategory //coreData reference
                self.itemArray.append(newItem)
                let index = self.itemArray.index(of: newItem)!
                let indexPath = IndexPath(row: index, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
                self.savingData()
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
    func savingData() {
//        let PLE = PropertyListEncoder()
        do {
//            let data = try PLE.encode(itemArray)
//            try data.write(to: fileManagerPath!)
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadingData(with request: NSFetchRequest<Item> = Item.fetchRequest(), with predicate: NSPredicate? = nil) {
//        let PLE = PropertyListDecoder()
//        do {
//            let data = try Data(contentsOf: fileManagerPath!)
//            itemArray = try PLE.decode([item].self, from: data)
//        } catch {
//            print(error.localizedDescription)
//        }
        
        let selecteCategoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", (selecteCategory!.name!))
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [selecteCategoryPredicate, addtionalPredicate])
        } else {
            request.predicate = selecteCategoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
        self.tableView.reloadData()
    }
    
}

extension CheckListVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let itemTitlePredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBarUI.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadingData(with: request, with: itemTitlePredicate)
        
        
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







