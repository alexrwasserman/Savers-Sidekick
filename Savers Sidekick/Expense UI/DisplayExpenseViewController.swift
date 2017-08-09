//
//  DisplayExpenseViewController.swift
//  Savers Sidekick
//
//  Created by Alex Wasserman on 8/4/17.
//  Copyright © 2017 Alex Wasserman. All rights reserved.
//

import UIKit

class DisplayExpenseViewController: UIViewController {
    
    @IBOutlet weak var expenseName: UILabel!
    @IBOutlet weak var expenseCost: UILabel!
    @IBOutlet weak var expenseDate: UILabel!
    @IBOutlet weak var expenseDescription: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var expense: Expense?
    
    override func viewDidLoad() {
        if let unwrappedExpense = expense {
            expenseName.text = unwrappedExpense.name
            expenseCost.text = unwrappedExpense.description
            
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .medium
            expenseDate.text = formatter.string(from: unwrappedExpense.date as Date)
            
            if unwrappedExpense.humanDescription != "" {
                descriptionLabel.text = "Description:"
                expenseDescription.text = unwrappedExpense.humanDescription
            }
            else {
                descriptionLabel.text = nil
                expenseDescription.text = nil
            }
        }
        else {
            NSLog("Encountered nil when displaying expense")
            expenseName.text = nil
            expenseCost.text = nil
            expenseDate.text = nil
            expenseDescription.text = nil
            descriptionLabel.text = nil
        }
    }
    
}
