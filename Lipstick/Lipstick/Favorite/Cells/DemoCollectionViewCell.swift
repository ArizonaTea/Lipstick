//
//  DemoCollectionViewCell.swift
//  TestCollectionView
//
//  Created by Alex K. on 12/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit
import expanding_collection

class DemoCollectionViewCell: BasePageCollectionCell {

    
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var customTitle: UILabel!

    @IBOutlet weak var LabelColorCount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        customTitle.layer.shadowRadius = 2
        customTitle.layer.shadowOffset = CGSize(width: 0, height: 3)
        customTitle.layer.shadowOpacity = 0.2
    }
}
