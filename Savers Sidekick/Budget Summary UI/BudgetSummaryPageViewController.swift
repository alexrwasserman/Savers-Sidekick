//
//  BudgetSummaryPageViewController.swift
//  Savers Sidekick
//
//  Created by Alex Wasserman on 8/10/17.
//  Copyright © 2017 Alex Wasserman. All rights reserved.
//

import UIKit

class BudgetSummaryPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var budget = Budget()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        var summaryControllers: [UIViewController]? = []
        
        let expensesPieChartViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "ExpensesPieChartViewController")
        
        if let expensesPieChartViewController = expensesPieChartViewController as? ExpensesPieChartViewController {
            expensesPieChartViewController.budget = budget
            summaryControllers?.append(expensesPieChartViewController)
        }
        else {
            NSLog("Unable to cast UIViewController to ExpensesPieChartViewController")
        }
        
        setViewControllers(summaryControllers, direction: .forward, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return 1
//    }
//    
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        return 0
//    }
}
