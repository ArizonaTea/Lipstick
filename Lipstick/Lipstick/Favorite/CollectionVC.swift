//
//  CollectionVC.swift
//  Lipstick
//
//  Created by Marvin on 11/14/18.
//  Copyright © 2018 joylink. All rights reserved.
//

import UIKit
import UIEmptyState

class CollectionVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIEmptyStateDataSource, UIEmptyStateDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchTextField: UISearchBar!
    

    @IBOutlet weak var tableView: UITableView!
    var likelipsticks: [[String]]!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Set the initial state of the tableview, called here because cells should be done loading by now
        // Number of cells are used to determine if the view should be shown or not
        self.title = "Favourite"
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.dismiss(animated: true) {
            super.viewWillDisappear(animated)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = UserDefaults.standard
        var array = defaults.array(forKey: "LikedLipsticks")  as? [[String]] ?? [[String]]()
        likelipsticks = array
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchTextField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
       
//        self.emptyStateDataSource = self
//        self.emptyStateDelegate = self
//        // Optionally remove seperator lines from empty cells
//        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
//        self.reloadEmptyStateForTableView(self.tableView)

        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let defaults = UserDefaults.standard
        var array = defaults.array(forKey: "LikedLipsticks")  as? [[String]] ?? [[String]]()
        likelipsticks.removeAll()
        
        //[lipStickName, price, priceUnit, desc, imge, refNum, colors, colorCode, purchaseLink]
        for value in likelipsticks {
            if searchText.count == 0 || value[0].lowercased().contains(searchText) ||
                value[3].lowercased().contains(searchText) {
                likelipsticks.append(value)
            }
        }
        likelipsticks = array
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    var emptyStateTitle: NSAttributedString {
        let attrs = [NSAttributedString.Key.foregroundColor: UIColor(red: 0.882, green: 0.890, blue: 0.859, alpha: 1.00),
                     NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22)]
        return NSAttributedString(string: "No favorite yet!", attributes: attrs)
    }
    
    var emptyStateButtonTitle: NSAttributedString? {
        let attrs = [NSAttributedString.Key.foregroundColor: UIColor.white,
                     NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        return NSAttributedString(string: "Catch'em All", attributes: attrs)
    }
    
    var emptyStateImage: UIImage? {
        return UIImage(named: "all")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : CollectionCell? = tableView.dequeueReusableCell(withIdentifier: "CollectionCell") as! CollectionCell
        cell?.labelName?.text = likelipsticks?[indexPath.row][0]
        var url = likelipsticks[indexPath.row][4]
        if !(url.starts(with: "https:")) {
            url = "https:" + url
        }
        cell?.imageProduct.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "Placeholder"))
        return cell!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if likelipsticks != nil{
            return likelipsticks.count
        }
        return 0
        
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let s = ["Brand 1", "Brand 2", "Brand 3", "Brand 4", "Brand 5"]
//        return s[section]
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc1 = storyboard.instantiateViewController(withIdentifier: "LipstickDetailController") as! LipstickDetailController
        vc1.lipStickName = likelipsticks[0][0]
        vc1.price = likelipsticks[0][1]
        vc1.priceUnit = likelipsticks[0][2]
        vc1.desc = likelipsticks[0][3]
        vc1.imge = likelipsticks[0][4]
        vc1.refNum = likelipsticks[0][5]
        vc1.colors = likelipsticks[0][6]
        vc1.colorCode = likelipsticks[0][7]
        vc1.purchaseLink = likelipsticks[0][8]
        self.navigationController?.pushViewController(vc1, animated: true)
        
//        
//        self.definesPresentationContext = true
//        let navController1 = UINavigationController(rootViewController: vc1)
//        navController1.modalPresentationStyle = .overCurrentContext
//        self.present(navController1, animated: true, completion: nil)
        
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
