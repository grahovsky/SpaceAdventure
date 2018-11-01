//
//  StartViewController.swift
//  SpaceAdventure
//
//  Created by Konstantin on 01/11/2018.
//  Copyright © 2018 Konstantin. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!

    @IBOutlet weak var crownImageView: UIImageView!
    
    var max: Bool = true
    var rotationDegree: CGFloat = 0
    
    func startButtonAnimation() {
        
        max = !max
        
        let duration: Double = 1
        let fullCircle = 2 * CGFloat.pi
        
        //определение направления и масштаба
        let upAndDown = (max ? -1 : 1) * fullCircle / 16
        let scale: (CGFloat, CGFloat) = (max ? (1.0, 1.0) : (1.3, 1.3))
        
        //запуск анимации
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
            let rotationAnimation = CGAffineTransform.init(rotationAngle: upAndDown)
            let scaleAnimation = CGAffineTransform.init(scaleX: scale.0, y: scale.1)
            
            self.startButton.transform = rotationAnimation.concatenating(scaleAnimation)
            
        }) { (_) in
            self.startButtonAnimation()
        }

    }
    
    func circleAnimation(withObject: UIImageView) {
        
        UIView.animate(withDuration: 0.01, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
            withObject.transform = CGAffineTransform.init(rotationAngle: self.rotationDegree)
        }) { (finished) in
            self.rotationDegree += CGFloat.pi / 180
            self.circleAnimation(withObject: withObject)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startButtonAnimation()
        circleAnimation(withObject: crownImageView)
        
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
   
    
}
