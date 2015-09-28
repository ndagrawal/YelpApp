//
//  SwitchTableViewCell.swift
//  Yelp
//
//  Created by Nilesh Agrawal on 9/26/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit


@objc protocol SwitchTableViewDelegate{
    func switchCell(switchCell:SwitchTableViewCell ,didChangeValue value:Bool)
}
class SwitchTableViewCell: UITableViewCell {

    @IBOutlet weak var tableViewCellLabel: UILabel!
    @IBOutlet weak var selectSwitch: UISwitch!
    weak var delegate:SwitchTableViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectSwitch.setOn(false, animated: false)
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func selectSwitchSelected(sender: AnyObject) {
        if selectSwitch.on {
           delegate?.switchCell(self, didChangeValue: true)
        }else{
            delegate?.switchCell(self, didChangeValue: false)
        }
    }

}
