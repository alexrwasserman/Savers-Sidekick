//
//  BudgetScreenTableViewController.swift
//  Savers Sidekick
//
//  Created by Alex Wasserman on 8/15/16.
//  Copyright © 2016 Alex Wasserman. All rights reserved.
//

import UIKit
import CoreData

class BudgetsTableViewController: CoreDataTableViewController {
    
    var context = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext
    
    fileprivate func updateUI() {
        if let currentContext = context {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Budget")
            request.sortDescriptors = [NSSortDescriptor(key: "name",
                                                        ascending: true,
                                                        selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                  managedObjectContext: currentContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "BudgetCell", for: indexPath)

        if let budgetCell = cell as? BudgetTableViewCell {
            if let budgetToBeDisplayed = fetchedResultsController?.object(at: indexPath) as? Budget {
                context?.performAndWait {
                    budgetCell.budget = budgetToBeDisplayed
                }
            }
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let budgetToBeDeleted = fetchedResultsController?.object(at: indexPath) as? Budget {
                context?.perform {
                    self.context?.delete(budgetToBeDeleted)
                    try? self.context!.save()
                }
            }
        }
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addBudget" {
            if let createBudgetController = segue.destination as? CreateNewBudgetViewController {
                createBudgetController.context = context
            }
        }
        else if segue.identifier == "categoriesOfSelectedBudget" {
            if let categoriesController = segue.destination as? CategoriesTableViewController {
                if let budgetSelected = sender as? BudgetTableViewCell {
                    categoriesController.context = context
                    categoriesController.budgetContainedIn = budgetSelected.budget
                }
            }
        }
    }
    

}
