//
//  Budget+CoreDataClass.swift
//  Savers Sidekick
//
//  Created by Alex Wasserman on 7/16/17.
//  Copyright © 2017 Alex Wasserman. All rights reserved.
//

import Foundation
import CoreData


public class Budget: NSManagedObject {
    
    class func budgetWithInfo(name enteredName: String,
                              totalFundsDollars enteredFundsDollars: NSNumber,
                              totalFundsCents enteredFundsCents: NSNumber,
                              inContext context: NSManagedObjectContext) -> Budget? {
        print("budgetWithInfo - B")
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Budget")
        request.predicate = NSPredicate(format: "name = %@ AND totalFundsDollars = %@ AND totalFundsCents = %@",
                                        enteredName,
                                        enteredFundsDollars,
                                        enteredFundsCents)
        
        if let budget = (try? context.fetch(request))?.first as? Budget {
            return budget
        }
        else if let budget = NSEntityDescription.insertNewObject(forEntityName: "Budget", into: context) as? Budget {
            budget.name = enteredName
            budget.totalFundsDollars = enteredFundsDollars
            budget.totalFundsCents = enteredFundsCents
            budget.mostRecentExpense = nil
            budget.totalExpensesDollars = 0
            budget.totalExpensesCents = 0
            return budget
        }
        
        return nil
    }
    
    public var totalExpensesDescription: String {
        return String(describing: totalExpensesDollars) + "." + String(describing: totalExpensesCents)
    }
    
    public var totalFundsDescription: String {
        return String(describing: totalFundsDollars) + "." + String(describing: totalFundsCents)
    }
    
}
