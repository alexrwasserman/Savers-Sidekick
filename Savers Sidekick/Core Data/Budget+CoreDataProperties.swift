//
//  Budget+CoreDataProperties.swift
//  Savers Sidekick
//
//  Created by Alex Wasserman on 7/16/17.
//  Copyright © 2017 Alex Wasserman. All rights reserved.
//

import Foundation
import CoreData


extension Budget {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Budget> {
        return NSFetchRequest<Budget>(entityName: "Budget")
    }

    @NSManaged public var mostRecentExpense: NSDate?
    @NSManaged public var name: String
    @NSManaged public var totalExpensesCents: NSNumber
    @NSManaged public var totalExpensesDollars: NSNumber
    @NSManaged public var totalFundsCents: NSNumber
    @NSManaged public var totalFundsDollars: NSNumber
    @NSManaged public var categories: NSSet

}

// MARK: Generated accessors for categories
extension Budget {

    @objc(addCategoriesObject:)
    @NSManaged public func addToCategories(_ value: Category)

    @objc(removeCategoriesObject:)
    @NSManaged public func removeFromCategories(_ value: Category)

    @objc(addCategories:)
    @NSManaged public func addToCategories(_ values: NSSet)

    @objc(removeCategories:)
    @NSManaged public func removeFromCategories(_ values: NSSet)

}
