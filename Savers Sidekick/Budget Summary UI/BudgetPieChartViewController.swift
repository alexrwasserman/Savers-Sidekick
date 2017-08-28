//
//  BudgetPieChartViewController.swift
//  Savers Sidekick
//
//  Created by Alex Wasserman on 8/10/17.
//  Copyright © 2017 Alex Wasserman. All rights reserved.
//

import Charts
import UIKit

class BudgetPieChartViewController: UIViewController {
    
    static var pieChartColors: [NSUIColor] = [
        Utilities.mediumSeaGreen,
        Utilities.dandelion,
        Utilities.cinnabar,
        Utilities.skyBlue,
        Utilities.darkOrange,
        Utilities.lightViolet,
        Utilities.dijonYellow,
        Utilities.seaGreen,
        Utilities.deepPeach,
        Utilities.royalBlue
    ]
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    var budget: Budget?
    
    override func viewDidLoad() {
        formatChartAppearance()
        loadChartData()
    }
    
    private func formatChartAppearance() {
        pieChartView.renderer = SidekickPieChartRenderer(
            chart: pieChartView,
            animator: pieChartView.chartAnimator,
            viewPortHandler: pieChartView.viewPortHandler
        )
        
        pieChartView.noDataText = "No expenses have been recorded."
        pieChartView.noDataTextColor = Utilities.seaGreen
        
        pieChartView.chartDescription = nil
        
        let plainText = "Distribution By Category"
        let centerText = NSMutableAttributedString(string: plainText)
        
        let paragraphStyle: NSMutableParagraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.alignment = .center
        
        let centerTextAttributes = [
            NSForegroundColorAttributeName: Utilities.seaGreen,
            NSFontAttributeName: UIFont.systemFont(ofSize: 18),
            NSParagraphStyleAttributeName: paragraphStyle
        ]
        
        centerText.setAttributes(centerTextAttributes, range: NSMakeRange(0, (plainText as NSString).length))
        
        pieChartView.centerAttributedText = centerText
        pieChartView.centerTextRadiusPercent = 0.75
        
        pieChartView.legend.form = .default
        pieChartView.legend.orientation = .vertical
        pieChartView.legend.yOffset = 15.0
        
        pieChartView.rotationEnabled = false
    }
    
    private func loadChartData() {
        if noDataToDisplay(budget!.categories) {
            pieChartView.data = nil
        }
        else {
            var chartData: [PieChartDataEntry] = []
            
            for item in budget!.categories {
                if let category = item as? Category {
                    let amountSpent = Double(category.totalExpensesDecimalDescription)!
                    chartData.append(PieChartDataEntry(value: amountSpent, label: category.name))
                }
            }
            
            let chartDataSet = PieChartDataSet(values: chartData, label: nil)
            
            chartDataSet.colors = BudgetPieChartViewController.pieChartColors
            chartDataSet.sliceSpace = 2.0
            chartDataSet.automaticallyDisableSliceSpacing = true
            
            pieChartView.data = PieChartData(dataSet: chartDataSet)
            pieChartView.data?.setValueFormatter(CurrencyFormatter())
        }
    }
    
    private func noDataToDisplay(_ categories: NSSet) -> Bool {
        if categories.count == 0 {
            return true
        }
        
        var foundExpense = false
        for category in categories {
            if let category = category as? Category {
                if category.totalExpenses.roundToTwoDecimalPlaces() > 0.00 {
                    foundExpense = true
                    break
                }
            }
        }
        
        return !foundExpense
    }
    
    @IBAction func summaryActions(_ sender: UIBarButtonItem) {
        let summaryAlertController = UIAlertController(title: "Summary Actions", message: nil, preferredStyle: .actionSheet)
        
        let saveChartAction = UIAlertAction(title: "Save Chart", style: .default) { _ in
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        
        summaryAlertController.addAction(saveChartAction)
        summaryAlertController.addAction(cancelAction)
        
        present(summaryAlertController, animated: true, completion: nil)
    }
    
}
