//
//  DataOfPlist.swift
//  Expandable
//
//  Created by Leo_hsu on 2016/1/4.
//  Copyright © 2016年 Appcoda. All rights reserved.
//

import Foundation

class DataOfPlist {
    
    func loadCellDescriptors() -> [NewsItem] {
        var allItem = [NewsItem]()
        
        if let path = NSBundle.mainBundle().pathForResource("CellDescriptor", ofType: "plist") {
            let cellDescriptors = NSMutableArray(contentsOfFile: path)
            for item in cellDescriptors! {
                if item is [String:AnyObject]{
                    let category = item["category"] as! NSNumber
                    let category1 = NewsCategory(rawValue: category.integerValue)
                    let summary = item["summary"] as! String
                    let article = item["article"] as! String
                    let image = item["image"] as! String
                    let news = NewsItem(category: category1!, summary: summary, article: article, image: image)
                    allItem.append(news)
                }
            }
        }
        
        return allItem
    }
}