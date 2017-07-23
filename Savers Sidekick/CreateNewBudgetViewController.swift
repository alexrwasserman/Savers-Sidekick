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
            if name != "" && funds != "" {
                var parsedDollars: Int?
                let parsedCents: Int?
                let components = funds.components(separatedBy: ".")
                
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
                    _ = Budget.budgetWithInfo(name: name, totalFundsDollars: dollars, totalFundsCents: cents, inContext: self.context!)
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
    
    fileprivate func invalidInput() {
        //TODO: implement this function, should trigger an alert to the user
        //      that they either left required fields blank or passed a value
        //      that doesn't parse to a valid number. Create an enum and pass
        //      it to this function to determine which kind of error it was
    }

}
