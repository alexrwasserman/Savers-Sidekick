//
//  Category+CoreDataClass.swift
//  Savers Sidekick
//
//  Created by Alex Wasserman on 7/16/17.
//  Copyright © 2017 Alex Wasserman. All rights reserved.
//

import Foundation
import CoreData


public class Category: NSManagedObject {
    
    /// A function for obtaining an instance of a Category. If there is an existing instance with the same name and totalfunds
    /// and is contained in the same Budget as what is passed to this function, that instance is returned.
    /// Otherwise, a new instance is created with the specified information.
    /// - parameter name: Name of the Category.
    /// - parameter totalFunds: The total funds allocated to this Category.
    /// - parameter inBudget: The Budget that this Category is contained in.
    /// - parameter inContext: The context containing the data store in which the Category is saved.
    class func categoryWithInfo(
        name enteredName: String,
        totalFunds enteredFunds: Double,
        inBudget budget: Budget,
        inContext context: NSManagedObjectContext
    ) -> Category {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        request.predicate = NSPredicate(
            format: "name = %@ AND parentBudget.name = %@ AND totalFunds.description = %@",
            enteredName,
            budget.name,
            enteredFunds.description
        )
        
        if let category = (try? context.fetch(request))?.first as? Category {
            return category
        }
        else if let category = NSEntityDescription.insertNewObject(forEntityName: "Category", into: context) as? Category {
            category.name = enteredName
            category.totalFunds = enteredFunds
            category.mostRecentExpense = nil
            category.totalExpenses = 0.00
            category.parentBudget = Budget.budgetWithInfo(
                name: budget.name,
                totalFunds: budget.totalFunds,
                inContext: context
            )
            return category
        }
        else {
            return Category()
        }
    }
    
    override public func prepareForDeletion() {
        // Update total expenses of parent budget
        parentBudget.totalExpenses -= totalExpenses
        
        // Update mostRecentExpense for parent budget if necessary
        if mostRecentExpense == parentBudget.mostRecentExpense {
            var budgetIterator = parentBudget.categories.makeIterator()
            var updatedMostRecentExpense = NSDate(timeIntervalSince1970: 0)
            
            var foundAReplacement = false
            
            while let category = budgetIterator.next() as? Category {
                if category.mostRecentExpense != mostRecentExpense &&
                    category.mostRecentExpense?.compare(updatedMostRecentExpense as Date) == .orderedDescending {
                    
                    updatedMostRecentExpense = category.mostRecentExpense!
                    foundAReplacement = true
                }
            }
            
            parentBudget.mostRecentExpense = foundAReplacement ? updatedMostRecentExpense : nil
        }
    }
    
    public var totalExpensesCurrencyDescription: String {
        return Utilities.currencyFormatter.stringForValue(totalExpenses)
    }
    
    public var totalFundsCurrencyDescription: String {
        return Utilities.currencyFormatter.stringForValue(totalFunds)
    }
    
    public var totalExpensesDecimalDescription: String {
        return Utilities.decimalFormatter.stringForValue(totalExpenses)
    }
    
    public var totalFundsDecimalDescription: String {
        return Utilities.decimalFormatter.stringForValue(totalFunds)
    }
    
}
