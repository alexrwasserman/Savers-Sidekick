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
    
    var currentBudget: Budget?

    @IBOutlet weak var enteredName: UITextField!
    @IBOutlet weak var enteredFunds: UITextField!
    
    @IBAction func createButtonPressed(_ sender: UIButton) {
        enteredFunds.text = enteredFunds.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !validateInput() {
            return
        }
        
        if let name = self.enteredName.text, let funds = self.enteredFunds.text {
            context?.performAndWait {
                _ = Category.categoryWithInfo(
                    name: name,
                    totalFunds: Double(funds)!.roundToTwoDecimalPlaces(),
                    inBudget: self.currentBudget!,
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
        enteredFunds.delegate = self
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
    
    // Returns true if the input is valid, false if it is invalid
    private func validateInput() -> Bool {
        if enteredName.text == "" {
            displayErrorMessage(.emptyName)
            return false
        }
        else if enteredFunds.text == "" {
            displayErrorMessage(.emptyFunds)
            return false
        }
        else if Utilities.decimalFormatter.number(from: enteredFunds.text!) == nil {
            displayErrorMessage(.malformedFunds)
            return false
        }
        
        return true
    }
    
    private func displayErrorMessage(_ error: ErrorType) {
        let message: String
        
        switch error {
        case .emptyName: message = "\"Name\" field cannot be left blank"
        case .emptyFunds: message = "\"Funds For Category\" field cannot be left blank"
        case .malformedName:
            NSLog("Encountered .malformedName during input validation when creating a Category")
            message = ""
        case .malformedFunds: message = "\"Funds For Category\" field must be a valid number"
        }
        
        let errorAlertController = UIAlertController(title: "Input Error", message: message, preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel)
        errorAlertController.addAction(dismissAction)
        
        present(errorAlertController, animated: true, completion: nil)
    }

}
