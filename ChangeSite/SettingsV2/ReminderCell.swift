//
//  ReminderCell.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 8/13/21.
//  Copyright © 2021 Emily Mittleman. All rights reserved.
//

import UIKit

class ReminderCell: UITableViewCell {
    
    @IBOutlet weak var timingLabel: UILabel!
    @IBOutlet weak var occurrenceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
