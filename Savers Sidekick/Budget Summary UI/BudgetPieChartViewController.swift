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
        if budget!.noDataToDisplay() {
            pieChartView.data = nil
        }
        else {
            var chartData: [PieChartDataEntry] = []
            
            for category in budget!.categories {
                if let category = category as? Category {
                    let amountSpent = Double(category.totalExpensesDecimalDescription)!
                    chartData.append(PieChartDataEntry(value: amountSpent, label: category.name))
                }
            }
            
            let chartDataSet = PieChartDataSet(values: chartData, label: nil)
            
            chartDataSet.colors = Utilities.chartColors
            chartDataSet.sliceSpace = 5.0
            chartDataSet.automaticallyDisableSliceSpacing = true
            
            pieChartView.data = PieChartData(dataSet: chartDataSet)
            pieChartView.data?.setValueFormatter(CurrencyFormatter())
        }
    }
    
}
