//
//  Category.swift
//  Savers Sidekick
//
//  Created by Alex Wasserman on 8/21/16.
//  Copyright © 2016 Alex Wasserman. All rights reserved.
//

import Foundation
import CoreData


class Category: NSManagedObject {
    
    class func categoryWithInfo(name enteredName: String?, totalFunds enteredFunds: String?, inBudget budget: Budget?, inContext context: NSManagedObjectContext) -> Category? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        if let validName = enteredName {
            request.predicate = NSPredicate(format: "name = %@", validName)
        }
        else {
            request.predicate = NSPredicate(format: "name = %@", "")
        }
        
        if let category = (try? context.fetch(request))?.first as? Category {
            return category
        }
        else if let category = NSEntityDescription.insertNewObject(forEntityName: "Category", into: context) as? Category {
            if enteredName != nil {
                category.name = enteredName
            }
            else {
                category.name = ""
            }
            
            if enteredFunds != nil {
                if let funds = Float(enteredFunds!) {
                    category.totalFunds = funds as NSNumber?
                }
            }
            else {
                category.totalFunds = 0.00
            }
            
            category.mostRecentExpense = nil
            
            category.totalExpenses = 0.00
            
            let budgetFunds = String(describing: budget?.totalFunds)
            category.parentBudget = Budget.budgetWithInfo(name: budget?.name, totalFunds: budgetFunds, inContext: context)
            
            return category
        }
        
        return nil
    }
    
    override func prepareForDeletion() {
        // Update total expenses of parent budget
        parentBudget?.totalExpenses = (parentBudget?.totalExpenses?.floatValue)! - (totalExpenses?.floatValue)! as NSNumber
        
        // Update mostRecentExpense for parent budget if necessary
        if mostRecentExpense == parentBudget?.mostRecentExpense {
            let budgetIterator = parentBudget?.categories?.makeIterator()
            var updatedMostRecentExpense = Date(timeIntervalSinceReferenceDate: 0)
            
            while let category = budgetIterator?.next() as? Category {
                if category.mostRecentExpense != mostRecentExpense && category.mostRecentExpense! > updatedMostRecentExpense {
                    updatedMostRecentExpense = category.mostRecentExpense!
                }
            }
            
            parentBudget?.mostRecentExpense = updatedMostRecentExpense
        }
    }

}
