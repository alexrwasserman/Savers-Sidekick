//
//  BudgetLineChartViewController.swift
//  Savers Sidekick
//
//  Created by Alex Wasserman on 8/29/17.
//  Copyright © 2017 Alex Wasserman. All rights reserved.
//

import Foundation
import Charts

class BudgetLineChartViewController: UIViewController {
    @IBOutlet weak var lineChartView: LineChartView!
    var budget: Budget?
    
    override func viewDidLoad() {
        formatChartAppearance()
        loadChartData()
    }
    
    private func formatChartAppearance() {
        lineChartView.noDataText = "No expenses have been recorded."
        lineChartView.noDataTextColor = Utilities.seaGreen
        
        lineChartView.chartDescription = nil
        
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.valueFormatter = ChartDateFormatter()
    }
    
    private func loadChartData() {
        if budget!.noDataToDisplay() {
            lineChartView.data = nil
        }
        else {
            var chartData: [IChartDataSet] = []
            var categoryCounter = 0
            
            for category in budget!.categories {
                if let category = category as? Category {
                    var categoryData: [ChartDataEntry] = []
                    var totalCost = 0.00
                    
                    let sortedExpenses = category.expenses.sorted { firstExpense, secondExpense in
                        if let firstExpense = firstExpense as? Expense, let secondExpense = secondExpense as? Expense {
                            if firstExpense.date.compare(secondExpense.date as Date) == .orderedAscending {
                                return true
                            }
                            else {
                                return false
                            }
                        }
                        
                        return true
                    }
                    
                    for expense in sortedExpenses {
                        if let expense = expense as? Expense {
                            totalCost += expense.cost
                            categoryData.append(ChartDataEntry(x: expense.date.timeIntervalSince1970, y: totalCost))
                        }
                    }
                    
                    let dataSet = LineChartDataSet(values: categoryData, label: category.name)
                    let dataSetColor = Utilities.chartColors[categoryCounter % Utilities.chartColors.count]
                    
                    dataSet.setColor(dataSetColor)
                    dataSet.setCircleColor(dataSetColor)
                    
                    chartData.append(dataSet)
                    
                    categoryCounter += 1
                }
            }
            
            lineChartView.data = LineChartData(dataSets: chartData)
        }
    }
}
