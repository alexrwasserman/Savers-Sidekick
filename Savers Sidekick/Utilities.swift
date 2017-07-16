//
//  Utilities.swift
//  Savers Sidekick
//
//  Created by Alex Wasserman on 7/15/17.
//  Copyright © 2017 Alex Wasserman. All rights reserved.
//

import Foundation

public enum Operation {
    case addition
    case subtraction
    case multiplication
    case division
}

// TODO: Add support for multiplying and subtracting
public func performArithmetic(firstTermDollars: NSNumber,
                              firstTermCents: NSNumber,
                              secondTermDollars: NSNumber,
                              secondTermCents: NSNumber,
                              operation: Operation) -> (NSNumber, NSNumber) {
    switch operation {
    case .addition:
        let firstTerm = firstTermDollars.doubleValue + (firstTermCents.doubleValue / 100.0)
        let secondTerm = secondTermDollars.doubleValue + (secondTermCents.doubleValue / 100.0)
        let sum = firstTerm + secondTerm
        
        let sumDollars = Int(sum.description.components(separatedBy: ".")[0])
        let sumCents = Int(sum.description.components(separatedBy: ".")[1])
        
        return (NSNumber(value: sumDollars!), NSNumber(value: sumCents!))
        
    case .subtraction:
        let firstTerm = firstTermDollars.doubleValue + (firstTermCents.doubleValue / 100.0)
        let secondTerm = secondTermDollars.doubleValue + (secondTermCents.doubleValue / 100.0)
        let difference = firstTerm - secondTerm
        
        let differenceDollars = Int(difference.description.components(separatedBy: ".")[0])
        let differenceCents = Int(difference.description.components(separatedBy: ".")[1])
        
        return (NSNumber(value: differenceDollars!), NSNumber(value: differenceCents!))
        
    default:
        print("Multiplication and division are not supported yet")
        return(0,0)
    }
}
