//
//  PageContentViewController.swift
//  StretchyHeaders
//
//  Created by Leo_hsu on 2016/6/13.
//  Copyright © 2016年 Leo_hsu. All rights reserved.
//

import UIKit

private let kApplicationTimeoutInSeconds: NSTimeInterval = 3
private let kTableHeaderHeight: CGFloat = 300.0

class PageContentViewController: UITableViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var pageIndex: Int = 0
    var strTitle: String!
    var strContent: String!
    var strPhotoName: String!
    var myidleTimer: NSTimer?
    var show = true
    var lastContentOffset: CGFloat = 0
    
    var headerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(named: strPhotoName)
        
        //Stretchy Header
        headerView = tableView.tableHeaderView
        headerView.clipsToBounds = true
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        tableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight)
        updateHeaderView()
    }
    
    func updateHeaderView() {
        //Stretchy Header
        var headerRect = CGRect(x: 0, y: -kTableHeaderHeight, width: tableView.bounds.width, height: kTableHeaderHeight)
        headerRect.origin.y = tableView.contentOffset.y
        headerRect.size.height = -tableView.contentOffset.y
        if tableView.contentOffset.y < -kTableHeaderHeight {
         headerRect.origin.y = tableView.contentOffset.y
         headerRect.size.height = -tableView.contentOffset.y
        }
        headerView.frame = headerRect
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        resetIdleTimer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContentCell", forIndexPath: indexPath) as! ContentCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.content = strContent
        
        return cell
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        updateHeaderView()
        updateNaviBar(scrollView.contentOffset)
    }
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        lastContentOffset = scrollView.contentOffset.y
    }
    
    override func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        updateNaviBar(scrollView.contentOffset)
    }
    
    func updateNaviBar(contentOffset: CGPoint) {
        if lastContentOffset < contentOffset.y {
            print("Up")
            hideNavi()
        }
        else if lastContentOffset > contentOffset.y {
            print("Down")
            resetIdleTimer()
        }
    }
    
    func showNavi() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        show = true
    }
    
    func hideNavi() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        show = false
    }
    
    func resetIdleTimer() {
        showNavi()
        if let timer = myidleTimer {
             timer.invalidate()
        }
        myidleTimer = NSTimer.scheduledTimerWithTimeInterval(kApplicationTimeoutInSeconds, target: self, selector: #selector(PageContentViewController.idleTimerExceeded), userInfo: nil, repeats: false)
    }
    
    func idleTimerExceeded() {
        if show {
            if let timer = myidleTimer {
                timer.invalidate()
            }
            hideNavi()
        }
    }
}
