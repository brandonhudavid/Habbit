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

extension Date {
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }
}

class TrackerViewController: UIViewController {
    
    var habitNames: [String] = []
    var habitDaysMap: [String:[String]] = [:]
    let lightOrange = UIColor.init(red: 255/255, green: 240/255, blue: 229/255, alpha: 1)
    let darkOrange = UIColor.init(red: 249/255, green: 169/255, blue: 75/255, alpha: 1)
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    
    func getDayOfWeekFromDaysAgo(daysAgo: Int) -> String {
        let todayDate = NSDate()
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier(rawValue: NSGregorianCalendar))
        let myComponents = myCalendar?.components(.NSWeekdayCalendarUnit, from: todayDate as Date)
        let weekDay = myComponents?.weekday
        var dayOfWeek = weekDay! - daysAgo - 1
        if dayOfWeek < 0 {
            dayOfWeek = 7 + dayOfWeek
        }
        switch (dayOfWeek) {
        case 0:
            return "Sun"
        case 1:
            return "Mon"
        case 2:
            return "Tues"
        case 3:
            return "Wed"
        case 4:
            return "Thurs"
        case 5:
            return "Fri"
        case 6:
            return "Sat"
        default:
            return "error"
        }
    }
    
    
    @IBOutlet weak var trackerGridView: GridView!
    
    override func viewDidLoad() {
        updateTracker()
        super.viewDidLoad()
        dateFormatter.dateFormat = "MM-dd"
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
        self.trackerGridView.alpha = 0
        UIView.animate(withDuration: 0.2) {
            self.trackerGridView.alpha = 1
        }
    }

    
    func updateTracker() {
        self.habitNames = []
        self.habitDaysMap = [:]
            getHabitDaysPerformed() { (habitsToDays) in
                getHabits() { (habits) in
                    for habit in habits {
                        self.habitNames.append(habit.habitName)
                    }
                print("habitToDays")
                print(habitsToDays)
                for habit in habits {
                    print("habitName")
                    print(habit.habitName)
                    print("value")
                    print(habitsToDays[habit.habitName])
                    print("unwrapped")
                    print(habitsToDays[habit.habitName]!)
                    self.habitDaysMap[habit.habitName] = habitsToDays[habit.habitName]!
                    self.trackerGridView.reloadData()
                }
                print("within closure")
                print(self.habitDaysMap)
            }
        }
    }
    
//    func updateDays() {
//        self.habitDaysMap = [:]
//        getHabitDaysPerformed() { (habitsToDays) in
//            self.habitDaysMap = habitsToDays
//            self.trackerGridView.reloadData()
//        }
//    }
    
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
        if indexPath.row == 0 {
            return 90
        }
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
            // row 0: days of week
            case 0:
                if indexPath.column == 0 {
                    cell.dayLabel.text = ""
                } else {
                    cell.dayLabel.text = getDayOfWeekFromDaysAgo(daysAgo: 7 - indexPath.column)
                }
            // last row: dummy white row
            case habitNames.count + 1:
                cell.backgroundColor = UIColor.white
                cell.dayLabel.text = ""
            default:
                if indexPath.column == 0 {
                    cell.dayLabel.text = habitNames[indexPath.row - 1]
                } else {
                    let dateColumn = getDayOfWeekFromDaysAgo(daysAgo: 7 - indexPath.column)
                    print(self.habitNames)
                    print(self.habitDaysMap)
                    if self.habitDaysMap[self.habitNames[indexPath.row - 1]] != nil {
                        if self.habitDaysMap[self.habitNames[indexPath.row - 1]]!.contains(dateColumn) {
                            cell.backgroundColor = UIColor.green
                        }
                    }
                }
            }
            return cell
        } else {
            return GridViewCell()
        }
    }

}


