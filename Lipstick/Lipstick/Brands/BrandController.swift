//
//  ViewController.swift
//  Lipstick
//
//  Created by Marvin on 7/29/18.
//  Copyright © 2018 joylink. All rights reserved.
//

import UIKit
import CollectionKit
var brandsurl:[String] = ["Dior", "Chanel"]
class BrandController: UIViewController{
    @IBOutlet weak var collectionView: CollectionView!
    @IBOutlet weak var logoBackground: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let dataSource = ArrayDataSource(data: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20])
        let viewSource = ClosureViewSource(viewUpdater: { (view: UILabel, data: Int, index: Int) in
            view.backgroundColor = .green
            view.text = "\(data)"
        })
        
        let sizeSource = { (index: Int, data: Int, collectionSize: CGSize) -> CGSize in
            return CGSize(width: self.collectionView.frame.size.width / 2 - 20, height: self.collectionView.frame.size.width / 2 - 20)
        }
        let provider = BasicProvider(
            dataSource: dataSource,
            viewSource: viewSource,
            sizeSource: sizeSource
        )
        provider.layout = FlowLayout(spacing: 10, justifyContent: .center)
        collectionView.provider = provider
        collectionView.contentInset = UIEdgeInsets(top: 100, left: 0, bottom: 40, right: 0)
        collectionView.delegate = self
    }
    
    func tween(offset: CGFloat, start: CGFloat, end: CGFloat) -> CGFloat {
        return (offset - start) / (end - start)
    }
    
    func mix(progress: CGFloat, start: CGRect, end: CGRect) -> CGRect {
        return CGRect(x: start.minX + progress * (end.minX - start.minX),
                      y: start.minY + progress * (end.minY - start.minY),
                      width: start.width + progress * (end.width - start.width),
                      height: start.height + progress * (end.height - start.height))
    }
    
    func layoutLogo() {
        let bounds = view.bounds
        let progress = tween(offset: -collectionView.contentOffset.y, start: 100, end: 0)
//        print(progress)
        let clamped = min(1, max(0, progress))
        print(clamped)
        let fieldRect = mix(progress: clamped,
                            start: CGRect(x: 30, y: 100, width: bounds.width - 40, height: 40),
                            end: CGRect(x: 20, y: 50, width: bounds.width - 40, height: 40))
        let backgroundRect = mix(progress: clamped,
                                 start: CGRect(x: 20, y: 0, width: bounds.width - 40, height: 100),
                                 end: CGRect(x: 0, y: 0, width: bounds.width, height: 100))
        if clamped != 1.0 {
            print("enter 0")
            if progress < 0.99 {
                logoBackground.image = UIImage(named: "Metron")
            }
            logoBackground.frame = CGRect(x: backgroundRect.minX,
                                            y: backgroundRect.minY + -progress * 10,
                                            width: backgroundRect.width,
                                            height: backgroundRect.height + -progress * 40)
            logoBackground.autoresizesSubviews = true
            print(logoBackground.frame)
            print("exit 0")
        } else {
            print("enter 1")
            if progress > 1.02 {
                logoBackground.image = UIImage(named: "topRed")
            }
            logoBackground.frame = CGRect(x: backgroundRect.minX,
                                          y: backgroundRect.minY - 10,
                                          width: backgroundRect.width,
                                          height: backgroundRect.height - 40)
            logoBackground.autoresizesSubviews = true
            print(logoBackground.frame)
            print("exit 1")
            
        }
    }
    


}

extension BrandController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        layoutLogo()
    }
}
