//
//  chatTableViewCell.swift
//  collaboration
//
//  Created by nick on 11/22/15.
//  Copyright © 2015 Supreme Leader. All rights reserved.
//

import UIKit

class chatTableViewCell: UITableViewCell {


    @IBOutlet weak var messageButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageButton.titleLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping;
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        messageButton.titleLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping;
    }

}
