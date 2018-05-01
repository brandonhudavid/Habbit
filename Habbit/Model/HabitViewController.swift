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
import Gecco

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
    var blahediting: Bool = false
    
    let username: String = CurrentUser().username
    var welcomeString: String?
    let deleteString = "Tap a habit's icon to edit the habit. \n Or, press the red X to delete."
    
    @IBOutlet weak var welcomeTextView: UIView!
    @IBOutlet weak var welcomeText: UILabel!
    @IBOutlet weak var addBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var habitCollectionView: UICollectionView!
    let layout = BouncyLayout()
    
    
    override func viewDidLoad() {
        updateHabits()
        
        welcomeString = "Welcome back, " + username + "! \n Click an icon below if you \n performed a habit today."
        
//        welcomeText.addCharacterSpacing()
        super.viewDidLoad()
        habitCollectionView.delegate = self
        habitCollectionView.dataSource = self
        habitCollectionView.collectionViewLayout = layout
        self.view.backgroundColor = UIColor.init(red: 255.0/255.0, green: 240.0/255.0, blue: 229.0/255.0, alpha: 1.0)
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        welcomeText.text = welcomeString
        welcomeTextView.layer.shadowColor = UIColor.black.cgColor
        welcomeTextView.layer.shadowOpacity = 0.3
        welcomeTextView.layer.shadowOffset = CGSize.zero
        welcomeTextView.layer.shadowRadius = 7
        welcomeTextView.layer.shouldRasterize = true
        
        habitCollectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
//        let dbRef = Database.database().reference()
//        let currentUser = CurrentUser()
//        dbRef.child(currentUser.id).observeSingleEvent(of: .value, with: { snapshot -> Void in
//            if snapshot.exists() {
//                if let annotationDict = snapshot.value as? [String:Bool] {
//                    if (!annotationDict["seenAnnotation"]!) {
//                        self.presentAnnotation()
//                        turnAnnotationOff()
//                    }
//                }
//            }
//        })
        
        presentAnnotation()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.habitCollectionView.alpha = 0
        if arrayChanged {
            arrayChanged = !arrayChanged
            DispatchQueue.main.async(execute: updateHabits)
        }
        UIView.animate(withDuration: 0.50) {
            self.habitCollectionView.alpha = 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        habitNames = habitNames.sorted { $0.lowercased() < $1.lowercased() }
        return habitNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "habitCell", for: indexPath) as? HabitViewCell {

            if (blahediting) {
                cell.deleteButton.isHidden = false
            } else {
                cell.deleteButton.isHidden = true
            }

            cell.backgroundColor = UIColor.white
            cell.layer.cornerRadius = 10
            
            cell.habitCell.layer.cornerRadius = 10
            cell.habitCell.layer.shadowColor = UIColor.black.cgColor
            cell.habitCell.layer.shadowOpacity = 0.2
            cell.habitCell.layer.shadowOffset = CGSize.init(width: 1.5, height: 1.5)
            cell.habitCell.layer.shadowRadius = 2
            cell.habitCell.layer.shouldRasterize = true
            
            
            cell.delegate = self
            
            cell.habitImageView.image = habitIcons[habitNames[indexPath.item]]
            cell.habitLabel.text = habitNames[indexPath.item]

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
        if !blahediting {
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
                    DispatchQueue.main.async {
                        self.habitCollectionView.reloadData()
                    }
                })
            }
        }
    }
    
    // Delete habits
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        addBarButtonItem.isEnabled = !editing
        self.blahediting = !self.blahediting
        if self.blahediting {
            welcomeText.text = deleteString
        } else {
            welcomeText.text = welcomeString
        }
        self.habitCollectionView.reloadItems(at: self.habitCollectionView.indexPathsForVisibleItems)
    }

    @IBAction func addHabitButton(_ sender: Any) {
        performSegue(withIdentifier: "segueToAdderVC", sender: habitNames)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let habitAdder = segue.destination as? HabitAdderController {
            habitAdder.habitNames = sender as! [String?]
        }
    }
    
    @IBAction func unwindToHabitVC(segue:UIStoryboardSegue) { }
    
    // Tutorial
    func presentAnnotation() {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Annotation") as! AnnotationViewController
        viewController.alpha = 0.8
        present(viewController, animated: true, completion: nil)
    }
    
}

// Deleting habits - delegate extension
extension HabitViewController: HabitViewCellDelegate {
    func delete(cell: HabitViewCell) {
        if let indexPath = habitCollectionView?.indexPath(for: cell) {
            // delete from data source
            removeHabit(habitName: habitNames[indexPath.item])
            // delete from collectionView
            self.habitCollectionView.performBatchUpdates( {
                habitNames.remove(at: indexPath.item)
                self.habitCollectionView.deleteItems(at: [indexPath])
            }) { (finished) in
                self.habitCollectionView.reloadItems(at: self.habitCollectionView.indexPathsForVisibleItems)
            }
        }
    }
}
