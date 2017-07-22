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
            mostRecentEntry?.text = nil
            categoryName?.text = nil
            categoryStatus?.text = nil
            numberOfEntries?.text = nil
            
            if let category = self.category {
                categoryName?.text = category.name
                
                if category.expenses.count != 1 {
                    numberOfEntries?.text = "\(category.expenses.count) expenses:"
                }
                else {
                    numberOfEntries?.text = "1 expense:"
                }
                
                categoryStatus?.text = "$\(category.totalExpensesDescription)/$\(category.totalFundsDescription)"
                
                if let validDate = category.mostRecentExpense {
                    let formatter = DateFormatter()
                    if Date().timeIntervalSince(validDate as Date) > 24*60*60 {
                        formatter.dateStyle = DateFormatter.Style.short
                    }
                    else {
                        formatter.timeStyle = DateFormatter.Style.short
                    }
                    mostRecentEntry?.text = "Most recent entry: \(formatter.string(from: validDate as Date))"
                }
                else {
                    mostRecentEntry?.text = nil
                }
            }
        }
    }
}
