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
    
    private func updateUI() {
        if let currentContext = context {
            if let validBudget = budgetContainedIn {
                let request = NSFetchRequest(entityName: "Category")
                request.predicate = NSPredicate(format: "parentBudget.name = %@", validBudget.name!)
                request.sortDescriptors = [NSSortDescriptor(key: "name",
                    ascending: true,
                    selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
                fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                      managedObjectContext: currentContext,
                                                                      sectionNameKeyPath: nil,
                                                                      cacheName: "CategoryScreenCache")
            }
        }
        else {
            fetchedResultsController = nil
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        updateUI()
    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath)

        if let categoryCell = cell as? CategoryTableViewCell {
            if let categoryToBeDisplayed = fetchedResultsController?.objectAtIndexPath(indexPath) as? Category {
                context?.performBlockAndWait {
                    categoryCell.category = categoryToBeDisplayed
                }
            }
        }

        return cell
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addCategory" {
            if let createCategoryController = segue.destinationViewController as? CreateNewCategoryViewController {
                createCategoryController.context = context
                createCategoryController.budgetContainedIn = budgetContainedIn
            }
        }
        else if segue.identifier == "returnToBudgetsFromCategories" {
            if let budgetController = segue.destinationViewController as? BudgetsTableViewController {
                budgetController.context = context
            }
        }
        else if segue.identifier == "expensesOfSelectedCategory" {
            if let expensesController = segue.destinationViewController as? ExpensesTableViewController {
                if let categorySelected = sender as? CategoryTableViewCell {
                    expensesController.context = context
                    expensesController.categoryContainedIn = categorySelected.category
                }
            }
        }
    }
    

}
