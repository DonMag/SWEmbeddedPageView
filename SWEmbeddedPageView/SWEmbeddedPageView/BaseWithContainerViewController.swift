//
//  BaseWithContainerViewController.swift
//  SWEmbeddedPageView
//
//  Created by Don Mini on 7/8/17.
//  Copyright © 2017 DonMag. All rights reserved.
//

import UIKit


// MARK: "Base" View Controller - has a Container View which holds a Page View Controller

class BaseWithContainerViewController: UIViewController {
}


// MARK: View Controller to use as our "page" (see storyboard)

class MyPageVC: UIViewController {
}


// MARK: Our UIPageViewController class

class MyPageViewController: UIPageViewController {
	
	private(set) lazy var thePageVCs: [UIViewController] = {
		return [
			self.newPageVC(UIColor.red),
			self.newPageVC(UIColor.green),
			self.newPageVC(UIColor.blue),
			self.newPageVC(UIColor.orange),
			self.newPageVC(UIColor.magenta),
			self.newPageVC(UIColor.cyan),
			self.newPageVC(UIColor.purple),
		]
	}()
	
	private func newPageVC(_ color: UIColor) -> UIViewController {
		
		let vc = self.storyboard?.instantiateViewController(withIdentifier: "myPageVC") ?? UIViewController()
		
		vc.view.backgroundColor = color
		
		// uncomment for simple rounded corners on the "pages"
		vc.view.clipsToBounds = true
		vc.view.layer.cornerRadius = 20.0

		return vc
		
	}
	
	// setup our page controller - Scroll, Horizontal, 20-pts spacing... this will override IB settings
	required init?(coder aDecoder: NSCoder) {
		let optionsDict = [UIPageViewControllerOptionInterPageSpacingKey : 20]
		super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: optionsDict)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// see extension below
		dataSource = self
		
		// init with first page
		if let firstVC = thePageVCs.first {
			setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
		}
	}
	
}


// MARK: UIPageViewControllerDataSource

extension MyPageViewController: UIPageViewControllerDataSource {
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		
		guard let currIndex = thePageVCs.index(of: viewController) else {
			return nil
		}
		
		let prevIndex = currIndex - 1
		
		// Allow "looping" when swiping right on first page
		guard prevIndex >= 0 else {
			return thePageVCs.last
		}
		
		return thePageVCs[prevIndex]

	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		
		guard let currIndex = thePageVCs.index(of: viewController) else {
			return nil
		}
		
		let nextIndex = currIndex + 1
		
		// Allow "looping" when swiping left on the last page
		guard thePageVCs.count > nextIndex else {
			return thePageVCs.first
		}
		
		return thePageVCs[nextIndex]

	}
	
}


// MARK: UIPageViewControllerDelegate

// uncomment this block to use the built-in UIPageControl (the "dots")
/*
extension MyPageViewController: UIPageViewControllerDelegate {
	
	func presentationCount(for pageViewController: UIPageViewController) -> Int {
		
		return thePageVCs.count
		
	}
	
	func presentationIndex(for pageViewController: UIPageViewController) -> Int {
		
		guard let firstVC = viewControllers?.first,
			let firstVCIndex = thePageVCs.index(of: firstVC) else {
				return 0
		}
		
		return firstVCIndex
		
	}
	
}
*/


