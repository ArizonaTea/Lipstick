//
//  CollectionCell.swift
//  Lipstick
//
//  Created by Marvin on 1/28/19.
//  Copyright © 2019 joylink. All rights reserved.
//

import UIKit

class CollectionCell: UITableViewCell {

    @IBOutlet weak var imageProduct: UIImageView!
    
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
