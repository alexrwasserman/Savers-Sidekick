//
//  CreateNewBudgetViewController.swift
//  Savers Sidekick
//
//  Created by Alex Wasserman on 8/15/16.
//  Copyright © 2016 Alex Wasserman. All rights reserved.
//

import UIKit

class CreateNewBudgetViewController: UIViewController, UITextFieldDelegate {
    
    var context = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    var budget: Budget?

    @IBOutlet weak var enteredName: UITextField!
    
    @IBOutlet weak var enteredFunds: UITextField!

    @IBAction func buttonPressed(sender: UIButton) {
        context?.performBlockAndWait {
            self.budget = Budget.budgetWithInfo(name: self.enteredName.text, totalFunds: self.enteredFunds.text, inContext: self.context!)
            try? self.context!.save()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enteredName.delegate = self
        enteredFunds.delegate = self
    }

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "displayCategories" {
            if let categoriesController = segue.destinationViewController as? CategoryScreenTableViewController {
                categoriesController.context = context
                categoriesController.budgetContainedIn = budget
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
