//
//  GameViewController.swift
//  SpaceAdventure
//
//  Created by Konstantin on 17/10/2018.
//  Copyright © 2018 Konstantin. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var gameScene: GameScene!
    
    
    @IBOutlet weak var pauseButton: UIButton!
    
    @IBAction func pauseButtonPressed(sender: AnyObject) {
        gameScene.pauseButtonPressed(sender: sender)
        if gameScene.gameIsPaused {
            pauseButton.setImage(UIImage(named: "playBtn"), for: .normal)
        } else {
            pauseButton.setImage(UIImage(named: "pauseBtn"), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                scene.size = UIScreen.main.bounds.size //ограничение размеров сцены размером устройства на котором запущено
                
                // Present the scene
                view.presentScene(scene)
            
                gameScene = scene as? GameScene
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
