//
//  MinerTableCell.swift
//  Lazy Mining
//
//  Created by Admin on 3/7/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class MinerTableCell: UITableViewCell {
    @IBOutlet weak var rigNameLabel: UILabel!
    @IBOutlet weak var ipLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var sumSpeedValueLabel: UILabel!
    @IBOutlet weak var sharesValueLabel: UILabel!
    @IBOutlet weak var upTimeValueLabel: UILabel!
    @IBOutlet weak var poolsValueLabel: UILabel!
    @IBOutlet weak var rejectValueLabel: UILabel!
    @IBOutlet weak var gpuTextView: UITextView!

    @IBOutlet weak var bgView: UIView!
    
    var tempsValues: Array<Substring> = []
    
    

    
}
