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
    
    var pauseViewController: PauseViewController!
    
    @IBOutlet weak var pauseButton: UIButton!
    
    @IBAction func pauseButtonPressed(sender: AnyObject) {
        
        gameScene.pauseTheGame()
        
        if gameScene.gameIsPaused {
            pauseButton.setImage(UIImage(named: "playBtn"), for: .normal)
        } else {
            pauseButton.setImage(UIImage(named: "pauseBtn"), for: .normal)
        }
        
        //present(pauseViewController, animated: true, completion: nil)
        showPauseScreen(viewController: pauseViewController)
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pauseViewController = storyboard?.instantiateViewController(withIdentifier: "pauseViewController") as? PauseViewController
        pauseViewController.delegate = self
        
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
    
    func showPauseScreen(viewController: UIViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.frame = view.bounds
        
        viewController.view.alpha = 0
        UIView.animate(withDuration: 0.5) {
            viewController.view.alpha = 1
        }
    }
    
    func hidePauseScreen(viewController: PauseViewController) {
        viewController.willMove(toParent: nil)
        viewController.removeFromParent()
        
        
        viewController.view.alpha = 1
        UIView.animate(withDuration: 0.5, animations: {
            viewController.view.alpha = 0
        }) { (completed: Bool) in
            viewController.view.removeFromSuperview()
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

extension GameViewController: PauseViewControllerDelegate {
    
    func pauseViewControllerPlayButtonPressed(viewConroller: PauseViewController) {
        hidePauseScreen(viewController: pauseViewController)
        gameScene.unpauseTheGame()
        
        if gameScene.gameIsPaused {
            pauseButton.setImage(UIImage(named: "playBtn"), for: .normal)
        } else {
            pauseButton.setImage(UIImage(named: "pauseBtn"), for: .normal)
        }
    }
    
    func pauseViewControllerStoreButtonPressed(viewConroller: PauseViewController) {
        
    }
    
    func pauseViewControllerMenuButtonPressed(viewConroller: PauseViewController) {
        
    }
    
}
