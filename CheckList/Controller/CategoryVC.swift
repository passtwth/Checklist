//
//  CategoryVC.swift
//  CheckList
//
//  Created by HuangMing on 2018/3/24.
//  Copyright © 2018年 Fruit. All rights reserved.
//

import UIKit
import CoreData

class CategoryVC: UITableViewController {
    
   let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var category = [Category]()
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return category.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckCell")
        cell?.textLabel?.text = category[indexPath.row].name
        return cell!
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "itemSegue", sender: indexPath)
    }
    
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        let newCateGory = Category(context: self.context)
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Category", message: "Enter New category name", preferredStyle: .alert)
        let add = UIAlertAction(title: "Add", style: .default) { (action) in
            guard !(textField.text!.isEmpty) else {
                return
            }
            newCateGory.name = textField.text!
            self.category.append(newCateGory)
            //self.tableView.reloadData()
            let index = self.category.index(of: newCateGory)!
            let indexPath = IndexPath(row: index, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            self.saveCategory()
        }
        alert.addTextField { (alerTextField) in textField = alerTextField }
        alert.addAction(add)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
    }
    func loadingCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            category = try context.fetch(request)
        } catch {
            print("error fetch category")
        }
    }
    func saveCategory() {
        do {
            try context.save()
        } catch {
            print("error save category")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let desVC = segue.destination as! CheckListVC
        let selecteIndexPath = sender as! IndexPath
        desVC.selecteCategory = category[selecteIndexPath.row]
    }
    
}
