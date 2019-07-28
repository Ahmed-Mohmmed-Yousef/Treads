//
//  RunLogCell.swift
//  Treads
//
//  Created by Ahmed on 7/28/19.
//  Copyright © 2019 Ahmed, ORG. All rights reserved.
//

import UIKit

class RunLogCell: UITableViewCell {

    @IBOutlet weak var runDurationLbl: UILabel!
    @IBOutlet weak var totalDistanceLbl: UILabel!
    @IBOutlet weak var avgPaceLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(run: Run){
        runDurationLbl.text = run.duration.formatTimeDurationToString()
        totalDistanceLbl.text = "\(run.distance.metersToMilies(places: 2)) mi"
        avgPaceLbl.text = "\(run.pace.formatTimeDurationToString())"
        dateLbl.text = run.date.getDateString() 
    }

}
