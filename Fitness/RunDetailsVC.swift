//
//  RunDetailsVC.swift
//  Fitness
//
//  Created by Atay Sultangaziev on 8/2/18.
//  Copyright © 2018 Atay Sultangaziev. All rights reserved.
//

import UIKit

class RunDetailsVC: UIViewController {
    
    var run: Run!
    
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timestampLabel.text = "Timestamp: \(FormatDisplay.date(run.timestamp))"
        distanceLabel.text = "Distance: \(FormatDisplay.distance(run.distance))"
        timeLabel.text = "Duration: \(FormatDisplay.time(Int(run.duration)))"
    }
    
}


