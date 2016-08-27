//
//  BudgetScreenTableViewController.swift
//  Savers Sidekick
//
//  Created by Alex Wasserman on 8/15/16.
//  Copyright © 2016 Alex Wasserman. All rights reserved.
//

import UIKit
import CoreData

class BudgetScreenTableViewController: CoreDataTableViewController {
    
    var context = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    func updateUI() {
        if let currentContext = context {
            let request = NSFetchRequest(entityName: "Budget")
            request.sortDescriptors = [NSSortDescriptor(key: "name",
                                                        ascending: true,
                                                        selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                  managedObjectContext: currentContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: "BudgetScreenCache")
        }
        else {
            fetchedResultsController = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        updateUI()
    }


    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BudgetCell", forIndexPath: indexPath)

        if let budgetCell = cell as? BudgetTableViewCell {
            if let budgetToBeDisplayed = fetchedResultsController?.objectAtIndexPath(indexPath) as? Budget {
                context?.performBlockAndWait {
                    budgetCell.budget = budgetToBeDisplayed
                }
            }
        }

        return cell
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            if let budgetToBeDeleted = fetchedResultsController?.objectAtIndexPath(indexPath) as? Budget {
                context?.performBlock {
                    self.context?.deleteObject(budgetToBeDeleted)
                    try? self.context!.save()
                }
            }
        }
    }

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
