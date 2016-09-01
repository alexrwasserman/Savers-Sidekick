//
//  CreateNewCategoryViewController.swift
//  Savers Sidekick
//
//  Created by Alex Wasserman on 8/22/16.
//  Copyright © 2016 Alex Wasserman. All rights reserved.
//

import UIKit
import CoreData

class CreateNewCategoryViewController: UIViewController, UITextFieldDelegate {
    
    var context: NSManagedObjectContext?
    
    var budgetContainedIn: Budget?

    @IBOutlet weak var enteredName: UITextField!
    @IBOutlet weak var enteredFunds: UITextField!
    
    @IBAction func buttonPressed(sender: UIButton) {
        context?.performBlockAndWait {
            _ = Category.categoryWithInfo(name: self.enteredName.text, totalFunds: self.enteredFunds.text, inBudget: self.budgetContainedIn, inContext: self.context!)
            try? self.context!.save()
        }
        
        performSegueWithIdentifier("returnToCategoriesFromCreateCategory", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enteredName.delegate = self
        enteredFunds.delegate = self
    }
    
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "returnToCategoriesFromCreateCategory" {
            if let categoriesController = segue.destinationViewController as? CategoriesTableViewController {
                categoriesController.context = context
                categoriesController.budgetContainedIn = budgetContainedIn
            }
        }
    }
    
    
    // MARK: - TextField Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == enteredName) {
            enteredFunds.becomeFirstResponder()
        }
        else {
            enteredFunds.resignFirstResponder()
        }
        
        return true
    }

}
