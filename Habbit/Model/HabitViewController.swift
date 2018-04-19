//
//  HabitViewController.swift
//  Habbit
//
//  Created by Brandon David on 4/15/18.
//  Copyright © 2018 IrisBrandon. All rights reserved.
//

import Foundation
import UIKit

class HabitViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    @IBAction func addHabitButton(_ sender: Any) {
        performSegue(withIdentifier: "segueToAdderVC", sender: self)
    }
    
    @IBAction func unwindToHabitVC(segue:UIStoryboardSegue) { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
