//
//  DaysBtwnCell.swift
//  ChangeSite
//
//  Created by Emily Mittleman on 8/13/21.
//  Copyright © 2021 Emily Mittleman. All rights reserved.
//

import UIKit

class DaysBtwnCell: UITableViewCell {

  @IBOutlet weak var daysBtwn: UILabel!
  @IBOutlet weak var stepper: UIStepper!
  @IBAction func stepperChanged(_ sender: Any) {
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code

    stepper.autorepeat = true
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

}

protocol DaysBtwnCellDelegate {
  func stepperWasChanged()
}
