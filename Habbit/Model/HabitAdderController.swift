//
//  HabitAdderController.swift
//  Habbit
//
//  Created by Brandon David on 4/18/18.
//  Copyright © 2018 IrisBrandon. All rights reserved.
//

import Foundation
import UIKit

class HabitAdderController: UIViewController {
    
    @IBOutlet weak var habitName: UITextField!
    
    @IBOutlet weak var habitColor: UITextField!
    
    @IBAction func adderButton(_ sender: Any) {
        addHabit(habitName: habitName.text!, habitIcon: #imageLiteral(resourceName: "small-image-test"), habitColor: habitColor.text!)
        performSegue(withIdentifier: "unwindSegueToHabitVC", sender: self)
    }
    
    //
//    @IBOutlet weak var habitName: UITextField!
//    @IBOutlet weak var habitColor: UITextField!
//
//    @IBAction func addButton(_ sender: Any) {
//        if let name = habitName.text, let color = habitColor.text {
//            addHabit(habitName: name, habitIcon: #imageLiteral(resourceName: "eecs_rsf"), habitColor: color)
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

