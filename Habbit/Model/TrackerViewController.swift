//
//  TrackerViewController.swift
//  Habbit
//
//  Created by Iris on 4/18/18.
//  Copyright © 2018 IrisBrandon. All rights reserved.
//

import Foundation
import UIKit
import G3GridView

var updateGrid: Bool = false

class TrackerViewController: UIViewController {
    
    var habitNames: [String] = []
    let lightOrange = UIColor.init(red: 255/255, green: 240/255, blue: 229/255, alpha: 1)
    let darkOrange = UIColor.init(red: 249/255, green: 169/255, blue: 75/255, alpha: 1)
    
    @IBOutlet weak var trackerGridView: GridView!
    
    override func viewDidLoad() {
        updateTracker()
        super.viewDidLoad()
        trackerGridView.register(TrackerViewCell.nib, forCellWithReuseIdentifier: "TrackerViewCell")
        trackerGridView.isInfinitable = false
        trackerGridView.dataSource = self
        trackerGridView.delegate = self
        self.trackerGridView.alpha = 0
        UIView.animate(withDuration: 0.50) {
            self.trackerGridView.alpha = 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if updateGrid {
            updateGrid = !updateGrid
            updateTracker()
        }
    }

    
    func updateTracker() {
        self.habitNames = []
        getHabits() { (habits) in
            for habit in habits {
                self.habitNames.append(habit.habitName)
            }
            DispatchQueue.main.async(execute: self.trackerGridView.reloadData)
        }
    }
}


extension TrackerViewController: GridViewDataSource, GridViewDelegate {
    

    func gridView(_ gridView: GridView, numberOfRowsInColumn column: Int) -> Int {
        habitNames = habitNames.sorted { $0.lowercased() < $1.lowercased() }
        // compensate for bottom 2 rows getting cut off
        return habitNames.count + 2
    }

    func numberOfColumns(in gridView: GridView) -> Int {
        return 8
    }
    
    func gridView(_ gridView: GridView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func gridView(_ gridView: GridView, widthForColumn column: Int) -> CGFloat {
        if column == 0 {
            return 100
        } else {
            return 45
        }
    }
    

    func gridView(_ gridView: GridView, cellForRowAt indexPath: IndexPath) -> GridViewCell {
        if let cell = gridView.dequeueReusableCell(withReuseIdentifier: "TrackerViewCell", for: indexPath) as? TrackerViewCell {
            cell.layer.borderWidth = 2.0
            cell.layer.borderColor = UIColor.white.cgColor
            cell.backgroundColor = lightOrange
            switch indexPath.row {
            case 0:
                switch indexPath.column {
                case 1:
                    cell.dayLabel.text = "Sun"
                case 2:
                    cell.dayLabel.text = "Mon"
                case 3:
                    cell.dayLabel.text = "Tues"
                case 4:
                    cell.dayLabel.text = "Wed"
                case 5:
                    cell.dayLabel.text = "Thurs"
                case 6:
                    cell.dayLabel.text = "Fri"
                case 7:
                    cell.dayLabel.text = "Sat"
                default:
                    cell.dayLabel.text = ""
                }
            case habitNames.count + 1:
                cell.backgroundColor = UIColor.white
                cell.dayLabel.text = ""
            default:
                if indexPath.column == 0 {
                    cell.dayLabel.text = habitNames[indexPath.row - 1]
                }
            }
            return cell
        } else {
            return GridViewCell()
        }
    }

}


