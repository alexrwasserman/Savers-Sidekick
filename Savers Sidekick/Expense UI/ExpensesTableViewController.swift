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
    
    @IBAction func dismissView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if let currentContext = CoreDataTableViewController.context, let currentCategory = currentCategory {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Expense")
            
            request.predicate = NSPredicate(format: "parentCategory.name = %@", currentCategory.name)
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
            NSLog("Unable to unwrap context or category in ExpensesTableViewController")
        }
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath)
        
        if let expenseCell = cell as? ExpenseTableViewCell {
            if let expenseToBeDisplayed = fetchedResultsController?.object(at: indexPath) as? Expense {
                CoreDataTableViewController.context?.performAndWait {
                    expenseCell.expense = expenseToBeDisplayed
                }
            }
        }
        
        return cell
    }
    
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let expenseToBeDeleted = fetchedResultsController?.object(at: indexPath) as? Expense {
                CoreDataTableViewController.context?.perform {
                    CoreDataTableViewController.context?.delete(expenseToBeDeleted)
                    try? CoreDataTableViewController.context!.save()
                }
            }
        }
     }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addExpense" {
            if let createExpenseController = segue.destination as? CreateNewExpenseViewController {
                createExpenseController.context = CoreDataTableViewController.context
                createExpenseController.currentCategory = currentCategory
            }
        }
        else if segue.identifier == "displayExpense" {
            if let displayExpenseController = segue.destination as? DisplayExpenseViewController {
                let index = (tableView.indexPathsForSelectedRows?.first)!
                let selectedExpenseCell = tableView.cellForRow(at: index) as! ExpenseTableViewCell
                displayExpenseController.expense = selectedExpenseCell.expense
            }
        }
    }

}
