//
//  Expense+CoreDataClass.swift
//  Savers Sidekick
//
//  Created by Alex Wasserman on 7/16/17.
//  Copyright © 2017 Alex Wasserman. All rights reserved.
//

import Foundation
import CoreData


public class Expense: NSManagedObject {
    
    /// A function for obtaining an instance of an Expense. A new instance with the specified information is always created.
    /// - parameter name: Name of the Expense.
    /// - parameter cost: The cost of the Expense.
    /// - parameter description: The description of the Expense entered by the user.
    /// - parameter inCategory: The Category that the Expense is contained in.
    /// - parameter inContext: The context containing the data store in which the Expense is saved.
    class func expenseWithInfo(
        name enteredName: String,
        cost enteredCost: Double,
        description enteredDescription: String?,
        inCategory category: Category,
        inContext context: NSManagedObjectContext
    ) -> Expense {
        
        if let expense = NSEntityDescription.insertNewObject(forEntityName: "Expense", into: context) as? Expense {
            expense.name = enteredName
            expense.cost = enteredCost
            expense.date = NSDate()
            
            if enteredDescription != nil {
                expense.humanDescription = enteredDescription!
            }
            else {
                expense.humanDescription = ""
            }
            
            expense.parentCategory = Category.categoryWithInfo(
                name: category.name,
                totalFunds: category.totalFunds,
                inBudget: category.parentBudget,
                inContext: context
            )
            
            expense.parentCategory.totalExpenses += enteredCost
            expense.parentCategory.parentBudget.totalExpenses += enteredCost
            
            expense.parentCategory.mostRecentExpense = expense.date
            expense.parentCategory.parentBudget.mostRecentExpense = expense.date
            
            return expense
        }
        else {
            return Expense()
        }
    }
    
    override public func prepareForDeletion() {
        // Update total expenses of parent category and budget
        parentCategory.totalExpenses -= cost
        parentCategory.parentBudget.totalExpenses -= cost
        
        // Update mostRecentExpense for parent category and budget if necessary
        if date == parentCategory.mostRecentExpense {
            var categoryIterator = parentCategory.expenses.makeIterator()
            var mostRecentExpense = NSDate(timeIntervalSinceReferenceDate: 0)
            
            var foundAReplacement = false
            
            while let expense = categoryIterator.next() as? Expense {
                if expense.date != date && expense.date.compare(mostRecentExpense as Date) == .orderedDescending {
                    mostRecentExpense = expense.date
                    foundAReplacement = true
                }
            }
            
            parentCategory.mostRecentExpense = foundAReplacement ? mostRecentExpense : nil
            
            if date == parentCategory.parentBudget.mostRecentExpense {
                var budgetIterator = parentCategory.parentBudget.categories.makeIterator()
                mostRecentExpense = NSDate(timeIntervalSinceReferenceDate: 0)
                
                foundAReplacement = false
                
                while let category = budgetIterator.next() as? Category {
                    if category.mostRecentExpense != date &&
                        category.mostRecentExpense?.compare(mostRecentExpense as Date) == .orderedDescending {
                        mostRecentExpense = category.mostRecentExpense!
                        foundAReplacement = true
                    }
                }
                
                parentCategory.parentBudget.mostRecentExpense = foundAReplacement ? mostRecentExpense : nil
            }
        }
    }
    
    public var currencyDescription: String {
        return Utilities.currencyFormatter.stringForValue(cost)
    }
    
    public var decimalDescription: String {
        return Utilities.decimalFormatter.stringForValue(cost)
    }
    
}
