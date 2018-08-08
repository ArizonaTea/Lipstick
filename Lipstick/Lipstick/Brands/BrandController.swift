//
//  ViewController.swift
//  Lipstick
//
//  Created by Marvin on 7/29/18.
//  Copyright © 2018 joylink. All rights reserved.
//

import UIKit
import CollectionKit
import DAOSearchBar

var brandsurl:[String] = ["Dior", "Chanel"]



struct brandCellObject: Codable {
    let name: String
}
class brandCell: UIView {
    let imageView = UIImageView()
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.2
        addSubview(imageView)
        addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: 5, y:5, width: bounds.width-10, height: bounds.height-10)
//        label.frame = CGRect(x: 10, y: 210, width: bounds.width - 20, height: 20)
        
    }
    
    func populate(brandName: brandCellObject) {
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageView.contentMode = .scaleAspectFit // OR .scaleAspectFill
        imageView.clipsToBounds = true

        imageView.image = UIImage(named: brandName.name)
//        label.text = brandName.name
        
//        backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:0)
//        imageView.layer.cornerRadius = 4
//        imageView.layer.shadowColor = UIColor.black.cgColor
//        imageView.layer.shadowRadius = 14
//        imageView.layer.shadowOffset = CGSize(width: 0, height: 14)
//        imageView.layer.shadowOpacity = 0.2
        imageView.image = imageView.image?.roundedImage.addShadow()
    }
    
}


class BrandController: UIViewController{
    @IBOutlet weak var collectionView: CollectionView!
    @IBOutlet weak var logoBackground: UIImageView!
    var searchBarDestinationFrame = CGRect.zero
    var daoSearch: DAOSearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataSource = ArrayDataSource(data: [brandCellObject(name: "Chanel"),brandCellObject(name: "Dior"),brandCellObject(name: "Chanel"),brandCellObject(name: "Dior"),brandCellObject(name: "Chanel"),brandCellObject(name: "Dior"),brandCellObject(name: "Chanel"),brandCellObject(name: "Dior"),brandCellObject(name: "Chanel"),brandCellObject(name: "Dior"),brandCellObject(name: "Chanel"),brandCellObject(name: "Dior"),brandCellObject(name: "Chanel"),brandCellObject(name: "Dior"),brandCellObject(name: "Chanel"),brandCellObject(name: "Dior"),brandCellObject(name: "Chanel"),brandCellObject(name: "Dior"),brandCellObject(name: "Chanel"),brandCellObject(name: "Dior")], identifierMapper: { (index: Int, data: brandCellObject) in
                return String(index)
        })
        let viewSource = ClosureViewSource(viewUpdater: { (view: brandCell, data: brandCellObject, index: Int) in
            view.populate(brandName: data)
        })
        
        let sizeSource = { (index: Int, data: brandCellObject, collectionSize: CGSize) -> CGSize in
            let ratio = (UIImage(named: data.name)?.size.height)! / (UIImage(named: data.name)?.size.width)!
            let width = self.collectionView.frame.size.width / 2 - 20
            return CGSize(width: width, height: width * ratio)
        }
        
