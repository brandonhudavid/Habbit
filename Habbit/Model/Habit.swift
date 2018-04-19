//
//  Habit.swift
//  Habbit
//
//  Created by Brandon David on 4/18/18.
//  Copyright © 2018 IrisBrandon. All rights reserved.
//

import Foundation
import UIKit

class Habit {
    let habitName: String
    let habitIcon: UIImage
    let daysPerformed: [String]
    let color: String
    
    init(habitName: String, habitIcon: UIImage, daysPerformed: [String], color: String) {
        self.habitName = habitName
        self.habitIcon = habitIcon
        self.daysPerformed = daysPerformed
        self.color = color
    }
}
