//OVERVIEW OF STEPS
//    Set up array of categoryItems
//    tap into the context
//    set up tableview to load the data from the context
//    Use ibaction addbuttonpressed to add new Categories into the tableview - to add new categories
//    use saveItems to persist our items inside our container in data manipulation
//    load those items from persistent container using our context under data manipulation
//
//  Created by Dara Klein on 7/23/18.
//  Copyright © 2018 Dara Klein. All rights reserved.

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryVC: UITableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadData()
        tableView.rowHeight = 72.0
    }
    
// MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //nil coalescing Operator
        return categories?.count ?? 1
        
    }
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //let category = categories![indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell")
 as! SwipeTableViewCell
        

        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added"
        //then render on screen
   
        cell.delegate = self
        
        return cell
    }

    //MARK: - TableView Delgate Methods - Clicking Rows - DO LAST
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
 performSegue(withIdentifier: "goToItems", sender: self)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //MAKE NOTE OF
        let destinationVC = segue.destination as! ToDoVC
        //optional - add if let for when it's not nil
        
        if let indexPath = tableView.indexPathForSelectedRow {
       //create property inside ToDoVC 
        destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }

//MARK: - Data Manipulation Methods
    
    func loadData() {
    //pull out all category objs out of realm
        categories = realm.objects(Category.self)
      
        tableView.reloadData()
    }
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        tableView.reloadData()
    }
    

//MARK: - Add New Categories
@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    var textField = UITextField()
    
    //Top of Alert Controller
    let alert = UIAlertController(title: "**Create Category**", message: "", preferredStyle: .alert)
   
    //Selected Actions Available
    let action2 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
    let action = UIAlertAction(title: "Add", style: .default) { (action) in
//what happens when you press + //Configure array and db
       
        let newCategory = Category()
    
        newCategory.name = textField.text!
    
        self.save(category: newCategory)
       
    }
    
    //GO OVER - Configure Textfield placeholder and assign to textfield refs
   alert.addAction(action)
    
    alert.addAction(action2)
    
    alert.addTextField { (alertTextField) in
        
        alertTextField.placeholder = "Create New Category"
    
        textField = alertTextField
    }

    present(alert, animated: true, completion: nil)
}
    
}
//MARK: - SwipeCell Delegate Method
extension CategoryVC: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            // handle action by updating model with deletion
            if let categoryForDeletion = self.categories?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(categoryForDeletion)
                    }
                } catch {
                    print("Error deleting item: \(error)")
                }
                
                //tableView.reloadData()
            }
            
     
    }
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}
