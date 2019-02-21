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
        let navController1 = UINavigationController(rootViewController: vc1)
         navController1.navigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 0)
        
        let vc2 = storyboard.instantiateViewController(withIdentifier: "CollectionVC")
        let navController2 = UINavigationController(rootViewController: vc2)
        navController1.navigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 0)
        
        let vc3 = storyboard.instantiateViewController(withIdentifier: "ColourboardVC")
        let navController3 = UINavigationController(rootViewController: vc3)
//        let navController1 = UINavigationController(rootViewController: vc!)
//        let navController1 = UINavigationController(rootViewController: vc!)
//        let navController1 = UINavigationController(rootViewController: vc!)

        self.viewControllers = [navController1, navController2, navController3]
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
        if (viewController.childViewControllers.count > 1) {
            return true;
        }
        if(self.selectedIndex == 0) {
            if viewController.childViewControllers.first is BrandController {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc1 = storyboard.instantiateViewController(withIdentifier: "AllLipsticksVC")
                let navController = UINavigationController(rootViewController: vc1)
                self.viewControllers?[0] = navController
                let tabBarItems = tabBar.items! as [UITabBarItem]
                
                tabBarItems[0].title = "All"
                let img = UIImage.init(named: "all.png")
                tabBarItems[0].image = img
                
                return false
            }
            else if viewController.childViewControllers.first is AllLipsticksVC {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc1 = storyboard.instantiateViewController(withIdentifier: "BrandController")
                let navController = UINavigationController(rootViewController: vc1)
                self.viewControllers?[0] = navController
                
                let tabBarItems = tabBar.items! as [UITabBarItem]
                tabBarItems[0].title = "Brands"
                let img = UIImage.init(named: "lipstick")
                tabBarItems[0].image = img
                return false
            }
        }
        return true;
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
 

}
