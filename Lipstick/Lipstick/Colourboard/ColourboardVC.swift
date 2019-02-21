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

extension UIColor{
    func HexToColor(hexString: String, alpha:CGFloat? = 1.0) -> UIColor {
        // Convert hex string to an integer
        let hexint = Int(self.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = NSCharacterSet(charactersIn: "#") as CharacterSet
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
}

class ColourboardVC: UIViewController, UITableViewDataSource, UITableViewDelegate, TableViewReorderDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let spacer = tableView.reorder.spacerCell(for: indexPath) {
            return spacer
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ColourboardCell", for: indexPath) as! ColourboardCell
        
        //[lipStickName, price, priceUnit, desc, imge, refNum, colors]
        
//        var img = UIColor().HexToColor(hexString: series[indexPath.row][6], alpha: 1.0)
//
        cell.imageColor.sd_setImage(with: URL(string: series[indexPath.row][6]), placeholderImage: UIImage(named: "Placeholder"))
        cell.labelLipName.text = series[indexPath.row][0]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, reorderRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        (self.series[sourceIndexPath.row], self.series[destinationIndexPath.row]) = (self.series[destinationIndexPath.row], self.series[sourceIndexPath.row])
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    var series: Array<Array<String>>!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnClear: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        let headerHeight: CGFloat = (view.frame.size.height - CGFloat(Int(tableView.rowHeight) * tableView.numberOfRows(inSection: 0))) / 2
        tableView.contentInset = UIEdgeInsetsMake(headerHeight, 0, -headerHeight, 0)
        
        let defaults = UserDefaults.standard
        var array = defaults.array(forKey: "CompareLipsticks")  as? [[String]] ?? [[String]]()
        
        
        series = array
        self.tableView.reloadData()
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

