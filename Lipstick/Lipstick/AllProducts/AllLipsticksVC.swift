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

class AllLipsticksVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "LipstickCell")
        let text = (self.disPlaySticks![Array((self.disPlaySticks?.keys)!)[indexPath.section]]![indexPath.row] as! AnyObject)
        let json = JSON(text)
        cell?.textLabel?.text = json["Name"].rawString()
//        if let dataFromString = text!.data(using: .utf8, allowLossyConversion: false) {
//            do {
//                let json = try JSON(data: dataFromString) as JSON
//                let dic = json.dictionary
//                cell?.textLabel?.text = dic!["Name"] as! String
//            } catch {
//                print(error)
//            }
//        }
        
        return cell!
    }
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.delegate = self
        self.tableview.dataSource = self
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
        vc1.desc = json["Discription"].rawString()
        vc1.imge = json["Product Image"].rawString()
        vc1.colors = [json["Colour Image"].rawString()] as! Array<String>
        vc1.refNum = json["Ref Number"].rawString()
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
