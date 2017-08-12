//
//  Category+CoreDataProperties.swift
//  Savers Sidekick
//
//  Created by Alex Wasserman on 8/11/17.
//  Copyright © 2017 Alex Wasserman. All rights reserved.
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var mostRecentExpense: NSDate?
    @NSManaged public var name: String
    @NSManaged public var totalExpenses: Double
    @NSManaged public var totalFunds: Double
    @NSManaged public var expenses: NSSet
    @NSManaged public var parentBudget: Budget

}

// MARK: Generated accessors for expenses
extension Category {

    @objc(addExpensesObject:)
    @NSManaged public func addToExpenses(_ value: Expense)

    @objc(removeExpensesObject:)
    @NSManaged public func removeFromExpenses(_ value: Expense)

    @objc(addExpenses:)
    @NSManaged public func addToExpenses(_ values: NSSet)

    @objc(removeExpenses:)
    @NSManaged public func removeFromExpenses(_ values: NSSet)

}
