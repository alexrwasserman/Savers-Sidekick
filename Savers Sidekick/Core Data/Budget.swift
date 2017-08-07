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
                              inContext context: NSManagedObjectContext) -> Budget {
        
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
        else {
            return Budget()
        }
    }
    
    public var totalExpensesDescription: String {
        return String.monetaryRepresentation(dollars: totalExpensesDollars, cents: totalExpensesCents)
    }
    
    public var totalFundsDescription: String {
        return String.monetaryRepresentation(dollars: totalFundsDollars, cents: totalFundsCents)
    }
    
    public func createCSVFile(path: URL) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd yyyy 'at' h:mm:ss a"
        
        var fileContent = "Category,Expense,Amount,Date,Description\n"
        
        for categoryItem in categories {
            if let category = categoryItem as? Category {
                fileContent += "\(String(describing: category.name)),,,,\n"
                
                for expenseItem in category.expenses {
                    if let expense = expenseItem as? Expense {
                        fileContent += ",\(String(describing: expense.name)),\(expense.csvDescription),"
                        fileContent += "\(formatter.string(from: expense.date as Date)),\(String(describing: expense.humanDescription))\n"
                    }
                }
                
                fileContent += ",,,,\n"
                fileContent += ",TOTAL:,\(category.totalExpensesCSVDescription),,\n"
                fileContent += ",ALLOTTED:,\(category.totalFundsCSVDescription),,\n"
                
                let difference = performArithmetic(firstTermDollars: category.totalFundsDollars,
                                                   firstTermCents: category.totalFundsCents,
                                                   secondTermDollars: category.totalExpensesDollars,
                                                   secondTermCents: category.totalExpensesCents,
                                                   operation: Operation.subtraction)
                let differenceStr = "\(difference.0)" + "." + "\(difference.1)"
                
                fileContent += ",DIFFERENCE:,\(differenceStr),,\n"
                fileContent += ",,,,\n"
            }
        }
        
        do {
            try fileContent.write(to: path, atomically: true, encoding: String.Encoding.utf8)
            NSLog("Successfully created file: %@", path.lastPathComponent)
        }
        catch {
            NSLog("Failed to create file: %@", path.lastPathComponent)
            NSLog("%@", "\(error)")
            return false
        }
        
        return true
    }
    
}
