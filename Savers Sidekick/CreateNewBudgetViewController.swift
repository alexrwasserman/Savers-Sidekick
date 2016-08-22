//
//  CreateNewBudgetViewController.swift
//  Savers Sidekick
//
//  Created by Alex Wasserman on 8/15/16.
//  Copyright © 2016 Alex Wasserman. All rights reserved.
//

import UIKit

class CreateNewBudgetViewController: UIViewController, UITextFieldDelegate {
    
    private var context = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext

    @IBOutlet weak var enteredName: UITextField!
    
    @IBOutlet weak var enteredFunds: UITextField!

    @IBAction func buttonPressed(sender: UIButton) {
        context?.performBlock {
            _ = Budget.budgetWithInfo(withName: self.enteredName.text, totalFunds: self.enteredFunds.text, inContext: self.context!)
            try? self.context!.save()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enteredName.delegate = self
        enteredFunds.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
