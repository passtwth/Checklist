//
//  CategoryVC.swift
//  CheckList
//
//  Created by HuangMing on 2018/3/24.
//  Copyright © 2018年 Fruit. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryVC: UITableViewController {
    
    let realm = try! Realm()
    
    var category: Results<CategoryList>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let checkNib = UINib(nibName: "CheckCell", bundle: nil)
        self.tableView.register(checkNib, forCellReuseIdentifier: "CheckCell")
        
        loadingCategory()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        do {
            try realm.write {
                realm.delete(category![indexPath.row])
            }
        } catch {
            print("delete error")
        }
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.top)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return category?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckCell")
        cell?.textLabel?.text = category?[indexPath.row].name ?? "Nothing category"
        
        return cell!
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let index = tableView.indexPathForSelectedRow
        if category == nil {
            
        } else {
            performSegue(withIdentifier: "itemSegue", sender: indexPath)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        let newCateGory = CategoryList()
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Category", message: "Enter New category name", preferredStyle: .alert)
        let add = UIAlertAction(title: "Add", style: .default) { (action) in
            guard !(textField.text!.isEmpty) else {
                return
            }
            newCateGory.name = textField.text!
            self.saveCategory(with: newCateGory)
        }
        alert.addTextField { (alerTextField) in textField = alerTextField }
        alert.addAction(add)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
    }
    func loadingCategory() {
        category = realm.objects(CategoryList.self)
        
    }
    func saveCategory(with object: CategoryList? = nil) {
        do {
            try realm.write {
                realm.add(object!)
            }
        } catch {
            print("save category error")
        }
        tableView.reloadData()

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let desVC = segue.destination as! CheckListVC
        let selecteIndexPath = sender as! IndexPath
        desVC.selecteCategory = category![selecteIndexPath.row]
        
    }
    
}
