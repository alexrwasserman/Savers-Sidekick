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
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if let name = self.enteredName.text, let cost = self.enteredCost.text {
            context?.performAndWait {
                _ = Expense.expenseWithInfo(name: name, cost: cost, description: self.enteredDescription.text, inCategory: self.categoryContainedIn!, inContext: self.context!)
                try? self.context!.save()
            }
            
            performSegue(withIdentifier: "returnToExpensesFromCreateExpense", sender: sender)
        }
        else {
            invalidInput()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enteredName.delegate = self
        enteredCost.delegate = self
        enteredDescription.delegate = self
    }
    

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "returnToExpensesFromCreateExpense" {
            if let expensesController = segue.destination as? ExpensesTableViewController {
                expensesController.context = context
                expensesController.categoryContainedIn = categoryContainedIn
            }
        }
    }
    
    
    // MARK: - TextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
    
    
    // MARK: - Input validation
    
    fileprivate func invalidInput() {
        //TODO: implement this function, should trigger an alert to the user
        //      that they left required fields blank
    }

}
