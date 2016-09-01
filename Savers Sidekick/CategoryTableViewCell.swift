//
//  CategoryTableViewCell.swift
//  Savers Sidekick
//
//  Created by Alex Wasserman on 8/20/16.
//  Copyright © 2016 Alex Wasserman. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var mostRecentEntry: UILabel!
    @IBOutlet weak var numberOfEntries: UILabel!
    @IBOutlet weak var categoryStatus: UILabel!
    
    var category: Category? {
        didSet {
            updateUI()
        }
    }

    private func updateUI() {
        mostRecentEntry?.text = nil
        categoryName?.text = nil
        categoryStatus?.text = nil
        numberOfEntries?.text = nil
        
        if let category = self.category {
            categoryName?.text = category.name
            
            numberOfEntries?.text = "\(category.expenses?.count) expenses:"
            
            let funds = category.totalFunds
            let expenses = category.totalExpenses
            categoryStatus?.text = "$\(expenses)/$\(funds)"
            
            if let validDate = category.mostRecentExpense {
                let formatter = NSDateFormatter()
                if NSDate().timeIntervalSinceDate(validDate) > 24*60*60 {
                    formatter.dateStyle = NSDateFormatterStyle.ShortStyle
                }
                else {
                    formatter.timeStyle = NSDateFormatterStyle.ShortStyle
                }
                mostRecentEntry?.text = "Most recent entry: \(formatter.stringFromDate(validDate))"
            }
            else {
                mostRecentEntry?.text = nil
            }
        }
    }
}
