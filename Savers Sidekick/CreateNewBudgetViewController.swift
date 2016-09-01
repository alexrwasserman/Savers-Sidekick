//
//  CreateNewBudgetViewController.swift
//  Savers Sidekick
//
//  Created by Alex Wasserman on 8/15/16.
//  Copyright © 2016 Alex Wasserman. All rights reserved.
//

import UIKit
import CoreData

class CreateNewBudgetViewController: UIViewController, UITextFieldDelegate {
    
    var context: NSManagedObjectContext?

    @IBOutlet weak var enteredName: UITextField!
    @IBOutlet weak var enteredFunds: UITextField!

    @IBAction func buttonPressed(sender: UIButton) {
        context?.performBlockAndWait {
            _ = Budget.budgetWithInfo(name: self.enteredName.text, totalFunds: self.enteredFunds.text, inContext: self.context!)
            try? self.context!.save()
        }
        
        performSegueWithIdentifier("returnToBudgetsFromCreateBudget", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enteredName.delegate = self
        enteredFunds.delegate = self
    }

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "returnToBudgetsFromCreateBudget" {
            if let budgetsController = segue.destinationViewController as? BudgetsTableViewController {
                budgetsController.context = context
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
