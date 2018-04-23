//
//  HabitViewController.swift
//  Habbit
//
//  Created by Brandon David on 4/15/18.
//  Copyright © 2018 IrisBrandon. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage
import MBProgressHUD

class HabitViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var habitNames: [String] = ["one", "two", "three", "four"]
    var habitIcons: [UIImage] = []
    var habitMap: [String: UIImage] = [:]
    
    
    @IBOutlet weak var habitCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        habitCollectionView.delegate = self
        habitCollectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Update the data from Firebase
        updateHabits()
        print("viewWillAppear")
        // Reload the tablebview.
        habitCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("numberOfItemsInSection: ")
        print(habitNames.count)
        return habitNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("cellForItemAt")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "habitCell", for: indexPath) as! HabitViewCell
        cell.habitImageView.image = #imageLiteral(resourceName: "small-image-test")
        cell.habitLabel.text = "hello world"
        print(habitIcons[indexPath.item])
        return cell
    }
    
    
    func updateHabits() {
//        self.habitNames = []
//        self.habitIcons = []
        getHabits() { (habits) in
            if let habits = habits {
                for habit in habits {
                    getDataFromPath(path: habit.habitIconPath, completion: { (data) in
                        if let data = data {
                            if let image = UIImage(data: data) {
                                print("adding to habitNames: " + habit.habitName)
                                self.habitMap[habit.habitName] = image
                                print("habitNames array after appending:")
                                print(self.habitMap.keys)
                                self.habitIcons.append(image)
                                self.habitCollectionView.reloadData()
                            }
                        }
                    })
                }
            }
        }
    }
    

    @IBAction func addHabitButton(_ sender: Any) {
        performSegue(withIdentifier: "segueToAdderVC", sender: self)
    }
    
    @IBAction func unwindToHabitVC(segue:UIStoryboardSegue) { }
    
}
