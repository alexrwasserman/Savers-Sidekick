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
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        print("buttonPressed() - CNCVC")
        if let name = self.enteredName.text, let funds = self.enteredFunds.text {
            if name != "" && funds != "" {
                let parsedDollars = Int(funds.components(separatedBy: ".")[0])
                let parsedCents = Int(funds.components(separatedBy: ".")[1])
                
                if parsedDollars == nil || parsedCents == nil {
                    invalidInput()
                }

                let dollars = NSNumber(value: parsedDollars!)
                let cents = NSNumber(value: parsedCents!)
                
                context?.performAndWait {
                    _ = Category.categoryWithInfo(name: name,
                                                  totalFundsDollars: dollars,
                                                  totalFundsCents: cents,
                                                  inBudget: self.currentBudget!,
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
        print("dismissView() - CNCVC")
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        print("viewDidLoad() - CNCVC")
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
