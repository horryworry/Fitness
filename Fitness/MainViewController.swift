//
//  MainViewController.swift
//  Fitness
//
//  Created by Atay Sultangaziev on 8/1/18.
//  Copyright © 2018 Atay Sultangaziev. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    @IBAction func savedRunsButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "SavedRunsTVC", sender: nil)
    }
    
    
    @IBAction func recordNewRunButtonPressed(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "NewRunViewController", sender: nil)
        
    }
    
    
}
