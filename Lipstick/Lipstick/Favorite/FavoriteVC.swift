//
//  DemoViewController.swift
//  TestCollectionView
//
//  Created by Alex K. on 12/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit
import expanding_collection
import SwiftyJSON

class FavoriteVC: ExpandingViewController {

    
    
    @IBOutlet weak var labelSeries: UILabel!
    @IBAction func didTapDone(_ sender: Any) {
        	self.navigationController?.popViewController(animated: true)
//            self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    typealias ItemInfo = ( imageURL: String,  title: String)
    fileprivate var cellsIsOpen = [Bool]()
    fileprivate var items: [ItemInfo] = []

    @IBOutlet var pageLabel: UILabel!
    var brand: String!
    
    
}

// MARK: - Lifecycle 🌎
extension FavoriteVC {
    override func viewDidLoad() {
        itemSize = CGSize(width: 256, height: 460)
        super.viewDidLoad()
        loadSeries()
        registerCell()
        fillCellIsOpenArray()
        addGesture(to: collectionView!)
        configureNavBar()
        
        self.labelSeries.text = "Series " + brand
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func loadSeries() {
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent("Firebase")
            //reading
            do {
                self.items.removeAll()
                let jsonString = try String(contentsOf: fileURL, encoding: .utf8)
                if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
                    let json = try JSON(data: dataFromString) as JSON
                    let dic = json.dictionary
                    for key in (dic?.keys)! {
                        if key != self.brand {
                            continue
                        }
                        var series = dic![key]!["Series"]
                        for val in series {
                            let dval = val.1
                            for lip in dval {
                                if lip.0 == "Description" || lip.0 == "RefNumber" {
                                    continue
                                }
                                let url = lip.1["Product Image"].rawString()
                                self.items.append(( url ?? "", val.0))
                                break
                            }
                        }
                    }
                }
            }
            catch  {/* error handling here */}
        }
    }
    
}

// MARK: Helpers

extension FavoriteVC {

    fileprivate func registerCell() {

        let nib = UINib(nibName: String(describing: DemoCollectionViewCell.self), bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: String(describing: DemoCollectionViewCell.self))
    }

    fileprivate func fillCellIsOpenArray() {
        cellsIsOpen = Array(repeating: false, count: items.count)
    }

    fileprivate func getViewController() -> ExpandingTableViewController {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let toViewController: favoriteTBC = storyboard.instantiateViewController(withIdentifier: "favoriteTBC") as! favoriteTBC
        let indexPath = IndexPath(row: currentIndex, section: 0)
        toViewController.styleNumber = self.items[indexPath.row].1
        toViewController.brandName = self.brand
        
        return toViewController
//
//
//        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "favoriteTBC") as? favoriteTBC
//        return vc!
    }

    fileprivate func configureNavBar() {
        navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    }
}

/// MARK: Gesture
extension FavoriteVC {

    fileprivate func addGesture(to view: UIView) {
        let upGesture = Init(UISwipeGestureRecognizer(target: self, action: #selector(FavoriteVC.swipeHandler(_:)))) {
            $0.direction = .up
        }

        let downGesture = Init(UISwipeGestureRecognizer(target: self, action: #selector(FavoriteVC.swipeHandler(_:)))) {
            $0.direction = .down
        }
        view.addGestureRecognizer(upGesture)
        view.addGestureRecognizer(downGesture)
    }

    @objc func swipeHandler(_ sender: UISwipeGestureRecognizer) {
        let indexPath = IndexPath(row: currentIndex, section: 0)
        guard let cell = collectionView?.cellForItem(at: indexPath) as? DemoCollectionViewCell else { return }
        // double swipe Up transition
        if cell.isOpened == true && sender.direction == .up {
            pushToViewController(getViewController())

            if let rightButton = navigationItem.rightBarButtonItem as? AnimatingBarButton {
                rightButton.animationSelected(true)
            }
        }

        let open = sender.direction == .up ? true : false
        cell.cellIsOpen(open)
        cellsIsOpen[indexPath.row] = cell.isOpened
    }
}


internal func Init<Type>(_ value: Type, block: (_ object: Type) -> Void) -> Type {
    block(value)
    return value
}

// MARK: UIScrollViewDelegate

extension FavoriteVC {

    func scrollViewDidScroll(_: UIScrollView) {
        pageLabel.text = "\(currentIndex + 1)/\(items.count)"
    }
}

// MARK: UICollectionViewDataSource

extension FavoriteVC {

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        guard let cell = cell as? DemoCollectionViewCell else { return }

        let index = indexPath.row % items.count
        let info = items[index]
        
        var url = info.imageURL
        if !(url.starts(with: "https:")) {
            url = "https:" + url
        }
        cell.backgroundImageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "Placeholder"))
        cell.customTitle.text = info.title
        cell.cellIsOpen(cellsIsOpen[index], animated: false)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? DemoCollectionViewCell
            , currentIndex == indexPath.row else { return }

        if cell.isOpened == false {
            cell.cellIsOpen(true)
        } else {
            pushToViewController(getViewController())

            if let rightButton = navigationItem.rightBarButtonItem as? AnimatingBarButton {
                rightButton.animationSelected(true)
            }
        }
    }
}

// MARK: UICollectionViewDataSource

extension FavoriteVC {

    override func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DemoCollectionViewCell.self), for: indexPath)
    }
}
