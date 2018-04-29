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
import G3GridView
import BouncyLayout


extension UILabel {
    func addCharacterSpacing() {
        if let labelText = text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedStringKey.kern, value: 1.15, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}

extension HabitViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
//        cell.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.50) {
            cell.alpha = 1
        }
    }
}

class HabitViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var habitNames: [String] = []
    var habitIcons: [String:UIImage] = [:]
    var habitsPerformed: [String:Bool] = [:]
    var arrayChanged: Bool = false
    
    @IBOutlet weak var welcomeText: UILabel!
    
    @IBOutlet weak var habitCollectionView: UICollectionView!
    let layout = BouncyLayout()
    
    
    override func viewDidLoad() {
        updateHabits()
//        welcomeText.addCharacterSpacing()
        super.viewDidLoad()
        habitCollectionView.delegate = self
        habitCollectionView.dataSource = self
        habitCollectionView.collectionViewLayout = layout
        self.view.backgroundColor = UIColor.init(red: 255.0/255.0, green: 240.0/255.0, blue: 229.0/255.0, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.habitCollectionView.alpha = 0
        if arrayChanged {
            arrayChanged = !arrayChanged
            updateHabits()
        }
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.50) {
                self.habitCollectionView.alpha = 1
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        habitNames = habitNames.sorted { $0.lowercased() < $1.lowercased() }
        return habitNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "habitCell", for: indexPath) as? HabitViewCell {
            cell.backgroundColor = UIColor.white
            cell.layer.cornerRadius = 10
            
            cell.habitImageView.image = habitIcons[habitNames[indexPath.item]]
            cell.habitLabel.text = habitNames[indexPath.item]
//            cell.habitLabel.addCharacterSpacing()
            if (habitsPerformed[habitNames[indexPath.item]])! {
                cell.habitCheck.image = #imageLiteral(resourceName: "checkmark-icon")
            } else {
                cell.habitCheck.image = nil
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var currentCell = habitCollectionView.cellForItem(at: indexPath) as? HabitViewCell
        if (!habitsPerformed[(currentCell?.habitLabel.text)!]!) {
            performHabit(habitName: (currentCell?.habitLabel.text)!)
            habitsPerformed[(currentCell?.habitLabel.text)!] = true
            currentCell?.habitCheck.image = #imageLiteral(resourceName: "checkmark-icon")
            currentCell?.habitCheck.alpha = 0
            UIView.animate(withDuration: 0.2) {
                currentCell?.habitCheck.alpha = 1
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 120.0, height: 175.0)
    }
    
    func updateHabits() {
        self.habitNames = []
        self.habitIcons = [:]
        self.habitsPerformed = [:]
        getHabits() { (habits) in
            for habit in habits {
                getDataFromPath(path: habit.habitIconPath, completion: { (data) in
                    if let data = data {
                        if let image = UIImage(data: data) {
                            self.habitNames.append(habit.habitName)
                            self.habitIcons[habit.habitName] = image
                            self.habitsPerformed[habit.habitName] = habit.performedToday
                        }
                    }
                    DispatchQueue.main.async(execute: self.habitCollectionView.reloadData)
                })
            }
            UIView.animate(withDuration: 0.50) {
                self.habitCollectionView.alpha = 1
            }
        }
    }

    @IBAction func addHabitButton(_ sender: Any) {
        performSegue(withIdentifier: "segueToAdderVC", sender: self)
    }
    
    @IBAction func unwindToHabitVC(segue:UIStoryboardSegue) { }
    
}
