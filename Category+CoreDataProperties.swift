//
//  Category+CoreDataProperties.swift
//  Savers Sidekick
//
//  Created by Alex Wasserman on 7/16/17.
//  Copyright © 2017 Alex Wasserman. All rights reserved.
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var mostRecentExpense: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var totalExpensesCents: NSNumber?
    @NSManaged public var totalExpensesDollars: NSNumber?
    @NSManaged public var totalFundsCents: NSNumber?
    @NSManaged public var totalFundsDollars: NSNumber?
    @NSManaged public var expenses: NSSet?
    @NSManaged public var parentBudget: Budget?

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
