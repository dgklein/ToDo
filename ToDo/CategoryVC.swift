//OVERVIEW OF STEPS
//    Set up array of items
//    tap into context
//    set up tableview to load the data from the context
//    Use ibaction addbuttonpressed to add new items into the tableview - to add new categories
//    use saveItems to persist our items inside our container in data manipulation
//    load those items from persistent container using context under data manipulation
//
//  Created by Dara Klein on 7/23/18.
//  Copyright © 2018 Dara Klein. All rights reserved.

import UIKit
import CoreData

class CategoryVC: UITableViewController {
    
    var categoryArray = [Category]()
 
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadData()
    }
    
// MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categoryArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)

        cell.textLabel?.text = category.name
        
        //then render on screen
        return cell
    }
    
    //MARK: - TableView Delgate Methods - Clicking Rows - DO LAST
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
 performSegue(withIdentifier: "goToItems", sender: self)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //MAKE NOTE OF:
        let destinationVC = segue.destination as! ToDoVC
        //optional - add if let for when it's not nil
        if let indexPath = tableView.indexPathForSelectedRow {
       //create property inside ToDoVC
        destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }

//MARK: - Data Manipulation Methods
    func loadData() {
        let request:NSFetchRequest<Category> = Category.fetchRequest()
        do {
           categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data \(error)")
        }
        tableView.reloadData()
    }
    
    func saveData() {
        do {
        try context.save()
        } catch {
            print("Error saving data \(error)")
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
       
        let newCategory = Category(context: self.context)
        
        newCategory.name = textField.text!
        
        self.categoryArray.append(newCategory)
        
        self.saveData()
       
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
