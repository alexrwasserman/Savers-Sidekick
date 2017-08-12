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
    
    var currentCategory: Category?

    @IBOutlet weak var enteredName: UITextField!
    @IBOutlet weak var enteredCost: UITextField!
    @IBOutlet weak var enteredDescription: UITextField!
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        validateInput(name: self.enteredName.text, cost: self.enteredCost.text)
        
        if let name = self.enteredName.text, let cost = self.enteredCost.text {
            context?.performAndWait {
                _ = Expense.expenseWithInfo(
                    name: name,
                    cost: Double(cost)!.roundToTwoDecimalPlaces(),
                    description: self.enteredDescription.text,
                    inCategory: self.currentCategory!,
                    inContext: self.context!
                )
                try? self.context!.save()
            }
            
            dismissView()
        }
    }
    
    @IBAction func dismissView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enteredName.delegate = self
        enteredCost.delegate = self
        enteredDescription.delegate = self
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
    
    fileprivate func validateInput(name: String?, cost: String?) {
        //TODO: implement this function, should trigger an alert to the user
        //      that they either left required fields blank or passed a value
        //      that doesn't parse to a valid number. Create an enum and pass
        //      it to this function to determine which kind of error it was
    }

}
