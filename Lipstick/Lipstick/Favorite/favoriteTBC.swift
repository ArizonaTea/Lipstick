//
//  favoriteTBC.swift
//  Lipstick
//
//  Created by Marvin on 10/24/18.
//  Copyright © 2018 joylink. All rights reserved.
//

import UIKit
import expanding_collection

import UIKit

class favoriteTBC: ExpandingTableViewController {
    
    @IBOutlet weak var btnBack: AnimatingBarButton!
    
    var brandName: String = ""
    var styleNumber: String = ""
    fileprivate var scrollOffsetY: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
    }
}

// MARK: Helpers

extension favoriteTBC {
    
    fileprivate func configureNavBar() {
        navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        navigationItem.rightBarButtonItem?.image = navigationItem.rightBarButtonItem?.image!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
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
