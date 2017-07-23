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
        NSLog("Multiplication and division are not supported yet")
        return(0,0)
    }
}

public func roundCents(_ cents: String) -> (Int?, Bool) {
    if !cents.isIntegerRepresentation() {
        return (nil, false)
    }
    
    let numberOfDigits = cents.characters.count
    
    if numberOfDigits == 2 {
        return (Int(cents), false)
    }
    else if numberOfDigits == 1 {
        return (Int(cents + "0"), false)
    }
    else if numberOfDigits > 2 {
        let firstTwoDigits = cents.substring(to: cents.index(cents.startIndex, offsetBy: 2))
        let thirdDigit = cents[cents.index(cents.startIndex, offsetBy: 2)]
        
        let unroundedValue = Int(firstTwoDigits)!
        let roundedValue = Int(String(thirdDigit))! >= 5 ? unroundedValue + 1 : unroundedValue
        
        if roundedValue == 100 {
            return (0, true)
        }
        else {
            return (roundedValue, false)
        }
    }
    else {
        return (nil, false)
    }
}

extension String {
    
    func isIntegerRepresentation() -> Bool {
        let numericCharacters = CharacterSet.decimalDigits
        let scalars = self.unicodeScalars
        
        if scalars.isEmpty {
            return false
        }
        
        for val in scalars {
            if !numericCharacters.contains(val) {
                return false
            }
        }
        
        return true
    }
    
}
