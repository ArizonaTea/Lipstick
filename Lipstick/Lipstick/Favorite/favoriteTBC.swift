//
//  favoriteTBC.swift
//  Lipstick
//
//  Created by Marvin on 10/24/18.
//  Copyright © 2018 joylink. All rights reserved.
//

import UIKit
import expanding_collection
import SwiftyJSON
import SDWebImage

import UIKit

class favoriteTBC: ExpandingTableViewController {
    
    
    var brandName: String = ""
    var styleNumber: String = ""
    var allLipSticks: Array<Array<String>>? = []
    
    fileprivate var scrollOffsetY: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        
        loadProducts()
    }
    
    fileprivate func loadProducts() {
        self.allLipSticks?.removeAll()
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
                        if key != self.brandName {
                            continue
                        }
                        var series = dic![key]!["Series"]
                        for val in series {
                            if val.0 != self.styleNumber {
                                continue
                            }
                            let dval = val.1
                            for lip in dval {
                                if lip.0 == "Description" || lip.0 == "RefNumber" {
                                    continue
                                }

                                
                                self.allLipSticks?.append([lip.1["Name"].rawString() ?? "", lip.1["Price"].rawString() ?? "", lip.1["Price Unit"].rawString() ?? "", lip.1["Description"].rawString() ?? "", lip.1["Product Image"].rawString() ?? "", lip.1["Colour Image"].rawString() ?? "", lip.1["Colour Code"].rawString() ?? "", lip.1["Ref Number"].rawString() ?? "", lip.1["Key Words"].rawString() ?? "", lip.1["Purchase Link"].rawString() ?? ""])

                            }
                        }
                    }
                }
            }
            catch {/* error handling here */}
        }
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allLipSticks?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "TBCCell") as? TBCCell
        
        var url = self.allLipSticks?[indexPath.row][4]
        url = url!.replacingOccurrences(of: "\\", with: "")
        if !((url?.starts(with: "https:"))!) {
            url = "https:" + url!
        }
        cell?.productImg.sd_setImage(with: URL(string: url ?? ""), placeholderImage: UIImage(named: "Placeholder"))
        cell?.labelName.text = self.allLipSticks?[indexPath.row][0]
//        cell!.textLabel!.text = data[indexPath.row]
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc1 = storyboard.instantiateViewController(withIdentifier: "LipstickDetailController") as! LipstickDetailController
        vc1.lipStickName = self.allLipSticks?[indexPath.row][0]
        vc1.price = self.allLipSticks?[indexPath.row][1]
        vc1.priceUnit = self.allLipSticks?[indexPath.row][2]
        vc1.desc = self.allLipSticks?[indexPath.row][3]
        vc1.imge = self.allLipSticks?[indexPath.row][4]
        vc1.colors = self.allLipSticks?[indexPath.row][5]
        vc1.refNum = self.allLipSticks?[indexPath.row][7]
        vc1.colorCode = self.allLipSticks?[indexPath.row][6]
        vc1.keyWord = self.allLipSticks?[indexPath.row][8]
        vc1.purchaseLink = self.allLipSticks?[indexPath.row][9]
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.pushViewController(vc1, animated: true)
//        self.definesPresentationContext = true
//        let navController1 = UINavigationController(rootViewController: vc1)
//        navController1.modalPresentationStyle = .overCurrentContext
////        self.present(navController1, animated: true, completion: {self.navigationController?.setNavigationBarHidden(true, animated: true)})
//
//        self.present(navController1, animated: true, completion: nil)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        
        configureNavBar()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 263
    }
}

// MARK: Helpers

extension favoriteTBC {
    
    fileprivate func configureNavBar() {
        navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//        navigationItem.rightBarButtonItem?.image = navigationItem.rightBarButtonItem?.image!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    }
}

// MARK: Actions

extension favoriteTBC {
    @IBAction func backButtonHandler(_: AnyObject) {
        // buttonAnimation
        
//        btnBack.animationSelected(false)
        
        let vcs: [favoriteTBC?] = navigationController?.viewControllers.map {$0 as? favoriteTBC} ?? []
        for viewController in vcs {
            if let rightButton = viewController?.navigationItem.rightBarButtonItem as? AnimatingBarButton {
                rightButton.animationSelected(false)
            }
        }
        popTransitionAnimation()
    }
}

// MARK: UIScrollViewDelegate

extension favoriteTBC {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -25 , let navigationController = navigationController {
            // buttonAnimation
            for case let viewController as favoriteTBC in navigationController.viewControllers {
                if case let rightButton as AnimatingBarButton = viewController.navigationItem.rightBarButtonItem {
                    rightButton.animationSelected(false)
                }
            }
            popTransitionAnimation()
        }
        scrollOffsetY = scrollView.contentOffset.y
    }
}
