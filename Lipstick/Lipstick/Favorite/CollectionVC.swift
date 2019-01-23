//
//  CollectionVC.swift
//  Lipstick
//
//  Created by Marvin on 11/14/18.
//  Copyright © 2018 joylink. All rights reserved.
//

import UIKit
import UIEmptyState

class CollectionVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIEmptyStateDataSource, UIEmptyStateDelegate {

    @IBOutlet weak var tableView: UITableView!
    var likelipsticks: [[String]]!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Set the initial state of the tableview, called here because cells should be done loading by now
        // Number of cells are used to determine if the view should be shown or not
        
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
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        // Do any additional setup after loading the view.
        
//        self.emptyStateDataSource = self
//        self.emptyStateDelegate = self
//        // Optionally remove seperator lines from empty cells
//        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
//        self.reloadEmptyStateForTableView(self.tableView)

        
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
        var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "LipstickCell")
        cell?.textLabel?.text = likelipsticks?[indexPath.row][0]
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
        vc1.price = likelipsticks[1][0]
        vc1.priceUnit = likelipsticks[2][0]
        vc1.desc = likelipsticks[3][0]
        vc1.imge = likelipsticks[4][0]
        vc1.colors = []
        vc1.refNum = likelipsticks[5][0]
        self.present(vc1, animated: true, completion: nil)
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
