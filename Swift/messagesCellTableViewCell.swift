//
//  messagesCellTableViewCell.swift
//  collaboration
//
//  Created by nick on 11/20/15.
//  Copyright © 2015 Supreme Leader. All rights reserved.
//

import UIKit

class messagesCellTableViewCell: UITableViewCell {

    @IBOutlet weak var convoMateLabel: UILabel!
    
    @IBOutlet weak var chatButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
