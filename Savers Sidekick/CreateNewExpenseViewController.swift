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
        print("buttonPressed() - CNEVC")
        if let name = self.enteredName.text, let cost = self.enteredCost.text {
            if name != "" && cost != "" {
                let parsedDollars = Int(cost.components(separatedBy: ".")[0])
                let parsedCents = Int(cost.components(separatedBy: ".")[1])
                
                if parsedDollars == nil || parsedCents == nil {
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
        print("dismissView() - CNEVC")
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        print("viewDidLoad() - CNEVC")
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
