//
//  LipstickDetail.swift
//  Lipstick
//
//  Created by Marvin on 7/31/18.
//  Copyright © 2018 joylink. All rights reserved.
//

import UIKit
import SDWebImage
import FaveButton
import expanding_collection
import SafariServices

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

class LipstickDetailController: UIViewController {
    var lipStickName: String!
    var price: String!
    var priceUnit: String!
    var desc: String!
    var imge: String!
    var colors: String!
    var refNum: String!
    var disPlaySticks: Dictionary<String, NSMutableArray>? = [:]
    var colorCode: String!
    var keyWord: String!
    var purchaseLink: String!
    
    @IBOutlet weak var btnCompare: FaveButton!
    @IBOutlet weak var btnLike: FaveButton!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imageLipstick: UIImageView!
    
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnBuy: UIButton!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var textViewDesc: UITextView!
    @IBOutlet weak var imageColor: UIImageView!
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.presentingViewController?.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnBuy.layer.cornerRadius = 5
        self.btnShare.layer.cornerRadius = 5
        self.imageColor.layer.cornerRadius = 17.5
        self.imageColor.clipsToBounds = true
        
        if(self.colors.count > 0) {
        var url = colors
        url = url!.replacingOccurrences(of: "\\", with: "")
        if !(url?.starts(with: "https:"))! {
            url  = "https:" + url!
        }
        imageColor.sd_setImage(with: URL(string: url!), placeholderImage: UIImage(named: "Placeholder"))
        } else if(self.colorCode.count > 0) {
            
            let index = colorCode.index(colorCode.startIndex, offsetBy: 1)
            let mySubstring = String(colorCode.suffix(from: index)) as String // playground
            
            var hexInt = UInt64(strtoul(mySubstring, nil, 16))
            self.imageColor.backgroundColor = UIColor(rgb: Int(hexInt) )
        }
        
        imge = imge.replacingOccurrences(of: "\\", with: "")
        if !(imge.starts(with: "https:")) {
            imge = "https:" + imge
        }
        
        imageLipstick.sd_setImage(with: URL(string: imge), placeholderImage: UIImage(named: "Placeholder"))
        self.labelName.text = lipStickName
        self.textViewDesc.text = desc
        self.labelPrice.text = "$" + "\(price!)"
        
        let defaults = UserDefaults.standard
        var array = defaults.array(forKey: "LikedLipsticks")  as? [[String]] ?? [[String]]()
        let list = array.filter{$0 != [lipStickName, price, priceUnit, desc, imge, refNum, colors, colorCode, purchaseLink]}
        if list == array {
            btnLike.isSelected = false
        } else {
            btnLike.isSelected = true
        }
        
        
        var array2 = defaults.array(forKey: "CompareLipsticks")  as? [[String]] ?? [[String]]()
        let list2 = array2.filter{$0 != [lipStickName, price, priceUnit, desc, imge, refNum, colors, colorCode, purchaseLink]}
        if list2 == array2 {
            btnCompare.isSelected = false
        } else {
            btnCompare.isSelected = true
        }

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapShare(_ sender: Any) {
        
        let items = ["Your Sharing Content"];
        let activity = UIActivityViewController(activityItems: items, applicationActivities: nil);
        self.present(activity, animated: true, completion: nil)
    }
    @IBAction func didTapBuy(_ sender: Any) {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        let vc = SFSafariViewController(url: (URL.init(string: purchaseLink) ?? nil)!, configuration: config)
        present(vc, animated: true)
    }
    
    @IBAction func didTapDone(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapCompare(_ sender: Any) {
        let defaults = UserDefaults.standard
        var array = defaults.array(forKey: "CompareLipsticks")  as? [[String]] ?? [[String]]()
        if(btnCompare.isSelected) {
            array.append([lipStickName, price, priceUnit, desc, imge, refNum, colors, colorCode, purchaseLink]);
        } else {
            array = array.filter{$0 != [lipStickName, price, priceUnit, desc, imge, refNum, colors, colorCode, purchaseLink]}
        }
        defaults.set(array, forKey: "CompareLipsticks")
        
    }
    @IBAction func didTapLike(_ sender: Any) {
        let defaults = UserDefaults.standard
        var array = defaults.array(forKey: "LikedLipsticks")  as? [[String]] ?? [[String]]()
        if(btnLike.isSelected) {
            array.append([lipStickName, price, priceUnit, desc, imge, refNum, colors, colorCode, purchaseLink]);
        } else {
            array = array.filter{$0 != [lipStickName, price, priceUnit, desc, imge, refNum, colors, colorCode, purchaseLink]}
        }
        defaults.set(array, forKey: "LikedLipsticks")
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
