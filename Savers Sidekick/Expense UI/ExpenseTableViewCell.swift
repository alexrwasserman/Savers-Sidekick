//
//  ExpenseTableViewCell.swift
//  Savers Sidekick
//
//  Created by Alex Wasserman on 8/28/16.
//  Copyright © 2016 Alex Wasserman. All rights reserved.
//

import UIKit

class ExpenseTableViewCell: UITableViewCell {

    @IBOutlet weak var expenseName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var humanDescription: UILabel!
    
    var expense: Expense? {
        didSet {
            expenseName?.text = nil
            date?.text = nil
            cost?.text = nil
            humanDescription?.text = nil
            
            if let expense = self.expense {
                expenseName?.text = expense.name
                
                cost?.text = "\(expense.currencyDescription)"
                
                humanDescription?.text = expense.humanDescription
                
                let formatter = DateFormatter()
                if Date().timeIntervalSince(expense.date as Date) > 24*60*60 {
                    formatter.dateStyle = DateFormatter.Style.short
                }
                else {
                    formatter.timeStyle = DateFormatter.Style.short
                }
                date?.text = "\(formatter.string(from: expense.date as Date))"
            }
            else {
                NSLog("Unable to unwrap expense when updating ExpenseTableViewCell")
            }
        }
    }
}
