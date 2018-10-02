//
//  SettingsVC.swift
//  Lipstick
//
//  Created by Marvin on 10/2/18.
//  Copyright © 2018 joylink. All rights reserved.
//

import UIKit
import ReactiveCocoa

class SettingsVC: UIViewController {
    @IBOutlet weak var btnDone: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func didTapDone(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
