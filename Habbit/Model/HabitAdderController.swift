//
//  HabitAdderController.swift
//  Habbit
//
//  Created by Brandon David on 4/18/18.
//  Copyright © 2018 IrisBrandon. All rights reserved.
//

import Foundation
import UIKit
import BouncyLayout

class HabitAdderController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    @IBOutlet weak var habitLabel: UILabel!
    @IBOutlet weak var chooseLabel: UILabel!
    
    @IBOutlet weak var habitName: UITextField!
    
    var iconsArray: [UIImage] = [#imageLiteral(resourceName: "icon-dog"), #imageLiteral(resourceName: "icon-eat"), #imageLiteral(resourceName: "icon-hydrate"), #imageLiteral(resourceName: "icon-shop"), #imageLiteral(resourceName: "icon-run"), #imageLiteral(resourceName: "icon-read"), #imageLiteral(resourceName: "icon-yoga"), #imageLiteral(resourceName: "icon-sleep"), #imageLiteral(resourceName: "icon-health"), #imageLiteral(resourceName: "icon-call-parents")]
    var selectedIcon: UIImage? = nil
    var currentCell: IconImageCell? = nil
    
    @IBOutlet weak var iconCollectionView: UICollectionView!
    let layout = BouncyLayout()
    
    @IBOutlet weak var buttonText: UIButton!
    
    @IBAction func adderButton(_ sender: Any) {
        if habitName.text == "" || (habitName.text?.trimmingCharacters(in: .whitespaces).isEmpty)!  {
            let alertController = UIAlertController(title: "Invalid Habit Name", message: "Please choose a valid habit name.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        } else if habitName.text![habitName.text!.index(habitName.text!.startIndex, offsetBy: 0)] == " " {
                let alertController = UIAlertController(title: "Invalid Habit Name", message: "Please choose a valid habit name.", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                present(alertController, animated: true, completion: nil)
        } else if selectedIcon == nil {
            let alertController = UIAlertController(title: "Missing a Habit Icon", message: "Please select a habit icon.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        } else {
            addHabit(habitName: habitName.text!, habitIcon: selectedIcon!)
            let alertController = UIAlertController(title: "Started a new habit!", message: "You have successfully created a new habit.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: { action in
                self.performSegue(withIdentifier: "unwindSegueToHabitVC", sender: self)
            })
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let habitVC = segue.destination as? HabitViewController {
            habitVC.arrayChanged = true
            updateGrid = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 255.0/255.0, green: 240.0/255.0, blue: 229.0/255.0, alpha: 1.0)
        iconCollectionView.delegate = self
        iconCollectionView.dataSource = self
        layout.scrollDirection = .horizontal
        iconCollectionView.collectionViewLayout = layout
        iconCollectionView.reloadData()
    }
    
    // Hide keyboard when user touches outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Press return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconCell", for: indexPath) as? IconImageCell {
            cell.iconImage.image = iconsArray[indexPath.item]
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 100.0, height: 100.0)
    }
    
    let borderColor = UIColor.init(red: 140/255, green: 222/255, blue: 130/255, alpha: 1.0)
    let backgroundColor = UIColor.init(red: 0.7843, green: 1.0, blue: 0.7843, alpha: 0.25)
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if currentCell != nil {
            currentCell!.backgroundColor = UIColor.clear
            currentCell!.layer.borderColor = UIColor.clear.cgColor
        }
        currentCell = iconCollectionView.cellForItem(at: indexPath) as? IconImageCell
        currentCell?.backgroundColor = backgroundColor
        currentCell?.layer.borderWidth = 2.0
        currentCell?.layer.borderColor = borderColor.cgColor
        selectedIcon = currentCell?.iconImage.image
        
    }
    
}

