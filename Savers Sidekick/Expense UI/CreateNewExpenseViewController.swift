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
    
    @IBAction func createButtonPressed(_ sender: UIButton) {
        enteredCost.text = enteredCost.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !validateInput() {
            return
        }
        
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
    
    // Returns true if the input is valid, false if it is invalid
    private func validateInput() -> Bool {
        if enteredName.text == "" {
            displayErrorMessage(.emptyName)
            return false
        }
        else if enteredCost.text == "" {
            displayErrorMessage(.emptyFunds)
            return false
        }
        else if Utilities.decimalFormatter.number(from: enteredCost.text!) == nil {
            displayErrorMessage(.malformedFunds)
            return false
        }
        
        return true
    }
    
    private func displayErrorMessage(_ error: ErrorType) {
        let message: String
        
        switch error {
        case .emptyName: message = "\"Name\" field cannot be left blank"
        case .emptyFunds: message = "\"Cost\" field cannot be left blank"
        case .malformedName:
            NSLog("Encountered .malformedName during input validation when creating a Category")
            message = ""
        case .malformedFunds: message = "\"Cost\" field must be a valid number"
        }
        
        let errorAlertController = UIAlertController(title: "Input Error", message: message, preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel) { _ in }
        errorAlertController.addAction(dismissAction)
        
        present(errorAlertController, animated: true, completion: nil)
    }

}
