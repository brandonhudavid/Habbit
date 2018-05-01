//
//  HabitStorage.swift
//  Habbit
//
//  Created by Brandon David on 4/15/18.
//  Copyright © 2018 IrisBrandon. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage

let currentUser = CurrentUser()

func addHabit(habitName: String, habitIcon: UIImage) {
    let dbRef = Database.database().reference()
    let habitIconData = UIImageJPEGRepresentation(habitIcon, 1.0)
    let habitIconPath = "HabitIcons/\(UUID().uuidString)"
    
    var habitDays: [String:Bool] = ["sentinel":true]
    let habitDict: [String:AnyObject] = ["habitIconPath": habitIconPath as String as AnyObject,
                                         "habitDays": habitDays as [String:Bool] as AnyObject,
                                         "performedToday": false as Bool as AnyObject]
    dbRef.child(currentUser.id).child(habitName).setValue(habitDict)
    store(data: habitIconData, toPath: habitIconPath)
    
}

func removeHabit(habitName: String) {
    let dbRef = Database.database().reference()
    
    dbRef.child(currentUser.id).child(habitName).removeValue() { (error, dbRef) in
        if error != nil {
            print("error \(error)")
        }
    }
}

func performHabit(habitName: String) {
    let dbRef = Database.database().reference()
    // Turn date into string format
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM-dd"
    let dateString = dateFormatter.string(from: Date())
    // Store date in database, set performedToday to true
    dbRef.child(currentUser.id).child(habitName).child("habitDays").child(dateString).setValue(true)
    dbRef.child(currentUser.id).child(habitName).child("performedToday").setValue(true)
}

func store(data: Data?, toPath path: String) {
    let storageRef = Storage.storage().reference()
    storageRef.child(path).putData(data!, metadata: nil) { (metadata, error) in
        if let error = error {
            print(error)
        }
    }
}

func getHabits(completionHandler: @escaping ([Habit]) -> ()) {
    let dbRef = Database.database().reference()
    var habitArray: [Habit] = []
    dbRef.child(currentUser.id).observeSingleEvent(of: .value, with: { snapshot -> Void in
        if snapshot.exists() {
            // Iterates through user's habits, adding them to habitArray
            if let habits = snapshot.value as? [String : [String : Any]] {
                for (key, value) in habits {
                    // Creating instance variables for Habit object
                    let habitName: String = key
                    if let iconPath = value["habitIconPath"] as? String, let days = value["habitDays"] as? [String:Bool],
                        let performed = value["performedToday"] as? Bool {
                        let habitIconPath = iconPath
                        let habitDays = days
                        let performedToday = performed
                        
                        // Instantiates a Habit object and adds to habitArray
                        let newHabit = Habit(habitName: habitName, habitIconPath: habitIconPath, habitDays: habitDays, performedToday: performedToday)
                        habitArray.append(newHabit) // Appends to habitArray
                    }
                }
                completionHandler(habitArray)
            }
        }
    })
    completionHandler([])
}

//func getHabitDaysPerformed(completionHandler: @escaping ([Habit]) -> ()) {
//    let dbRef = Database.database().reference()
//    var habitArray: [Habit] = []
//    dbRef.child(currentUser.id).observeSingleEvent(of: .value, with: { snapshot -> Void in
//        if snapshot.exists() {
//            // Iterates through user's habits, adding them to habitArray
//            if let habits = snapshot.value as? [String : [String : Any]] {
//                for (key, value) in habits {
//                    // Creating instance variables for Habit object
//                    let habitName: String = key
//                    if let iconPath = value["habitIconPath"] as? String, let days = value["habitDays"] as? [String:Bool],
//                        let performed = value["performedToday"] as? Bool {
//                        let habitIconPath = iconPath
//                        let habitDays = days
//                        let performedToday = performed
//
//                        // Instantiates a Habit object and adds to habitArray
//                        let newHabit = Habit(habitName: habitName, habitIconPath: habitIconPath, habitDays: habitDays, performedToday: performedToday)
//                        habitArray.append(newHabit) // Appends to habitArray
//                    }
//                }
//                completionHandler(habitArray)
//            }
//        }
//    })
//    completionHandler([])
//}

func getHabitDaysPerformed(completionHandler: @escaping ([String:[String]]) -> ()) {
    let dbRef = Database.database().reference()
    var habitDaysMap: [String:[String]] = [:]
    dbRef.child(currentUser.id).observeSingleEvent(of: .value, with: { snapshot -> Void in
        if snapshot.exists() {
            print("snapshot exists")
            // Iterates through user's habits
            if let habits = snapshot.value as? [String : [String : Any]] {
                for (key, value) in habits {
                    // Creating instance variables for Habit object
                    let habitName: String = key
                    if let days = value["habitDays"] as? [String:Bool] {
                        var daysArray: [String] = []
                        for (day, _) in days {
                            daysArray.append(day)
                        }
                        habitDaysMap[habitName] = daysArray
                    }
                }
                print("from getHabitDaysPerformed:")
                print(habitDaysMap)
                completionHandler(habitDaysMap)
            }
        }
    })
    completionHandler([:])
}

func getDataFromPath(path: String, completion: @escaping (Data?) -> Void) {
    let storageRef = Storage.storage().reference()
    storageRef.child(path).getData(maxSize: 5 * 1024 * 1024) { (data, error) in
        if let error = error {
            print(error)
        }
        if let data = data {
            completion(data)
        } else {
            completion(nil)
        }
    }
}
