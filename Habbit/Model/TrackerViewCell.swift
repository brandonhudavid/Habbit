//
//  TrackerViewCell.swift
//  Habbit
//
//  Created by Brandon David on 4/27/18.
//  Copyright © 2018 IrisBrandon. All rights reserved.
//

import Foundation
import G3GridView

class TrackerViewCell: GridViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    
    static var nib: UINib {
        return UINib(nibName: "TrackerViewCell", bundle: Bundle(for: self))
    }
    
    let lightOrange: UIColor = UIColor.init(red: 255/255, green: 240/255, blue: 229/255, alpha: 1)
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.dayLabel.text = ""
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.white.cgColor
        self.backgroundColor = lightOrange
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
