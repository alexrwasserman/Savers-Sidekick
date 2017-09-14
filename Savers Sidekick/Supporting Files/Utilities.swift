//
//  Utilities.swift
//  Savers Sidekick
//
//  Created by Alex Wasserman on 7/15/17.
//  Copyright © 2017 Alex Wasserman. All rights reserved.
//

import Foundation
import Charts


// A class meant to hold singletons
class Utilities {
    static var currencyFormatter = CurrencyFormatter()
    static var decimalFormatter = DecimalFormatter()
    
    static var mediumSeaGreen = NSUIColor(red: 46/255.0, green: 204/255.0, blue: 113/255.0, alpha: 1.0)
    static var dandelion = NSUIColor(red: 240/255.0, green: 225/255.0, blue: 48/255.0, alpha: 1.0)
    static var cinnabar = NSUIColor(red: 231/255.0, green: 76/255.0, blue: 60/255.0, alpha: 1.0)
    static var skyBlue = NSUIColor(red: 135/255.0, green: 206/255.0, blue: 250/255.0, alpha: 1.0)
    static var darkOrange = NSUIColor(red: 255/255.0, green: 140/255.0, blue: 0/255.0, alpha: 1.0)
    static var lightViolet = NSUIColor(red: 184/255.0, green: 77/255.0, blue: 255/255.0, alpha: 1.0)
    static var dijonYellow = NSUIColor(red: 176/255.0, green: 131/255.0, blue: 11/255.0, alpha: 1.0)
    static var seaGreen = NSUIColor(red: 46/255.0, green: 140/255.0, blue: 87/255.0, alpha: 1.0)
    static var deepPeach = NSUIColor(red: 255/255.0, green: 203/255.0, blue: 164/255.0, alpha: 1.0)
    static var royalBlue = NSUIColor(red: 65/255.0, green: 105/255.0, blue: 225/255.0, alpha: 1.0)
    
    static var chartColors: [NSUIColor] = [
        mediumSeaGreen,
        dandelion,
        cinnabar,
        skyBlue,
        darkOrange,
        lightViolet,
        dijonYellow,
        seaGreen,
        deepPeach,
        royalBlue
    ]
}

/// Formatter for displaying currency values
class CurrencyFormatter: NumberFormatter, IValueFormatter {
    override init() {
        super.init()
        
        self.numberStyle = .currency
        self.locale = NSLocale.current
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return stringForValue(value)
    }
    
    func stringForValue(_ value: Double) -> String {
        return self.string(from: value as NSNumber)!
    }
}

/// Formatter for displaying dates on the XAxis of the line chart
class ChartDateFormatter: DateFormatter, IAxisValueFormatter {
    override init() {
        super.init()
        
        self.dateStyle = .short
        self.locale = NSLocale.current
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return self.string(from: Date(timeIntervalSince1970: value))
    }
}

/// Formatter for displaying double values with exactly two decimal places
class DecimalFormatter: NumberFormatter {
    override init() {
        super.init()
        self.numberStyle = .decimal
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func stringForValue(_ value: Double) -> String {
        let stringComponents = value.description.components(separatedBy: ".")
        if stringComponents[1].characters.count == 1 {
            return stringComponents[0] + "." + stringComponents[1] + "0"
        }
        else {
            return value.description
        }
    }
}

extension Double {
    func roundToTwoDecimalPlaces() -> Double {
        return (self * 100).rounded() / 100
    }
}

/// Enum for input validation when user is creating a Budget/Category/Expense
enum ErrorType {
    case emptyName
    case emptyFunds
    case malformedName
    case malformedFunds
}
