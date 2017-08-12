//
//  ExpensesPieChartViewController.swift
//  Savers Sidekick
//
//  Created by Alex Wasserman on 8/10/17.
//  Copyright © 2017 Alex Wasserman. All rights reserved.
//

import Charts
import UIKit

class ExpensesPieChartViewController: UIViewController {
    @IBOutlet weak var pieChartView: PieChartView!
    var budget: Budget = Budget()
    
    override func viewDidLoad() {
        pieChartView.noDataText = "No expenses have been recorded."
        
        if noDataToDisplay(categories: budget.categories) {
            pieChartView.data = nil
        }
        else {
            let description = Description()
            description.text = "Distribution of Expenses"
            pieChartView.chartDescription = description
            
            var chartData: [PieChartDataEntry] = []
            
            for item in budget.categories {
                if let category = item as? Category {
                    let amountSpent = Double(category.totalExpensesCSVDescription)!
                    chartData.append(PieChartDataEntry(value: amountSpent, label: category.name))
                }
            }
            
            let chartDataSet = PieChartDataSet(values: chartData, label: "Categories")
            chartDataSet.colors = ChartColorTemplates.colorful()
            
            pieChartView.data = PieChartData(dataSet: chartDataSet)
            pieChartView.data?.setValueFormatter(CurrencyFormatter())
        }
    }
    
    private func noDataToDisplay(categories: NSSet) -> Bool {
        if categories.count == 0 {
            return true
        }
        
        var foundExpense = false
        for item in categories {
            if let category = item as? Category {
                if category.expenses.count != 0 {
                    foundExpense = true
                    break
                }
            }
        }
        
        return !foundExpense
    }

}
