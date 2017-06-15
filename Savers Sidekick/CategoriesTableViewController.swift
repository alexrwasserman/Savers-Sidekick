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
    
    var context: NSManagedObjectContext?
    
    var budgetContainedIn: Budget?
    
    fileprivate func updateUI() {
        if let currentContext = context {
            if let validBudget = budgetContainedIn {
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
                request.predicate = NSPredicate(format: "parentBudget.name = %@", validBudget.name!)
                request.sortDescriptors = [NSSortDescriptor(key: "name",
                    ascending: true,
                    selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
                fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                      managedObjectContext: currentContext,
                                                                      sectionNameKeyPath: nil,
                                                                      cacheName: nil)
            }
        }
        else {
            fetchedResultsController = nil
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        updateUI()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        if let categoryCell = cell as? CategoryTableViewCell {
            if let categoryToBeDisplayed = fetchedResultsController?.object(at: indexPath) as? Category {
                context?.performAndWait {
                    categoryCell.category = categoryToBeDisplayed
                }
            }
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let categoryToBeDeleted = fetchedResultsController?.object(at: indexPath) as? Category {
                context?.perform {
                    self.context?.delete(categoryToBeDeleted)
                    try? self.context!.save()
                }
            }
        }
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addCategory" {
            if let createCategoryController = segue.destination as? CreateNewCategoryViewController {
                createCategoryController.context = context
                createCategoryController.budgetContainedIn = budgetContainedIn
            }
        }
        else if segue.identifier == "returnToBudgetsFromCategories" {
            if let budgetController = segue.destination as? BudgetsTableViewController {
                budgetController.context = context
            }
        }
        else if segue.identifier == "expensesOfSelectedCategory" {
            if let expensesController = segue.destination as? ExpensesTableViewController {
                if let categorySelected = sender as? CategoryTableViewCell {
                    expensesController.context = context
                    expensesController.categoryContainedIn = categorySelected.category
                }
            }
        }
    }
    

}
