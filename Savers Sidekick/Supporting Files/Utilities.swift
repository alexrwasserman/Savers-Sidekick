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
}

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
