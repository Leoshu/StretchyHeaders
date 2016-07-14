//
//  ContentCell.swift
//  StretchyHeaders
//
//  Created by Leo_hsu on 2016/6/27.
//  Copyright © 2016年 Leo_hsu. All rights reserved.
//

import UIKit

class ContentCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    
    var content: String? {
        didSet {
            if let contentStr = content {
                contentLabel.text = contentStr
            }
            else {
                contentLabel.text = nil
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
