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
    
    var savedToolbarItems: [UIBarButtonItem]? = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if let currentContext = CoreDataTableViewController.context {
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
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        if(!editing && tableView.allowsMultipleSelectionDuringEditing == true) {
            if tableView.indexPathsForSelectedRows == nil {
                tableView.allowsMultipleSelectionDuringEditing = false
                
                self.navigationItem.leftBarButtonItem = nil
                self.setToolbarItems(self.savedToolbarItems, animated: true)
                
                super.setEditing(editing, animated: animated)
                return
            }
            
            var fileURLs: [URL] = []
            for index in tableView.indexPathsForSelectedRows! {
                let selectedCell = tableView.cellForRow(at: index)
                if let selectedBudget = selectedCell as? BudgetTableViewCell {
                    let budget = selectedBudget.budget!
                    
                    let fileName = budget.name + ".csv"
                    let path = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName, isDirectory: false)
                    
                    if budget.createCSVFile(path: path) {
                        fileURLs.append(path)
                    }
                }
                else {
                    NSLog("Could not cast UITableViewCell to BudgetTableViewCell")
                    NSLog("%@", selectedCell.debugDescription)
                }
            }
            
            let activityVC = UIActivityViewController(activityItems: fileURLs, applicationActivities: nil)
            activityVC.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
                for fileURL in fileURLs {
                    do {
                        try FileManager.default.removeItem(at: fileURL)
                        NSLog("Successfully deleted file: %@", fileURL.lastPathComponent)
                    }
                    catch {
                        NSLog("Failed to delete file: %@", fileURL.lastPathComponent)
                        NSLog("%@", "\(error)")
                    }
                }
            }
            present(activityVC, animated: true, completion: nil)
            
            tableView.allowsMultipleSelectionDuringEditing = false
            self.navigationItem.leftBarButtonItem = nil
            self.setToolbarItems(self.savedToolbarItems, animated: true)
        }
        
        super.setEditing(editing, animated: animated)
    }


    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BudgetCell", for: indexPath)

        if let budgetCell = cell as? BudgetTableViewCell {
            if let budgetToBeDisplayed = fetchedResultsController?.object(at: indexPath) as? Budget {
                CoreDataTableViewController.context?.performAndWait {
                    budgetCell.budget = budgetToBeDisplayed
                }
            }
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            if let budgetToBeDeleted = fetchedResultsController?.object(at: indexPath) as? Budget {
                CoreDataTableViewController.context?.perform {
                    CoreDataTableViewController.context?.delete(budgetToBeDeleted)
                    try? CoreDataTableViewController.context!.save()
                }
            }
        }
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addBudget" {
            if let createBudgetController = segue.destination as? CreateNewBudgetViewController {
                createBudgetController.context = CoreDataTableViewController.context
            }
        }
        else if segue.identifier == "categoriesOfSelectedBudget" {
            if let categoriesController = segue.destination as? CategoriesTableViewController {
                if let budgetSelected = sender as? BudgetTableViewCell {
                    categoriesController.currentBudget = budgetSelected.budget
                }
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return !tableView.allowsMultipleSelectionDuringEditing
    }


    // MARK: - CSV File Creation
    
    @IBAction func budgetActions(_ sender: UIBarButtonItem) {
        
        let budgetAlertController = UIAlertController(title: "Budget Actions", message: nil, preferredStyle: .actionSheet)
        
        let exportCSVAction = UIAlertAction(title: "Export .csv Files", style: .default) { _ in
            self.tableView.allowsMultipleSelectionDuringEditing = true
            
            self.setEditing(true, animated: true)
            
            self.editButtonItem.title = "Export"
            
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelExport(_:)))
            self.navigationItem.leftBarButtonItem = cancelButton
            
            self.savedToolbarItems = self.toolbarItems
            self.setToolbarItems(nil, animated: true)
        }
        
        let viewSummaryAction = UIAlertAction(title: "View Summary", style: .default) { _ in
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            
        }
        
        budgetAlertController.addAction(exportCSVAction)
        budgetAlertController.addAction(viewSummaryAction)
        budgetAlertController.addAction(cancelAction)
        
        present(budgetAlertController, animated: true, completion: nil)
    }
    
    @IBAction func cancelExport(_ sender: UIBarButtonItem) {
        tableView.allowsMultipleSelectionDuringEditing = false
        
        self.setEditing(false, animated: true)
        
        self.navigationItem.leftBarButtonItem = nil
        self.setToolbarItems(self.savedToolbarItems, animated: true)
    }
    
}
