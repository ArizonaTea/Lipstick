//
//  mainTab.swift
//  Lipstick
//
//  Created by Marvin on 9/30/18.
//  Copyright © 2018 joylink. All rights reserved.
//

import UIKit


class mainTab: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc1 = storyboard.instantiateViewController(withIdentifier: "BrandController")
        let vc2 = storyboard.instantiateViewController(withIdentifier: "FavoriteVC")
        let vc3 = storyboard.instantiateViewController(withIdentifier: "ColourboardVC")
        self.viewControllers = [vc1, vc2, vc3]
        let tabBarItems = tabBar.items! as [UITabBarItem]
        tabBarItems[0].title = "Brands"
        tabBarItems[0].image = UIImage.init(named: "lipstick")
        tabBarItems[1].title = "Favorite"
        tabBarItems[1].image = UIImage.init(named: "favorite")
        tabBarItems[2].title = "Colourboard"
        tabBarItems[2].image = UIImage.init(named: "colors")
        
    }
    
    //Delegate methods
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if(self.selectedIndex == 0) {
            if viewController is BrandController {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc1 = storyboard.instantiateViewController(withIdentifier: "AllLipsticksVC")
                self.viewControllers?[0] = vc1
                let tabBarItems = tabBar.items! as [UITabBarItem]
                
                tabBarItems[0].title = "All"
                let img = UIImage.init(named: "all.png")
                tabBarItems[0].image = img
                
                return false
            }
            else if viewController is AllLipsticksVC {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc1 = storyboard.instantiateViewController(withIdentifier: "BrandController")
                self.viewControllers?[0] = vc1
                
                let tabBarItems = tabBar.items! as [UITabBarItem]
                tabBarItems[0].title = "Brands"
                let img = UIImage.init(named: "lipstick")
                tabBarItems[0].image = img
                return false
            }
        }
        return true;
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
