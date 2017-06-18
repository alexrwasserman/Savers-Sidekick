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

    @IBAction func buttonPressed(_ sender: UIButton) {
        if let name = self.enteredName.text, let funds = self.enteredFunds.text {
            context?.performAndWait {
                _ = Budget.budgetWithInfo(name: name, totalFunds: funds, inContext: self.context!)
                try? self.context!.save()
            }
            
            performSegue(withIdentifier: "returnToBudgetsFromCreateBudget", sender: sender)
        }
        else {
            invalidInput()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enteredName.delegate = self
        enteredFunds.delegate = self
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "returnToBudgetsFromCreateBudget" {
            if let budgetsController = segue.destination as? BudgetsTableViewController {
                budgetsController.context = context
            }
        }
    }
    
    
    
    // MARK: - TextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == enteredName) {
            enteredFunds.becomeFirstResponder()
        }
        else {
            enteredFunds.resignFirstResponder()
        }
        
        return true
    }
    
    
    // MARK: - Input validation
    
    fileprivate func invalidInput() {
        //TODO: implement this function, should trigger an alert to the user
        //      that they left required fields blank
    }

}
