//
//  ExpensesTableViewController.swift
//  Savers Sidekick
//
//  Created by Alex Wasserman on 8/28/16.
//  Copyright © 2016 Alex Wasserman. All rights reserved.
//

import UIKit
import CoreData

class ExpensesTableViewController: CoreDataTableViewController {

    var context: NSManagedObjectContext?
    
    var categoryContainedIn: Category?
    
    private func updateUI() {
        if let currentContext = context {
            if let validCategory = categoryContainedIn {
                let request = NSFetchRequest(entityName: "Expense")
                request.predicate = NSPredicate(format: "parentCategory.name = %@", validCategory.name!)
                request.sortDescriptors = [NSSortDescriptor(key: "name",
                    ascending: true,
                    selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
                fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                      managedObjectContext: currentContext,
                                                                      sectionNameKeyPath: nil,
                                                                      cacheName: "ExpenseScreenCache")
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
        let cell = tableView.dequeueReusableCellWithIdentifier("ExpenseCell", forIndexPath: indexPath)
        
        if let expenseCell = cell as? ExpenseTableViewCell {
            if let expenseToBeDisplayed = fetchedResultsController?.objectAtIndexPath(indexPath) as? Expense {
                context?.performBlockAndWait {
                    expenseCell.expense = expenseToBeDisplayed
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
        if segue.identifier == "addExpense" {
            if let createExpenseController = segue.destinationViewController as? CreateNewExpenseViewController {
                createExpenseController.context = context
                createExpenseController.categoryContainedIn = categoryContainedIn
            }
        }
        else if segue.identifier == "returnToCategoriesFromExpenses" {
            if let categoriesController = segue.destinationViewController as? CategoriesTableViewController {
                categoriesController.context = context
                categoriesController.budgetContainedIn = categoryContainedIn?.parentBudget
            }
        }
    }

}
