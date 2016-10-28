//
//  viewFriendsTableCell.swift
//  collaboration
//
//  Created by nick on 2/4/16.
//  Copyright © 2016 Supreme Leader. All rights reserved.
//

import UIKit

class viewFriendsTableCell: UITableViewCell {

    @IBOutlet weak var friendLabel: UILabel!
    
    @IBOutlet weak var blockButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
