//
//  BudgetTableViewCell.swift
//  Savers Sidekick
//
//  Created by Alex Wasserman on 8/15/16.
//  Copyright © 2016 Alex Wasserman. All rights reserved.
//

import UIKit

class BudgetTableViewCell: UITableViewCell {
    @IBOutlet weak var mostRecentEntry: UILabel!
    @IBOutlet weak var budgetName: UILabel!
    @IBOutlet weak var budgetStatus: UILabel!
    
    var budget: Budget? {
        didSet {
            mostRecentEntry?.text = nil
            budgetName?.text = nil
            budgetStatus?.text = nil
            
            if let budget = self.budget {
                budgetName?.text = budget.name
                budgetStatus?.text = "\(budget.totalExpensesCurrencyDescription)/\(budget.totalFundsCurrencyDescription)"
                
                if let validDate = budget.mostRecentExpense {
                    let formatter = DateFormatter()
                    if Date().timeIntervalSince(validDate as Date) > 24*60*60 {
                        formatter.dateStyle = DateFormatter.Style.short
                    }
                    else {
                        formatter.timeStyle = DateFormatter.Style.short
                    }
                    mostRecentEntry?.text = "Most recent entry: \(formatter.string(from: validDate as Date))"
                }
            }
            else {
                NSLog("Unable to unwrap budget when updating BudgetTableViewCell")
            }
        }
    }
}
