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
        expenseName.text = nil
        expenseCost.text = nil
        expenseDate.text = nil
        expenseDescription.text = nil
        descriptionLabel.text = nil
        
        if let expense = expense {
            expenseName.text = expense.name
            expenseCost.text = expense.currencyDescription
            
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .medium
            expenseDate.text = formatter.string(from: expense.date as Date)
            
            if expense.humanDescription != "" {
                descriptionLabel.text = "Description:"
                expenseDescription.text = expense.humanDescription
            }
        }
        else {
            NSLog("Encountered nil when displaying expense")
        }
    }
    
}
