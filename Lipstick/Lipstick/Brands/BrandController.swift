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



struct brandCellObject: Codable {
    let name: String
}
class brandCell: UIView {
    let imageView = UIImageView()
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 4
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 14
        layer.shadowOffset = CGSize(width: 0, height: 14)
        layer.shadowOpacity = 0.2
        addSubview(imageView)
        addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: 5, y:5, width: bounds.width-10, height: bounds.width-10)
//        label.frame = CGRect(x: 10, y: 210, width: bounds.width - 20, height: 20)
        
    }
    
    func populate(brandName: brandCellObject) {
        imageView.image = UIImage(named: brandName.name)
//        label.text = brandName.name
        backgroundColor = .gray
    }
    
}


class BrandController: UIViewController{
    @IBOutlet weak var collectionView: CollectionView!
    @IBOutlet weak var logoBackground: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let dataSource = ArrayDataSource(data: [brandCellObject(name: "Chanel"),brandCellObject(name: "Dior"),brandCellObject(name: "Chanel"),brandCellObject(name: "Dior"),brandCellObject(name: "Chanel"),brandCellObject(name: "Dior"),brandCellObject(name: "Chanel"),brandCellObject(name: "Dior"),brandCellObject(name: "Chanel"),brandCellObject(name: "Dior")], identifierMapper: { (index: Int, data: brandCellObject) in
                return String(index)
        })
        let viewSource = ClosureViewSource(viewUpdater: { (view: brandCell, data: brandCellObject, index: Int) in
            view.populate(brandName: data)
        })
        
        let sizeSource = { (index: Int, data: brandCellObject, collectionSize: CGSize) -> CGSize in
            return CGSize(width: self.collectionView.frame.size.width / 2 - 20, height: self.collectionView.frame.size.width / 2 - 20)
        }
        
        let provider = BasicProvider(
            dataSource: dataSource,
            viewSource: viewSource,
            sizeSource: sizeSource,
            tapHandler: { [weak self] context in
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CatagoriesController") as? CatagoriesController
                self?.present(vc!, animated: true, completion: nil)
            }
        )
        provider.animator = FadeAnimator()
        provider.layout =  FlowLayout(spacing: 10, justifyContent: .center)
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
