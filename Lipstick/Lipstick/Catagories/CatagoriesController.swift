//
//  CatagoriesController.swift
//  Lipstick
//
//  Created by Marvin on 7/31/18.
//  Copyright © 2018 joylink. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class CatagoriesController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var brand: String!
    var ref: DatabaseReference!
    var series: Array<String>!
    var dic: Dictionary<String,  Array<String>>!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.definesPresentationContext = true
        ref = Database.database().reference().child(brand).child("Series")
        series = Array()
        dic = Dictionary()
        ref.observe(DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as! [String : Dictionary<String, Any>]
            
            for key in postDict.keys {
                self.series.append(key)
                for (k, v) in postDict[key]! {
                    if k as! String == "Discription" {
                        
                    } else if k as! String == "RefNumber" {
                        
                    } else {
                        let pdic = v as! NSDictionary
                        if self.dic[key] == nil {
                            self.dic[key] = []
                        }
                        self.dic[key]?.append(pdic.object(forKey: "Name") as! String)
                    }
                }
                
//                    self.dic[key]!.append(v["Name"])
                
                
            }
            self.tableView.reloadData()
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func didTapDone(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "catagoryCell")
        
        let dic = self.dic![self.series[indexPath.section]]
        
        let intIndex = indexPath.row // where intIndex < myDictionary.count
        
        cell?.textLabel?.text = self.dic[self.series[indexPath.section]]?[indexPath.row]
        return cell!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.series.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let seriesName = self.series[section] as! String
        let arr = self.dic[seriesName]
        return arr!.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.series?[section] as! String
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc1 = storyboard.instantiateViewController(withIdentifier: "LipstickDetailController")
        self.present(vc1, animated: true, completion: nil)
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
