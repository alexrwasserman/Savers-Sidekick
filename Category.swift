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
    
    class func categoryWithInfo(name enteredName: String,
                                totalFundsDollars enteredFundsDollars: NSNumber,
                                totalFundsCents enteredFundsCents: NSNumber,
                                inBudget budget: Budget,
                                inContext context: NSManagedObjectContext) -> Category {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        request.predicate = NSPredicate(format: "name = %@ AND parentBudget.name = %@ AND totalFundsDollars = %@ AND totalFundsCents = %@",
                                        enteredName,
                                        budget.name,
                                        enteredFundsDollars,
                                        enteredFundsCents)
        
        if let category = (try? context.fetch(request))?.first as? Category {
            return category
        }
        else if let category = NSEntityDescription.insertNewObject(forEntityName: "Category", into: context) as? Category {
            category.name = enteredName
            category.totalFundsDollars = enteredFundsDollars
            category.totalFundsCents = enteredFundsCents
            category.mostRecentExpense = nil
            category.totalExpensesDollars = 0
            category.totalExpensesCents = 0
            category.parentBudget = Budget.budgetWithInfo(name: budget.name,
                                                          totalFundsDollars: budget.totalFundsDollars,
                                                          totalFundsCents: budget.totalFundsCents,
                                                          inContext: context)
            return category
        }
        else {
            return Category()
        }
    }
    
    override public func prepareForDeletion() {
        // Update total expenses of parent budget
        let updatedParentBudgetExpenses = performArithmetic(firstTermDollars: parentBudget.totalExpensesDollars,
                                                            firstTermCents: parentBudget.totalExpensesCents,
                                                            secondTermDollars: totalExpensesDollars,
                                                            secondTermCents: totalExpensesCents,
                                                            operation: Operation.subtraction)
        parentBudget.totalExpensesDollars = updatedParentBudgetExpenses.0
        parentBudget.totalExpensesCents = updatedParentBudgetExpenses.1
        
        // Update mostRecentExpense for parent budget if necessary
        if mostRecentExpense == parentBudget.mostRecentExpense {
            let budgetIterator = parentBudget.categories.makeIterator()
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
    
    public var totalExpensesDescription: String {
        return String.monetaryRepresentation(dollars: totalExpensesDollars, cents: totalExpensesCents)
    }
    
    public var totalFundsDescription: String {
        return String.monetaryRepresentation(dollars: totalFundsDollars, cents: totalFundsCents)
    }
    
    public var totalExpensesCSVDescription: String {
        if totalExpensesCents.stringValue.characters.count == 1 {
            return totalExpensesDollars.stringValue + ".0" + totalExpensesCents.stringValue
        }
        else {
            return totalExpensesDollars.stringValue + "." + totalExpensesCents.stringValue
        }
    }
    
    public var totalFundsCSVDescription: String {
        if totalFundsCents.stringValue.characters.count == 1 {
            return totalFundsDollars.stringValue + ".0" + totalFundsCents.stringValue
        }
        else {
            return totalFundsDollars.stringValue + "." + totalFundsCents.stringValue
        }
    }
    
}
