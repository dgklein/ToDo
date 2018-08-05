//
//  ViewController.swift
//  ToDo
//
//  Created by Dara Klein on 7/22/18.
//  Copyright © 2018 Dara Klein. All rights reserved.
//
import UIKit
import RealmSwift

class ToDoVC: SwipeTableViewController {

var toDoItems: Results<Item>?
    
//var currentDate = Date() - didn't need to create ref.

let realm = try! Realm()

var selectedCategory: Category? {
    didSet {
        loadItems()
    }
    
}
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        tableView.rowHeight = 72.0
    }
    
    //MARK: - Model Manipulation Methods

    func loadItems() {
toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
    //MARK: - Delete Data from Swipe
    
    override func UpdateModel(at indexPath: IndexPath) {
        //will contact super and include print statement
        super.UpdateModel(at: indexPath)
        
        if let itemForDeletion = self.toDoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("Error deleting item: \(error)")
            }
            
            //tableView.reloadData()
        }
    }

    
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = super.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
    
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    //MARK: - TableView Delegates
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if let item = toDoItems?[indexPath.row] {
            do {
            try realm.write {
                //add whatever changes to item you want to make in db
                //realm.delete(item)
                item.done = !item.done
              
            }
        } catch {
            print("Error saving done status \(error)")
        }
    }
    tableView.reloadData()
    tableView.deselectRow(at: indexPath, animated: true)
}

    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what happens after button is pressed
            //Go over "Fetching Data in Realm 15:31
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                    //new obj
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                        
                    currentCategory.items.append(newItem)
                }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
             self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
//MARK: - Searchbar methods
extension ToDoVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
            searchBar.resignFirstResponder()
            
        }
    }
        
}

}






