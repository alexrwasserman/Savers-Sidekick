//
//  Budget+CoreDataProperties.swift
//  Savers Sidekick
//
//  Created by Alex Wasserman on 8/28/16.
//  Copyright © 2016 Alex Wasserman. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Budget {

    @NSManaged var mostRecentExpense: Date?
    @NSManaged var name: String?
    @NSManaged var totalExpenses: NSNumber?
    @NSManaged var totalFunds: NSNumber?
    @NSManaged var categories: NSSet?

}
