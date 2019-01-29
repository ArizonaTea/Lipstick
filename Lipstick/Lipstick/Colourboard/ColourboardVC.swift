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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let spacer = tableView.reorder.spacerCell(for: indexPath) {
            return spacer
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ColourboardCell", for: indexPath) as! ColourboardCell
        cell.imageColor.sd_setImage(with: URL(string: series[indexPath.row]), placeholderImage: UIImage(named: "Placeholder"))
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, reorderRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        (self.series[sourceIndexPath.row], self.series[destinationIndexPath.row]) = (self.series[destinationIndexPath.row], self.series[sourceIndexPath.row])
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    var series: Array<String>!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnClear: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        series = Array()
        
        let headerHeight: CGFloat = (view.frame.size.height - CGFloat(Int(tableView.rowHeight) * tableView.numberOfRows(inSection: 0))) / 2
        tableView.contentInset = UIEdgeInsetsMake(headerHeight, 0, -headerHeight, 0)
        
        
        series = ["https://www.chanel.com/fnbv3/image/full/shades/rouge-allure-luminous-intense-lip-colour-96-excentrique-35g.0160960_S.jpg", "https://www.chanel.com/fnbv3/image/full/shades/rouge-allure-luminous-intense-lip-colour-99-pirate-35g.0160990_S.jpg"]
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

