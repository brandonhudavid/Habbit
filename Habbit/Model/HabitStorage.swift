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

func addHabit(habitName: String, habitIcon: UIImage, color: String) {
    let dbRef = Database.database().reference()
    let data = UIImageJPEGRepresentation(habitIcon, 1.0)
    let path = "HabitIcons/\(UUID().uuidString)"
    
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "MM-dd-yyyy"
//    let dateString = dateFormatter.string(from: Date())
    var daysPerformed: [String] = []
    let habitDict: [String:AnyObject] = ["habitIcon": habitIcon as UIImage,
                                         "daysPerformed": daysPerformed as [String] as AnyObject,
                                         "color": color as String as AnyObject]
    dbRef.child("Habits").child(habitName).setValue(habitDict)
    store(data: data, toPath: path)
    
}

func store(data: Data?, toPath path: String) {
    let storageRef = Storage.storage().reference()
    storageRef.child(path).putData(data!, metadata: nil) { (metadata, error) in
        if let error = error {
            print(error)
        }
    }
}

func getHabits(user: CurrentUser, completion: @escaping ([Habit]?) -> Void) {
    let dbRef = Database.database().reference()
    var habitArray: [Habit] = []
    dbRef.child("Habits").observeSingleEvent(of: .value, with: { snapshot -> Void in
        if snapshot.exists() {
            if let posts = snapshot.value as? [String:AnyObject] {
                user.getReadPostIDs(completion: { (ids) in
                    for postKey in posts.keys {
                        var newPost = Post(id: postKey, username: posts[postKey]![firUsernameNode] as! String, postImagePath: posts[postKey]![firImagePathNode] as! String, thread: posts[postKey]![firThreadNode] as! String, dateString: posts[postKey]![firDateNode] as! String, read: ids.contains(postKey))
                        postArray.append(newPost)
                    }
                    completion(postArray)
                })
            } else {
                completion(nil)
            }
        } else {
            completion(nil)
        }
    })

}
