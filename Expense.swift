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

    class func expenseWithInfo(name enteredName: String,
                               costDollars enteredCostDollars: NSNumber,
                               costCents enteredCostCents: NSNumber,
                               description enteredDescription: String?,
                               inCategory category: Category,
                               inContext context: NSManagedObjectContext) -> Expense {
        print("expenseWithInfo - E")
        
        if let expense = NSEntityDescription.insertNewObject(forEntityName: "Expense", into: context) as? Expense {
            expense.name = enteredName
            expense.costDollars = enteredCostDollars
            expense.costCents = enteredCostCents
            expense.date = NSDate()
            
            if enteredDescription != nil {
                expense.humanDescription = enteredDescription
            }
            else {
                expense.humanDescription = ""
            }
            
            expense.parentCategory = Category.categoryWithInfo(name: category.name,
                                                               totalFundsDollars: category.totalFundsDollars,
                                                               totalFundsCents: category.totalFundsCents,
                                                               inBudget: category.parentBudget,
                                                               inContext: context)
            
            let updatedParentCategoryExpenses = performArithmetic(firstTermDollars: enteredCostDollars,
                                                                  firstTermCents: enteredCostCents,
                                                                  secondTermDollars: expense.parentCategory.totalExpensesDollars,
                                                                  secondTermCents: expense.parentCategory.totalExpensesCents,
                                                                  operation: Operation.addition)
            
            expense.parentCategory.totalExpensesDollars = updatedParentCategoryExpenses.0
            expense.parentCategory.totalExpensesCents = updatedParentCategoryExpenses.1
            
            let updatedParentBudgetExpenses = performArithmetic(firstTermDollars: enteredCostDollars,
                                                                firstTermCents: enteredCostCents,
                                                                secondTermDollars: expense.parentCategory.parentBudget.totalExpensesDollars,
                                                                secondTermCents: expense.parentCategory.parentBudget.totalExpensesCents,
                                                                operation: Operation.addition)
            
            expense.parentCategory.parentBudget.totalExpensesDollars = updatedParentBudgetExpenses.0
            expense.parentCategory.parentBudget.totalExpensesCents = updatedParentBudgetExpenses.1
            
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
        let updatedParentCategoryExpenses = performArithmetic(firstTermDollars: costDollars,
                                                              firstTermCents: costCents,
                                                              secondTermDollars: parentCategory.totalExpensesDollars,
                                                              secondTermCents: parentCategory.totalExpensesCents,
                                                              operation: Operation.subtraction)
        
        parentCategory.totalExpensesDollars = updatedParentCategoryExpenses.0
        parentCategory.totalExpensesCents = updatedParentCategoryExpenses.1
        
        let updatedParentBudgetExpenses = performArithmetic(firstTermDollars: costDollars,
                                                            firstTermCents: costCents,
                                                            secondTermDollars: parentCategory.parentBudget.totalExpensesDollars,
                                                            secondTermCents: parentCategory.parentBudget.totalExpensesCents,
                                                            operation: Operation.addition)
        
        parentCategory.parentBudget.totalExpensesDollars = updatedParentBudgetExpenses.0
        parentCategory.parentBudget.totalExpensesCents = updatedParentBudgetExpenses.1
        
        // Update mostRecentExpense for parent category and budget if necessary
        if date == parentCategory.mostRecentExpense {
            let categoryIterator = parentCategory.expenses.makeIterator()
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
                let budgetIterator = parentCategory.parentBudget.categories.makeIterator()
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
    
    override public var description: String {
        return String(describing: costDollars) + "." + String(describing: costCents)
    }
    
}
