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
    
    class func expenseWithInfo(name enteredName: String?, cost enteredCost: String?, description enteredDescription: String?, inCategory category: Category?, inContext context: NSManagedObjectContext) -> Expense? {
        
        if let expense = NSEntityDescription.insertNewObject(forEntityName: "Expense", into: context) as? Expense {
            if enteredName != nil {
                expense.name = enteredName
            }
            else {
                expense.name = ""
            }
            
            if enteredCost != nil {
                if let cost = Float(enteredCost!) {
                    expense.cost = cost as NSNumber?
                }
            }
            else {
                expense.cost = 0.00
            }
            
            expense.date = Date()
            
            if enteredDescription != nil {
                expense.expenseDescription = enteredDescription
            }
            else {
                expense.expenseDescription = ""
            }
            
            let categoryFunds = String(describing: category?.totalFunds)
            expense.parentCategory = Category.categoryWithInfo(name: category?.name, totalFunds: categoryFunds, inBudget: category?.parentBudget, inContext: context)
            
            expense.parentCategory?.totalExpenses = (expense.parentCategory?.totalExpenses?.floatValue)! + (expense.cost?.floatValue)! as NSNumber
            expense.parentCategory?.parentBudget?.totalExpenses = (expense.parentCategory?.parentBudget?.totalExpenses?.floatValue)! + (expense.cost?.floatValue)! as NSNumber
            
            expense.parentCategory?.mostRecentExpense = expense.date
            expense.parentCategory?.parentBudget?.mostRecentExpense = expense.date
            
            return expense
        }
        
        return nil
    }
    
    override func prepareForDeletion() {
        // Update total expenses of parent category and budget
        parentCategory?.totalExpenses = (parentCategory?.totalExpenses?.floatValue)! - (cost?.floatValue)! as NSNumber
        parentCategory?.parentBudget?.totalExpenses = (parentCategory?.parentBudget?.totalExpenses?.floatValue)! - (cost?.floatValue)! as NSNumber
        
        // Update mostRecentExpense for parent category and budget if necessary
        if date == parentCategory?.mostRecentExpense {
            let categoryIterator = parentCategory?.expenses?.makeIterator()
            var mostRecentExpense = Date(timeIntervalSinceReferenceDate: 0)
            
            while let expense = categoryIterator?.next() as? Expense {
                if expense.date != date && expense.date! > mostRecentExpense {
                    mostRecentExpense = expense.date!
                }
            }
            
            parentCategory?.mostRecentExpense = mostRecentExpense
            
            if date == parentCategory?.parentBudget?.mostRecentExpense {
                let budgetIterator = parentCategory?.parentBudget?.categories?.makeIterator()
                mostRecentExpense = Date(timeIntervalSinceReferenceDate: 0)
                
                while let category = budgetIterator?.next() as? Category {
                    if category.mostRecentExpense != date && category.mostRecentExpense! > mostRecentExpense {
                        mostRecentExpense = category.mostRecentExpense!
                    }
                }
                
                parentCategory?.parentBudget?.mostRecentExpense = mostRecentExpense
            }
        }
    }
}
