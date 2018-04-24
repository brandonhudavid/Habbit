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

func addHabit(habitName: String, habitIcon: UIImage, habitColor: String) {
    let dbRef = Database.database().reference()
    let habitIconData = UIImageJPEGRepresentation(habitIcon, 1.0)
    let habitIconPath = "HabitIcons/\(UUID().uuidString)"
    
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "MM-dd-yyyy"
//    let dateString = dateFormatter.string(from: Date())
    var habitDays: [String] = ["sentinel"]
    let habitDict: [String:AnyObject] = ["habitIconPath": habitIconPath as String as AnyObject,
                                         "habitDays": habitDays as [String] as AnyObject,
                                         "habitColor": habitColor as String as AnyObject]
    dbRef.child(currentUser.id).child(habitName).setValue(habitDict)
    store(data: habitIconData, toPath: habitIconPath)
    
}

func store(data: Data?, toPath path: String) {
    let storageRef = Storage.storage().reference()
    storageRef.child(path).putData(data!, metadata: nil) { (metadata, error) in
        if let error = error {
            print(error)
        }
    }
}

func getHabits(completion: @escaping ([Habit]?) -> Void) {
    let dbRef = Database.database().reference()
    var habitArray: [Habit] = []
    dbRef.child(currentUser.id).observeSingleEvent(of: .value, with: { snapshot -> Void in
        if snapshot.exists() {
            // Each user's node maps habitName strings to another map that maps attribute names to their respective objects
            if let habits = snapshot.value as? [String : [String : Any]] {
                for (key, value) in habits {
                    print("key: " + key)
                    let habitName: String = key
                    if let iconPath = value["habitIconPath"] as? String, let days = value["habitDays"] as? [String],
                    let color = value["habitColor"] as? String {
                        let habitIconPath = iconPath
                        let habitDays = days
                        let habitColor = color
                        let newHabit = Habit(habitName: habitName, habitIconPath: habitIconPath, habitDays: habitDays, habitColor: habitColor)
                        habitArray.append(newHabit)
                    } else {
                    completion(nil)
                    }
                }
                completion(habitArray)
            } else {
                completion(nil)
            }
        } else {
            completion(nil)
        }
    })
}

func getDataFromPath(path: String, completion: @escaping (Data?) -> Void) {
    let storageRef = Storage.storage().reference()
    storageRef.child(path).getData(maxSize: 5 * 1024 * 1024) { (data, error) in
        if let error = error {
            print("there was an error :(")
        }
        if let data = data {
            completion(data)
            print("getDataFromPath successful")
        } else {
            completion(nil)
        }
    }
}
