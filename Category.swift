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

    class func categoryWithInfo(name enteredName: String?, totalFunds enteredFunds: String?, inBudget budget: Budget?, inContext context: NSManagedObjectContext) -> Category?{
        
        let request = NSFetchRequest(entityName: "Category")
        if let validName = enteredName {
            request.predicate = NSPredicate(format: "name = %@", validName)
        }
        else {
            request.predicate = NSPredicate(format: "name = %@", "")
        }
        
        if let category = (try? context.executeFetchRequest(request))?.first as? Category {
            return category
        }
        else if let category = NSEntityDescription.insertNewObjectForEntityForName("Category", inManagedObjectContext: context) as? Category {
            if enteredName != nil {
                category.name = enteredName
            }
            else {
                category.name = ""
            }
            
            if enteredFunds != nil {
                if let funds = Float(enteredFunds!) {
                    category.totalFunds = funds
                }
            }
            else {
                category.totalFunds = 0.00
            }
            
            category.mostRecentExpense = nil
            
            category.numberOfExpenses = 0
            
            category.totalExpenses = 0.00
            
            let budgetFunds = String(budget?.totalFunds)
            category.parentBudget = Budget.budgetWithInfo(name: budget?.name, totalFunds: budgetFunds, inContext: context)
            
            return category
        }
        
        return nil
    }
    
    override func prepareForDeletion() {
        parentBudget?.totalExpenses = (parentBudget?.totalExpenses?.floatValue)! - (totalExpenses?.floatValue)!
        parentBudget?.numberOfCategories = NSNumber(int: (parentBudget?.numberOfCategories?.intValue)! - 1)
        
        // ADD CODE TO RECALCULATE MOST RECENT EXPENSE
    }

}