        let provider = BasicProvider(
            dataSource: dataSource,
            viewSource: viewSource,
            sizeSource: sizeSource,
            animator: WobbleAnimator(),
            tapHandler: { [weak self] context in
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CatagoriesController") as? CatagoriesController
                self?.present(vc!, animated: true, completion: nil)
            }
        )
        provider.layout = WaterfallLayout(columns: 2, spacing: 10) // FlowLayout(spacing: 10, justifyContent: .center)
        collectionView.provider = provider
        collectionView.contentInset = UIEdgeInsets(top: 90, left: 0, bottom: 40, right: 0)
        collectionView.delegate = self
        self.daoSearch = DAOSearchBar.init(frame: CGRect(x: self.view.frame.width - 53, y: 20, width: 45, height: 45))
        self.daoSearch.searchOffColor = UIColor.white
        self.daoSearch.searchOnColor = UIColor.darkGray
        self.daoSearch.searchBarOffColor = UIColor.darkGray
        self.daoSearch.searchBarOnColor = UIColor.white
        self.daoSearch.delegate = self;
        self.searchBarDestinationFrame = CGRect(x: 8, y: 20, width: self.view.bounds.width - 16, height: 45)
        self.view.addSubview(daoSearch)
        
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
        let progress = tween(offset: -collectionView.contentOffset.y, start: 75, end: 0)
        let clamped = min(1, max(0, progress))
        let backgroundRect = mix(progress: clamped,
                                 start: CGRect(x: 20, y: 0, width: bounds.width - 40, height: 75),
                                 end: CGRect(x: 0, y: 0, width: bounds.width, height: 75))
        if clamped != 1.0 {
            if progress < 0.99 {
                logoBackground.image = UIImage(named: "Metron")
            }
            logoBackground.frame = CGRect(x: backgroundRect.minX,
                                            y: backgroundRect.minY + -progress * 10,
                                            width: backgroundRect.width,
                                            height: backgroundRect.height + -progress * 40)
            logoBackground.autoresizesSubviews = true
            if self.daoSearch.state == DAOSearchBarState.searchBarVisible {
                self.daoSearch.changeStateIfPossible()
            }
//            self.daoSearch.frame = CGRect(x: self.view.frame.width - 50, y: 20, width: 34, height: 34.0)
        } else {
            if progress > 1.02 {
                logoBackground.image = UIImage(named: "topRed")
            }
            logoBackground.frame = CGRect(x: backgroundRect.minX,
                                          y: backgroundRect.minY - 10,
                                          width: backgroundRect.width,
                                          height: backgroundRect.height)
            logoBackground.autoresizesSubviews = true
            if self.daoSearch.state == DAOSearchBarState.normal {
                self.daoSearch.changeStateIfPossible()
            }
//            self.daoSearch.frame = self.searchBarDestinationFrame
            
        }
    }

}

extension BrandController: DAOSearchBarDelegate {
    // MARK: SearchBar Delegate
    func destinationFrameForSearchBar(_ searchBar: DAOSearchBar) -> CGRect {
        return self.searchBarDestinationFrame
    }
    
    func searchBar(_ searchBar: DAOSearchBar, willStartTransitioningToState destinationState: DAOSearchBarState) {
        // Do whatever you deem necessary.
    }
    
    func searchBar(_ searchBar: DAOSearchBar, didEndTransitioningFromState previousState: DAOSearchBarState) {
        // Do whatever you deem necessary.
    }
    
    func searchBarDidTapReturn(_ searchBar: DAOSearchBar) {
        // Do whatever you deem necessary.
        // Access the text from the search bar like searchBar.searchField.text
    }
    
    func searchBarTextDidChange(_ searchBar: DAOSearchBar) {
        // Do whatever you deem necessary.
        // Access the text from the search bar like searchBar.searchField.text
    }
}


extension BrandController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        layoutLogo()
    }
}

extension UIImage {
    
    func addShadow(blurSize: CGFloat = 2.0) -> UIImage {
        
        let shadowColor = UIColor(white:0.3, alpha:0.7).cgColor
        
        let context = CGContext(data: nil,
                                width: Int(self.size.width + blurSize),
                                height: Int(self.size.height + blurSize),
                                bitsPerComponent: self.cgImage!.bitsPerComponent,
                                bytesPerRow: 0,
                                space: CGColorSpaceCreateDeviceRGB(),
                                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        context.setShadow(offset: CGSize(width: blurSize/2,height: -blurSize/2),
                          blur: blurSize,
                          color: shadowColor)
        context.draw(self.cgImage!,
                     in: CGRect(x: 0, y: blurSize, width: self.size.width, height: self.size.height),
                     byTiling:false)
        
        return UIImage(cgImage: context.makeImage()!)
    }
    
    var roundedImage: UIImage {
        let rect = CGRect(origin:CGPoint(x: 0, y: 0), size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1)
        UIBezierPath(
            roundedRect: rect,
            cornerRadius: 10
            ).addClip()
        self.draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
}
