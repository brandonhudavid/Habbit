//
//  AnnotationViewController.swift
//  Habbit
//
//  Created by Iris on 4/30/18.
//  Copyright © 2018 IrisBrandon. All rights reserved.
//

import Foundation
import Gecco

class AnnotationViewController: SpotlightViewController {
    
    @IBOutlet var annotationViews: [UILabel]!
    
    var stepIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
    }
    
    func next(_ labelAnimated: Bool) {
        updateAnnotationView(labelAnimated)
        
        let screenSize = UIScreen.main.bounds.size
        switch stepIndex {
        case 0:
            // main habit screen
            spotlightView.appear(Spotlight.RoundedRect(center: CGPoint(x: screenSize.width / 2, y: screenSize.height / 2 + 58), size: CGSize(width: screenSize.width - 12, height: screenSize.height - 225), cornerRadius: 6))
        case 1:
            // add habit
            spotlightView.move(Spotlight.Oval(center: CGPoint(x: screenSize.width - 28, y: 42), diameter: 50))
        case 2:
            // edit habit
            spotlightView.move(Spotlight.RoundedRect(center: CGPoint(x: 36, y: 42), size: CGSize(width: 52, height: 40), cornerRadius: 6), moveType: .disappear)
        case 3:
            // tracker
            spotlightView.disappear()
        case 4:
            dismiss(animated: true, completion: nil)
        default:
            break
        }
        
        stepIndex += 1
    }
    
    func updateAnnotationView(_ animated: Bool) {
        annotationViews.enumerated().forEach { index, view in
            UIView.animate(withDuration: animated ? 0.25 : 0) {
                view.alpha = index == self.stepIndex ? 1 : 0
            }
        }
    }
}

extension AnnotationViewController: SpotlightViewControllerDelegate {
    func spotlightViewControllerWillPresent(_ viewController: SpotlightViewController, animated: Bool) {
        next(false)
    }
    
    func spotlightViewControllerTapped(_ viewController: SpotlightViewController, isInsideSpotlight: Bool) {
        next(true)
    }
    
    func spotlightViewControllerWillDismiss(_ viewController: SpotlightViewController, animated: Bool) {
        spotlightView.disappear()
    }
}
