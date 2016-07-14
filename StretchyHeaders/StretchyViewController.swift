//
//  ViewController.swift
//  StretchyHeaders
//
//  Created by Leo_hsu on 2016/6/3.
//  Copyright © 2016年 Leo_hsu. All rights reserved.
//

import UIKit

private let kTableHeaderHeight: CGFloat = 300.0
private let kBlurHeaderHeight: CGFloat = 44.0
private let kTableHeaderCutAway: CGFloat = 80.0

class StretchyViewController: UITableViewController {

    var items = [NewsItem]()
    
    var headerView: UIView!
    var headerMaskLayer: CAShapeLayer!
    
    var blurEffectView: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        items = DataOfPlist().loadCellDescriptors()
        
        headerView = tableView.tableHeaderView
        headerView.clipsToBounds = true
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        
        addBlurView()
        
        tableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight)
        
        // Mask code (this could be marked)
//        headerMaskLayer = CAShapeLayer()
//        headerMaskLayer.fillColor = UIColor.blackColor().CGColor
//        headerView.layer.mask = headerMaskLayer
//        
//        let effectiveHeight = kTableHeaderHeight-kTableHeaderCutAway/2
//        tableView.contentInset = UIEdgeInsets(top: effectiveHeight, left: 0, bottom: 0, right: 0)
//        tableView.contentOffset = CGPoint(x: 0, y: -effectiveHeight)
        //end Mask
        
        updateHeaderView()
    }
    
    func addBlurView() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.alpha = 0.0
        headerView.addSubview(blurEffectView)
    }
    func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: -kTableHeaderHeight, width: tableView.bounds.width, height: kTableHeaderHeight)
//        print("y = ",tableView.contentOffset.y)
        headerRect.origin.y = tableView.contentOffset.y
        headerRect.size.height = -tableView.contentOffset.y
        
        if tableView.contentOffset.y >= -kBlurHeaderHeight {
            blurEffectView.alpha = 1.0
            headerRect.size.height = kBlurHeaderHeight
        }
        else if tableView.contentOffset.y > -kTableHeaderHeight {
            let rate : CGFloat = (tableView.contentOffset.y + kTableHeaderHeight) / (kTableHeaderHeight - kBlurHeaderHeight)
            blurEffectView.alpha = rate
//            print("rate = ", rate)
        }
        
        //Stretchy Header
       /* var headerRect = CGRect(x: 0, y: -kTableHeaderHeight, width: tableView.bounds.width, height: kTableHeaderHeight)
//        print("y = ",tableView.contentOffset.y)
        if tableView.contentOffset.y < -kTableHeaderHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }*/
        
        // Mask code (this could be marked)
//        let effectiveHeight = kTableHeaderHeight-kTableHeaderCutAway/2
//        var headerRect = CGRect(x: 0, y: -effectiveHeight, width: tableView.bounds.width, height: kTableHeaderHeight)
//        if tableView.contentOffset.y < -effectiveHeight {
//            headerRect.origin.y = tableView.contentOffset.y
//            headerRect.size.height = -tableView.contentOffset.y + kTableHeaderCutAway/2
//        }
//        let path = UIBezierPath()
//        path.moveToPoint(CGPoint(x: 0, y: 0))
//        path.addLineToPoint(CGPoint(x: headerRect.width, y: 0))
//        path.addLineToPoint(CGPoint(x: headerRect.width, y: headerRect.height))
//        path.addLineToPoint(CGPoint(x: 0, y: headerRect.height-kTableHeaderCutAway))
//        headerMaskLayer?.path = path.CGPath
        // end Mask
        
        headerView.frame = headerRect
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! NewsItemCell
        
        let item = items[indexPath.row]
        cell.newsItem = item
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pageVC = storyboard.instantiateViewControllerWithIdentifier("PageVC") as! PageViewController
        pageVC.index = indexPath.row
        let navi = UINavigationController(rootViewController: pageVC)
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        
        self.view.window?.layer.addAnimation(transition, forKey: kCATransition)
        navi.modalTransitionStyle = .CrossDissolve
        self.presentViewController(navi, animated: false, completion: nil)
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        updateHeaderView()
    }
}

