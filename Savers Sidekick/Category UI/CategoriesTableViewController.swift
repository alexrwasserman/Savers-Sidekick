//
//  CreateNewCategoriesTableViewController.swift
//  Savers Sidekick
//
//  Created by Alex Wasserman on 8/20/16.
//  Copyright © 2016 Alex Wasserman. All rights reserved.
//

import UIKit
import CoreData

class CategoriesTableViewController: CoreDataTableViewController {
    
    @IBAction func dismissView() {
        self.navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if let currentContext = CoreDataTableViewController.context, let currentBudget = currentBudget {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
            
            request.predicate = NSPredicate(format: "parentBudget.name = %@", currentBudget.name)
            request.sortDescriptors = [
                NSSortDescriptor(
                    key: "name",
                    ascending: true,
                    selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
                )
                
            ]
            
            fetchedResultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: currentContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
        }
        else {
            fetchedResultsController = nil
            NSLog("Unable to unwrap context or budget in CategoriesTableViewController")
        }
    }
    

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        if let categoryCell = cell as? CategoryTableViewCell {
            if let categoryToBeDisplayed = fetchedResultsController?.object(at: indexPath) as? Category {
                CoreDataTableViewController.context?.performAndWait {
                    categoryCell.category = categoryToBeDisplayed
                }
            }
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let categoryToBeDeleted = fetchedResultsController?.object(at: indexPath) as? Category {
                CoreDataTableViewController.context?.perform {
                    CoreDataTableViewController.context?.delete(categoryToBeDeleted)
                    try? CoreDataTableViewController.context!.save()
                }
            }
        }
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addCategory" {
            if let createCategoryController = segue.destination as? CreateNewCategoryViewController {
                createCategoryController.context = CoreDataTableViewController.context
                createCategoryController.currentBudget = currentBudget
            }
        }
        else if segue.identifier == "expensesOfSelectedCategory" {
            if let expensesController = segue.destination as? ExpensesTableViewController {
                if let categorySelected = sender as? CategoryTableViewCell {
                    expensesController.currentCategory = categorySelected.category
                }
            }
        }
    }
    
}
