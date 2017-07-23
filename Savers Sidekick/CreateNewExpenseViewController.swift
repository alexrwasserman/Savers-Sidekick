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
        if let name = self.enteredName.text, let cost = self.enteredCost.text {
            if name != "" && cost != "" {
                let parsedDollars: Int?
                let parsedCents: Int?
                let components = cost.components(separatedBy: ".")
                
                if components.count == 2 {
                    let wasRounded: Bool
                    
                    parsedDollars = Int(components[0])
                    (parsedCents, wasRounded) = roundCents(components[1])
                    
                    if parsedDollars == nil || parsedCents == nil {
                        invalidInput()
                    }
                    
                    if wasRounded {
                        parsedDollars! += 1
                    }
                }
                else if components.count == 1 {
                    parsedDollars = Int(components[0])
                    parsedCents = 0
                    
                    if parsedDollars == nil {
                        invalidInput()
                    }
                }
                else {
                    parsedDollars = nil
                    parsedCents = nil
                    invalidInput()
                }
                
                let dollars = NSNumber(value: parsedDollars!)
                let cents = NSNumber(value: parsedCents!)
                
                context?.performAndWait {
                    _ = Expense.expenseWithInfo(name: name,
                                                costDollars: dollars,
                                                costCents: cents,
                                                description: self.enteredDescription.text,
                                                inCategory: self.currentCategory!,
                                                inContext: self.context!)
                    try? self.context!.save()
                }
                dismissView()
            }
            else {
                invalidInput()
            }
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
    
    fileprivate func invalidInput() {
        //TODO: implement this function, should trigger an alert to the user
        //      that they either left required fields blank or passed a value
        //      that doesn't parse to a valid number. Create an enum and pass
        //      it to this function to determine which kind of error it was
    }

}
