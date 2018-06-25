//
//  PageViewController.swift
//  roomiesapp
//
//  Created by Gebruiker on 07-06-18.
//  Copyright © 2018 Gebruiker. All rights reserved.
//

import Foundation
import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // List of all the pages
    lazy var VCArray: [UIViewController] = {
        return [self.VCInstance(name: "MainPageVC"),
                self.VCInstance(name: "SettingsVC")]
    }()
    
    // function that returns the proper viewcontroller
    private func VCInstance(name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)
    }
    
    
    // Initial view user sees is loaded by this function
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        
        // gets first view out VCarray
        if let MainVC = VCArray.first {
            setViewControllers([MainVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for view in self.view.subviews {
            if view is UIScrollView {
                view.frame = UIScreen.main.bounds
            } else if view is UIPageControl {
                view.backgroundColor = UIColor.clear
            }
        }
    }
    
    // Checks what comes before the current view controller
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        // checks wether index is inside bounds
        guard let VCIndex = VCArray.index(of: viewController) else {
            return nil
        }

        // calculates previous index
        let previousIndex = VCIndex - 1
        
        // guard statments for first VC and within bounds and makes returns
        guard previousIndex >= 0 else{
            return VCArray.last
        }
        
        guard VCArray.count > previousIndex else {
            return nil
        }
        
        return VCArray[previousIndex]
    }
    
    // Checks what comes after the current view controller
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        // checks wether index is inside bounds
        guard let VCIndex = VCArray.index(of: viewController) else {
            return nil
        }
        
        // calculates next index
        let nextIndex = VCIndex + 1
        
        // guard statments for last VC in array and checks nextIndex bounds and makes returns
        guard nextIndex < VCArray.count else{
            return VCArray.first
        }
        
        guard VCArray.count > nextIndex else {
            return nil
        }
        
        return VCArray[nextIndex]
        
    }
    
    // total number of pages
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return VCArray.count
    }
    
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = VCArray.index(of: firstViewController) else {
                return 0
        }
        return firstViewControllerIndex
    }
    
    @IBAction func unwind(_ sender: UIStoryboardSegue){
        
    }
    
}
