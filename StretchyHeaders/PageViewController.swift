//
//  PageViewController.swift
//  StretchyHeaders
//
//  Created by Leo_hsu on 2016/6/13.
//  Copyright © 2016年 Leo_hsu. All rights reserved.
//

import UIKit

private let kTableHeaderHeight: CGFloat = 300.0
private let kPageSpace: CGFloat = 20.0

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {
    
    var items = [NewsItem]()
    var index: NSInteger = 0
    var currentIndex: NSInteger = 0
    var nextIndex: NSInteger = 0
    var pageContent: PageContentViewController!
    var contentVCs: [PageContentViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        items = DataOfPlist().loadCellDescriptors()
        self.dataSource = self
        self.delegate = self
        for i in 0...items.count-1 {
          contentVCs.append(getViewControllerAtIndex(i))
        }
        
        pageContent = contentVCs[index]
        self.setViewControllers([pageContent] as [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        
        for view in self.view.subviews {
            if let scrollView = view as? UIScrollView {
                scrollView.delegate = self
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func getViewControllerAtIndex(index: NSInteger) -> PageContentViewController
    {
        // Create a new view controller and pass suitable data.
        let pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageContent") as! PageContentViewController
        let item = items[index]
        pageContentViewController.strTitle = "\(item.category)"
        pageContentViewController.strContent = "\(item.article)"
        pageContentViewController.strPhotoName = "\(item.image)"
        pageContentViewController.pageIndex = index as Int
        return pageContentViewController
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        let pageContent: PageContentViewController = viewController as! PageContentViewController
        var index = pageContent.pageIndex
        if ((index == 0) || (index == NSNotFound)) {
            return nil
        }
        index -= 1
        return contentVCs[index]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        let pageContent: PageContentViewController = viewController as! PageContentViewController
        var index = pageContent.pageIndex
        if (index == NSNotFound) {
            return nil
        }
        
        index += 1
        
        if (index == self.items.count) {
            return nil
        }
        return contentVCs[index]
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers previousViewControllerArray: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            pageContent = pageViewController.viewControllers!.last as! PageContentViewController
        }
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return currentIndex
    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        let controller = pendingViewControllers.first as! PageContentViewController
        nextIndex = contentVCs.indexOf(controller)!
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func pressDismiss(sender: UIBarButtonItem) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        
        self.view.window?.layer.addAnimation(transition, forKey: kCATransition)
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let point = scrollView.contentOffset
        let dx = point.x - kPageSpace
        
        let percentComplete: CGFloat
        percentComplete = fabs(point.x - self.view.frame.size.width)/self.view.frame.size.width;
        print("point.x = \(point.x)")
        
        if point.x - self.view.frame.size.width > 0 {
            print("from right to left")
        }
        else if point.x - self.view.frame.size.width < 0{
            print("from left to right")
        }
        
        let currentPage = pageContent
        
        var headerRect: CGRect
        headerRect = CGRect(x: currentPage.tableView.bounds.width, y: currentPage.headerView.frame.origin.y, width: currentPage.tableView.bounds.width, height: currentPage.headerView.frame.size.height)
        
        if dx < currentPage.tableView.bounds.width {
            headerRect.origin.x = dx
        }
        headerRect.size.width = -(self.view.frame.size.width - fabs(dx - self.view.frame.size.width))
        print("self.view.frame.size.width = \(self.view.frame.size.width)")
        print("headerRect.size.width = \(headerRect.size.width)")
        currentPage.headerView.frame = headerRect

        let nextPage = contentVCs[nextIndex]
        if let nextHeaderView = nextPage.headerView {
            nextHeaderView.frame.origin.x = 0.0
            nextHeaderView.frame.size.width = nextPage.tableView.bounds.width
        }
    }
}
