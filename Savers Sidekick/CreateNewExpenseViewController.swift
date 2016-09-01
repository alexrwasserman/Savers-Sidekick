//
//  CreateNewExpenseViewController.swift
//  Savers Sidekick
//
//  Created by Alex Wasserman on 8/28/16.
//  Copyright © 2016 Alex Wasserman. All rights reserved.
//

import UIKit
import CoreData

class CreateNewExpenseViewController: UIViewController, UITextFieldDelegate {
    
    var context: NSManagedObjectContext?
    
    var categoryContainedIn: Category?

    @IBOutlet weak var enteredName: UITextField!
    @IBOutlet weak var enteredCost: UITextField!
    @IBOutlet weak var enteredDescription: UITextField!
    
    @IBAction func buttonPressed(sender: UIButton) {
        context?.performBlockAndWait {
            _ = Expense.expenseWithInfo(name: self.enteredName.text, cost: self.enteredCost.text, description: self.enteredDescription.text, inCategory: self.categoryContainedIn, inContext: self.context!)
            try? self.context!.save()
        }
        
        performSegueWithIdentifier("returnToExpensesFromCreateExpense", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enteredName.delegate = self
        enteredCost.delegate = self
        enteredDescription.delegate = self
    }
    

    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "returnToExpensesFromCreateExpense" {
            if let expensesController = segue.destinationViewController as? ExpensesTableViewController {
                expensesController.context = context
                expensesController.categoryContainedIn = categoryContainedIn
            }
        }
    }
    
    
    // MARK: - TextField Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == enteredName) {
            enteredCost.becomeFirstResponder()
        }
        else if (textField == enteredCost) {
            enteredDescription.becomeFirstResponder()
        }
        else {
            enteredDescription.resignFirstResponder()
        }
        
        return true
    }

}
