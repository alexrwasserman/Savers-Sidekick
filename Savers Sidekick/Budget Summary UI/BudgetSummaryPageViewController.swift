//
//  BudgetSummaryPageViewController.swift
//  Savers Sidekick
//
//  Created by Alex Wasserman on 8/10/17.
//  Copyright © 2017 Alex Wasserman. All rights reserved.
//

import UIKit

class BudgetSummaryPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var budget: Budget?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        var summaryControllers: [UIViewController]? = []
        
        let budgetPieChartViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "BudgetPieChartViewController") as! BudgetPieChartViewController
        
        budgetPieChartViewController.budget = budget
        summaryControllers?.append(budgetPieChartViewController)
        
        setViewControllers(summaryControllers, direction: .forward, animated: true, completion: nil)
    }
    
    @IBAction func summaryActions(_ sender: UIBarButtonItem) {
        let summaryAlertController = UIAlertController(title: "Chart Actions", message: nil, preferredStyle: .actionSheet)
        
        let saveChartAction = UIAlertAction(title: "Save As Image", style: .default) { _ in
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        summaryAlertController.addAction(saveChartAction)
        summaryAlertController.addAction(cancelAction)
        
        present(summaryAlertController, animated: true, completion: nil)
    }
    
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController is BudgetPieChartViewController {
            return nil
        }
        else {
            let pieChartController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "BudgetPieChartViewController") as! BudgetPieChartViewController
            
            pieChartController.budget = budget
            
            return pieChartController
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController is BudgetPieChartViewController {
            let lineChartController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "BudgetLineChartViewController") as! BudgetLineChartViewController
            
            lineChartController.budget = budget
            
            return lineChartController
        }
        else {
            return nil
        }
    }
}
