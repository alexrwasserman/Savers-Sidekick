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
    
    /// A function for obtaining an instance of a Budget. If there is an existing instance with the same name and totalfunds
    /// as what is passed to this function, that instance is returned. Otherwise, a new instance is created
    /// with the specified information.
    /// - parameter name: Name of the Budget.
    /// - parameter totalFunds: The total funds allocated to this Budget.
    /// - parameter inContext: The context containing the data store in which the Budget is saved.
    class func budgetWithInfo(
        name enteredName: String,
        totalFunds enteredFunds: Double,
        inContext context: NSManagedObjectContext
    ) -> Budget {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Budget")
        request.predicate = NSPredicate(format: "name = %@ AND totalFunds.description = %@", enteredName, enteredFunds.description)
        
        if let budget = (try? context.fetch(request))?.first as? Budget {
            return budget
        }
        else if let budget = NSEntityDescription.insertNewObject(forEntityName: "Budget", into: context) as? Budget {
            budget.name = enteredName
            budget.totalFunds = enteredFunds
            budget.mostRecentExpense = nil
            budget.totalExpenses = 0.00
            return budget
        }
        else {
            return Budget()
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
    
    /// Creates a CSV file summarizing this budget.
    /// - parameter path: The full path, including filename, where the CSV file will be written.
    public func createCSVFile(path: URL) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd yyyy 'at' h:mm:ss a"
        
        var fileContent = "Category,Expense,Amount,Date,Description\n"
        
        for category in categories {
            if let category = category as? Category {
                fileContent += "\(category.name),,,,\n"
                
                for expense in category.expenses {
                    if let expense = expense as? Expense {
                        fileContent += ",\(expense.name),\(expense.decimalDescription),"
                        fileContent += "\(formatter.string(from: expense.date as Date)),\(expense.humanDescription)\n"
                    }
                }
                
                fileContent += ",,,,\n"
                fileContent += ",TOTAL:,\(category.totalExpensesDecimalDescription),,\n"
                fileContent += ",ALLOTTED:,\(category.totalFundsDecimalDescription),,\n"
                fileContent += ",DIFFERENCE:,\(category.totalFunds - category.totalExpenses),,\n"
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
