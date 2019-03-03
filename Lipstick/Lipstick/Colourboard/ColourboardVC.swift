//
//  ColourboardVC.swift
//  Lipstick
//
//  Created by Marvin on 9/30/18.
//  Copyright © 2018 joylink. All rights reserved.
//

import UIKit
import SwiftReorder
import SDWebImage


class ColourboardVC: UIViewController, UITableViewDataSource, UITableViewDelegate, TableViewReorderDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc1 = storyboard.instantiateViewController(withIdentifier: "LipstickDetailController") as! LipstickDetailController
        vc1.lipStickName = series[indexPath.row][0]
        vc1.price = series[indexPath.row][1]
        vc1.priceUnit = series[indexPath.row][2]
        vc1.desc = series[indexPath.row][3]
        vc1.imge = series[indexPath.row][4]
        vc1.refNum = series[indexPath.row][5]
        vc1.colors = series[indexPath.row][6]
        vc1.colorCode = series[indexPath.row][7]
        vc1.purchaseLink = series[indexPath.row][8]
        self.navigationController?.pushViewController(vc1, animated: true)
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let spacer = tableView.reorder.spacerCell(for: indexPath) {
            return spacer
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ColourboardCell", for: indexPath) as! ColourboardCell
        
        //[lipStickName, price, priceUnit, desc, imge, refNum, colors]
        
//        var img = UIColor().HexToColor(hexString: series[indexPath.row][6], alpha: 1.0)
//
        var url = series[indexPath.row][6]
        if !(url.starts(with: "https:")) {
            url = "https:" + url
        }
        cell.imageColor.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "Placeholder"))
        cell.labelLipName.text = series[indexPath.row][0]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, reorderRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        (self.series[sourceIndexPath.row], self.series[destinationIndexPath.row]) = (self.series[destinationIndexPath.row], self.series[sourceIndexPath.row])
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    var series: Array<Array<String>>!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnClear: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.title = "Colorboard"
        
//        let headerHeight: CGFloat = (view.frame.size.height - CGFloat(Int(tableView.rowHeight) * tableView.numberOfRows(inSection: 0))) / 2
//        tableView.contentInset = UIEdgeInsetsMake(headerHeight, 0, -headerHeight, 0)
        
        let defaults = UserDefaults.standard
        var array = defaults.array(forKey: "CompareLipsticks")  as? [[String]] ?? [[String]]()
        
        
        series = array
        self.tableView.reloadData()
        if(series.count == 0) {
            self.btnClear.isHidden = true
        } else {
            self.btnClear.isHidden = false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        series = Array()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reorder.delegate = self
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
         return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return series.count
    }
    
    @IBAction func didTapClear(_ sender: Any) {
        self.series .removeAll()
        self.tableView.reloadData()
        
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: "CompareLipsticks")
        self.btnClear.isHidden = true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

