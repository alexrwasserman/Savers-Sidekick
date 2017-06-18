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

    class func budgetWithInfo(name enteredName: String, totalFunds enteredFunds: String, inContext context: NSManagedObjectContext) -> Budget? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Budget")
        request.predicate = NSPredicate(format: "name = %@ AND totalFunds.stringValue = %@", enteredName, enteredFunds)
        
        if let budget = (try? context.fetch(request))?.first as? Budget {
            return budget
        }
        else if let budget = NSEntityDescription.insertNewObject(forEntityName: "Budget", into: context) as? Budget {
            budget.name = enteredName
            
            if let funds = Float(enteredFunds) {
                budget.totalFunds = funds as NSNumber?
            }
            else {
                budget.totalFunds = 0.00
            }
            
            budget.mostRecentExpense = nil
            
            budget.totalExpenses = 0.00
            
            return budget
        }
        
        return nil
    }
}
