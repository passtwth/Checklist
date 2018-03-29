//
//  CategoryVC.swift
//  CheckList
//
//  Created by HuangMing on 2018/3/24.
//  Copyright © 2018年 Fruit. All rights reserved.
//

import UIKit

import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CategoryVC: SwipeCellVC {
    
    let realm = try! Realm()
    var firstLaunchScreen = false
    var category: Results<CategoryList>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "CheckCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CheckCell")
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        
        loadingCategory()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        launchScreen(firstLaunch: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return category?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = category?[indexPath.row].name ?? "Nothing category"
        
        
        if category![indexPath.row].colorHex != nil {
            let thatColor = HexColor(hexString: category![indexPath.row].colorHex!)
            cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: thatColor, isFlat: true)
            cell.backgroundColor = thatColor
        }
        
        
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let index = tableView.indexPathForSelectedRow
        if category == nil {
            
        } else {
            performSegue(withIdentifier: "itemSegue", sender: indexPath)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func updateDeletion(with indexpath: IndexPath) {
        do {
            try realm.write {
                realm.delete(category![indexpath.row])
            }

        } catch { print("Delete error") }
    }
    
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        let newCategory = CategoryList()
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Category", message: "Enter New category name", preferredStyle: .alert)
        let add = UIAlertAction(title: "Add", style: .default) { (action) in
            guard !(textField.text!.isEmpty) else {
                return
            }
            newCategory.name = textField.text!
            let randomColor = UIColor.randomFlat()
            let randomColorHexValue = UIColor.hexValue(randomColor!)
            newCategory.colorHex = randomColorHexValue()
            
            self.saveCategory(with: newCategory)
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
    
    func launchScreen(firstLaunch: Bool) {
        guard !firstLaunchScreen else {
            return
        }
        firstLaunchScreen = firstLaunch
        let window = UIScreen.main.bounds
        let launchView = UIView(frame: window)
        launchView.backgroundColor = UIColor.flatWhite()
        self.navigationController?.view.addSubview(launchView)
    
        let windowWidth = UIScreen.main.bounds.width
        let windowHeight = UIScreen.main.bounds.height
        
        
        let label = UILabel(frame: CGRect(origin: CGPoint(x: (windowWidth / 2) - 125, y: (windowHeight / 2) ), size: CGSize(width: 250, height: 50)))
        label.center = CGPoint(x: window.midX, y: window.midY)
        
        let label2 = UILabel(frame: CGRect(origin: CGPoint(x: (windowWidth / 2) - 125, y: (windowHeight / 2) - 50 ), size: CGSize(width: 250, height: 50)))
        label2.center = CGPoint(x: window.midX, y: window.midY - 50)
        
        
        
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black
        shadow.shadowBlurRadius = 5
        
        
        let mutable = NSMutableAttributedString(string: "CheckList Demo", attributes: [NSAttributedStringKey.foregroundColor: UIColor.flatBlack()])
        label.attributedText = mutable
        launchView.addSubview(label)
        
        UIView.animateKeyframes(withDuration: 2.0, delay: 1.0, animations: {
            launchView.alpha = 0
        }, completion: { (bool) in
            
        })
        
        
        
    }
    
}

