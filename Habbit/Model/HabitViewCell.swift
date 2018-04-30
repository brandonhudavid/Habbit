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
    
    @IBOutlet weak var habitCell: UIView!
    @IBOutlet weak var habitImageView: UIImageView!
    @IBOutlet weak var habitCheck: UIImageView!
    @IBOutlet weak var habitLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var delegate: HabitViewCellDelegate?
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Are you sure?", message: "Do you want to delete the habit \"" + habitLabel.text! + "\"?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            self.delegate?.delete(cell: self)
        })
        let cancelAction = UIAlertAction (title: "Cancel", style: .default, handler: nil)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        (self.delegate as! UIViewController).present(alertController, animated: true, completion: nil)
    }
}
