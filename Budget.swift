//
//  Budget.swift
//  Savers Sidekick
//
//  Created by Alex Wasserman on 8/21/16.
//  Copyright © 2016 Alex Wasserman. All rights reserved.
//

import Foundation
import CoreData


class Budget: NSManagedObject {

    class func budgetWithInfo(name enteredName: String?, totalFunds enteredFunds: String?, inContext context: NSManagedObjectContext) -> Budget? {
        
        let request = NSFetchRequest(entityName: "Budget")
        if let validName = enteredName {
            request.predicate = NSPredicate(format: "name = %@", validName)
        }
        else {
            request.predicate = NSPredicate(format: "name = %@", "")
        }
        
        if let budget = (try? context.executeFetchRequest(request))?.first as? Budget {
            return budget
        }
        else if let budget = NSEntityDescription.insertNewObjectForEntityForName("Budget", inManagedObjectContext: context) as? Budget {
            if enteredName != nil {
                budget.name = enteredName
            }
            else {
                budget.name = ""
            }
            
            if enteredFunds != nil {
                if let funds = Float(enteredFunds!) {
                    budget.totalFunds = funds
                }
            }
            else {
                budget.totalFunds = 0.00
            }
            
            budget.mostRecentExpense = nil
            
            budget.numberOfCategories = 0
            
            budget.totalExpenses = 0.00
            
            return budget
        }
        
        return nil
    }
}
