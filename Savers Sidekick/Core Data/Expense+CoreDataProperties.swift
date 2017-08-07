//
//  Expense+CoreDataProperties.swift
//  Savers Sidekick
//
//  Created by Alex Wasserman on 7/16/17.
//  Copyright © 2017 Alex Wasserman. All rights reserved.
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var costCents: NSNumber
    @NSManaged public var costDollars: NSNumber
    @NSManaged public var date: NSDate
    @NSManaged public var humanDescription: String
    @NSManaged public var name: String
    @NSManaged public var parentCategory: Category

}
