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
        print("dismissView() - CTVC")
        self.navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        print("viewDidLoad() - CTVC")
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if let currentContext = CoreDataTableViewController.context {
            if let validBudget = currentBudget {
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
                request.predicate = NSPredicate(format: "parentBudget.name = %@", validBudget.name)
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
    

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("tableView(cellForRowAt) - CTVC")
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
        print("tableView(editingStyle) - CTVC")
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
        print("prepareForSegue() - CTVC")
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
    
    
    // MARK: - File creation
    
    fileprivate func createCSVFile() -> Bool {
        let fileName = "SaversSidekickBudget.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName, isDirectory: false)
        
        var fileContent = "Category,Expense,Amount,Date,Description\n"
        
        if let categories = currentBudget?.categories {
            for categoryItem in categories {
                let category = categoryItem as! Category
                fileContent += "\(String(describing: category.name)),,,,\n"
                
                for expenseItem in category.expenses {
                    let expense = expenseItem as! Expense
                    fileContent += ",\(String(describing: expense.name)),\(expense.description),"
                    fileContent += "\(String(describing: expense.date)),\(String(describing: expense.humanDescription))\n"
                }
                
                fileContent += ",TOTAL:,\(category.totalExpensesDescription),,\n"
                fileContent += ",ALLOTTED:,\(category.totalFundsDescription),,\n"
                
                let difference = performArithmetic(firstTermDollars: category.totalFundsDollars,
                                                   firstTermCents: category.totalFundsCents,
                                                   secondTermDollars: category.totalExpensesDollars,
                                                   secondTermCents: category.totalExpensesCents,
                                                   operation: Operation.subtraction)
                let differenceStr = "\(difference.0)" + "." + "\(difference.1)"
                
                fileContent += ",DIFFERENCE:,\(differenceStr),,\n"
                fileContent += ",,,,\n"
            }
        }
        
        do {
            try fileContent.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
        }
        catch {
            NSLog("%@", "Failed to create the file")
            NSLog("%@", "\(error)")
            return false
        }
        
        return true
    }
}
