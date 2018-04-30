//
//  HabitViewCell.swift
//  Habbit
//
//  Created by Brandon David on 4/22/18.
//  Copyright © 2018 IrisBrandon. All rights reserved.
//

import Foundation
import UIKit

protocol HabitViewCellDelegate: class {
    func delete(cell: HabitViewCell)
}

class HabitViewCell: UICollectionViewCell {
    
    @IBOutlet weak var habitImageView: UIImageView!
    @IBOutlet weak var habitCheck: UIImageView!
    @IBOutlet weak var habitLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var delegate: HabitViewCellDelegate?
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        delegate?.delete(cell: self)
    }
}
