//
//  TBCCell.swift
//  Lipstick
//
//  Created by Marvin on 1/24/19.
//  Copyright © 2019 joylink. All rights reserved.
//

import UIKit

class TBCCell: UITableViewCell {
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
