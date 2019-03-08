//
//  AllLipsticksVC.swift
//  Lipstick
//
//  Created by Marvin on 9/30/18.
//  Copyright © 2018 joylink. All rights reserved.
//

import UIKit
import SwiftyJSON

extension String {
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}

class AllLipsticksVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : AllLipsticksCell? = tableView.dequeueReusableCell(withIdentifier: "AllLipsticksCell") as! AllLipsticksCell
        let text = (self.disPlaySticks![Array((self.disPlaySticks?.keys)!)[indexPath.section]]![indexPath.row] as! AnyObject)
        let json = JSON(text)
        cell!.labelName.text = json["Name"].rawString()
        var url = json["Product Image"].rawString()
        if !(url?.starts(with: "https:"))! {
            url = "https:" + url!
        }
        cell?.imageProduct.sd_setImage(with: URL(string: url!), placeholderImage: UIImage(named: "Placeholder"))
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 279
    }
    
    @IBOutlet weak var barSearch: UISearchBar!
    @IBOutlet weak var tableview: UITableView!
    var allLipSticks: Dictionary<String, NSMutableArray>? = [:]
    var disPlaySticks: Dictionary<String, NSMutableArray>? = [:]
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent("Firebase")
            
            //reading
            do {
                self.allLipSticks?.removeAll()
                let jsonString = try String(contentsOf: fileURL, encoding: .utf8)
                if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
                    let json = try JSON(data: dataFromString) as JSON
                    let dic = json.dictionary
                    for key in (dic?.keys)! {
                        if self.allLipSticks?[key] == nil {
                            self.allLipSticks?[key] = NSMutableArray()
                        }
                        if self.disPlaySticks?[key] == nil {
                            self.disPlaySticks?[key] = NSMutableArray()
                        }
                        var series = dic![key]!["Series"]
                        for val in series {
                            let dval = val.1
                            for lip in dval {
                                if lip.0 == "Discription" || lip.0 == "RefNumber" {
                                    continue
                                }
                                self.allLipSticks?[key]?.add(lip.1)
                                self.disPlaySticks?[key]?.add(lip.1)
                            }
                        }
                    }
                }
            }
            catch {/* error handling here */}
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.title = "All"
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.disPlaySticks?.removeAll()
        if(searchText.count == 0) {
            self.disPlaySticks = self.allLipSticks
        } else {
            for (key, value) in self.allLipSticks! {
                if key.lowercased().contains(searchText.lowercased()) {
                    self.disPlaySticks![key] = value
                } else {
                    for anyval in value {
                        let val = JSON(anyval).dictionary
                        let v1 = val!["Description"]?.rawString()
                        let v2 = val!["Name"]?.rawString()
                        let v3 = val!["Key Words"]?.rawString()
                        if (v1?.lowercased().contains(searchText.lowercased()))! || (v2?.lowercased().contains(searchText.lowercased()))! || (v3?.lowercased().contains(searchText.lowercased()))! {
                            if self.disPlaySticks?[key] == nil {
                                self.disPlaySticks![key] = NSMutableArray()
                            }
                            self.disPlaySticks![key]!.add(anyval)
                        }
                    }

                }
            }
            
        }
        self.tableview.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.barSearch.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.disPlaySticks?.keys.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.disPlaySticks![Array((self.disPlaySticks?.keys)!)[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array((self.disPlaySticks?.keys)!)[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc1 = storyboard.instantiateViewController(withIdentifier: "LipstickDetailController") as! LipstickDetailController
        let text = (self.disPlaySticks![Array((self.disPlaySticks?.keys)!)[indexPath.section]]![indexPath.row] as! AnyObject)
        let json = JSON(text)
        vc1.lipStickName = json["Name"].rawString()
        vc1.price = json["Price"].rawString()
        vc1.priceUnit = json["Price Unit"].rawString()
        vc1.desc = json["Description"].rawString()
        vc1.imge = json["Product Image"].rawString()
        vc1.colors = json["Colour Image"].rawString()
        vc1.refNum = json["Ref Number"].rawString()
        vc1.colorCode = json["Colour Code"].rawString()
        vc1.purchaseLink = json["Purchase Link"].rawString()
        vc1.keyWord = json["Key Words"].rawString()
        
        
        self.definesPresentationContext = true
//        let navController1 = UINavigationController(rootViewController: vc1)
        self.navigationController?.pushViewController(vc1, animated: true)
//        navController1.modalPresentationStyle = .overCurrentContext
//
//        var b = UIBarButtonItem(
//            title: "Done",
//            style: .plain,
//            target: vc1,
//            action: nil
//        )
//
//        navController1.navigationController?.navigationBar.topItem?.rightBarButtonItem = b
//
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
