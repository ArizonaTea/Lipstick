//
//  ColourboardVC.swift
//  Lipstick
//
//  Created by Marvin on 9/30/18.
//  Copyright © 2018 joylink. All rights reserved.
//

import UIKit
import SDWebImage
import SafariServices

class ColourboardVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ColourboardCell", for: indexPath) as! ColourboardCell
        var url = series[indexPath.row][6]
        if url.count > 0 && !(url.starts(with: "https:")) {
            url = "https:" + url
        }
        if url.count > 0 {
     cell.imageColor.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "Placeholder"))
            print(url)
        } else {
            let colorCode = series[indexPath.row][7]
            let index = colorCode.index(colorCode.startIndex, offsetBy: 1)
            let mySubstring = String(colorCode.suffix(from: index)) as String // playground
            
            var hexInt = UInt64(strtoul(mySubstring, nil, 16))
            cell.imageColor.backgroundColor = UIColor(rgb: Int(hexInt) )
        
        }
        cell.imageColor.layer.cornerRadius = 20
        cell.imageColor.clipsToBounds = true
        cell.labelLipName.text = series[indexPath.row][0]
//        cell.accessoryView = UIImageView(image:UIImage(named:"dragable")!)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, reorderRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        series.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        self.tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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
    
    @objc func didTapRightBtn() {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        let vc = SFSafariViewController(url: (URL.init(string: "https://docs.google.com/forms/d/e/1FAIpQLSfQv_EuV85XTsTRL863yMLWgCcM-Cs0p9GKTlE6i9L1k1yNEQ/viewform") ?? nil)!, configuration: config)
        present(vc, animated: true)
    }
    
     func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    
     func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.series[sourceIndexPath.row]
        series.remove(at: sourceIndexPath.row)
        series.insert(movedObject, at: destinationIndexPath.row)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.isEditing = true
        
        let image = UIImage(named: "feedback")?.withRenderingMode(.alwaysOriginal)
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(didTapRightBtn))
        self.navigationItem.rightBarButtonItem = button
        series = Array()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
         return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return series.count
    }
    
    @IBAction func didTapClear(_ sender: Any) {
        let alertController = UIAlertController(title: "Alert", message: "Are you sure to clear the colors?", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "YES", style: .default) { (action:UIAlertAction) in
            self.series .removeAll()
            self.tableView.reloadData()
            
            let defaults = UserDefaults.standard
            defaults.set(nil, forKey: "CompareLipsticks")
            self.btnClear.isHidden = true
            
            
        }
        
        let action2 = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
            
        }
        
    alertController.addAction(action1)
    alertController.addAction(action2)
        self.present(alertController, animated: true, completion: nil)
        
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

