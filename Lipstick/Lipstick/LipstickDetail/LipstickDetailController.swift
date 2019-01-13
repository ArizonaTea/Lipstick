//
//  LipstickDetail.swift
//  Lipstick
//
//  Created by Marvin on 7/31/18.
//  Copyright © 2018 joylink. All rights reserved.
//

import UIKit
import SDWebImage

class LipstickDetailController: UIViewController {
    var lipStickName: String!
    var price: String!
    var priceUnit: String!
    var desc: String!
    var imge: String!
    var colors: Array<String>!
    var refNum: String!
    var disPlaySticks: Dictionary<String, NSMutableArray>? = [:]
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imageLipstick: UIImageView!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var textViewDesc: UITextView!
    @IBOutlet weak var imageColor: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageColor.sd_setImage(with: URL(string: colors[0]), placeholderImage: UIImage(named: "Placeholder"))
        imageLipstick.sd_setImage(with: URL(string: imge), placeholderImage: UIImage(named: "Placeholder"))
        self.labelName.text = lipStickName
        self.textViewDesc.text = desc
        self.labelPrice.text = "$" + "\(price!)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapDone(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
