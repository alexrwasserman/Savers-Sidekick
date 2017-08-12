//
//  BudgetSummaryPageViewController.swift
//  Savers Sidekick
//
//  Created by Alex Wasserman on 8/10/17.
//  Copyright © 2017 Alex Wasserman. All rights reserved.
//

import UIKit

class BudgetSummaryPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
    }
    
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 1
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 1
    }
}
