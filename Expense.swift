//
//  Expense.swift
//  Savers Sidekick
//
//  Created by Alex Wasserman on 8/21/16.
//  Copyright © 2016 Alex Wasserman. All rights reserved.
//

import Foundation
import CoreData


class Expense: NSManagedObject {
    
    class func expenseWithInfo(name enteredName: String?, cost enteredCost: String?, description enteredDescription: String?, inCategory category: Category?, inContext context: NSManagedObjectContext) -> Expense?{
        
        if let expense = NSEntityDescription.insertNewObjectForEntityForName("Expense", inManagedObjectContext: context) as? Expense {
            if enteredName != nil {
                expense.name = enteredName
            }
            else {
                expense.name = ""
            }
            if enteredCost != nil {
                if let cost = Float(enteredCost!) {
                    expense.cost = cost
                }
            }
            else {
                expense.cost = 0.00
            }
            
            expense.date = NSDate()
            
            if enteredDescription != nil {
                expense.expenseDescription = enteredDescription
            }
            else {
                expense.expenseDescription = ""
            }
            
            let categoryFunds = String(category?.totalFunds)
            expense.parentCategory = Category.categoryWithInfo(name: category?.name, totalFunds: categoryFunds, inBudget: category?.parentBudget, inContext: context)
            
            return expense
        }
        
        return nil
    }
    
    override func prepareForDeletion() {
        parentCategory?.totalExpenses = (parentCategory?.totalExpenses?.floatValue)! - (cost?.floatValue)!
        
        // ADD CODE TO RECALCULATE MOST RECENT EXPENSE
    }
}
