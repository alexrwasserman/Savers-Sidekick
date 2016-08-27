//
//  Expense.swift
//  Savers Sidekick
//
//  Created by Alex Wasserman on 8/21/16.
//  Copyright © 2016 Alex Wasserman. All rights reserved.
//

import Foundation
import CoreData


class Expense: NSManagedObject {
    override func prepareForDeletion() {
        parentCategory?.totalExpenses = (parentCategory?.totalExpenses?.floatValue)! - (cost?.floatValue)!
        parentCategory?.numberOfExpenses = NSNumber(int: (parentCategory?.numberOfExpenses?.intValue)! - 1)
        
        // ADD CODE TO RECALCULATE MOST RECENT EXPENSE
    }
}
