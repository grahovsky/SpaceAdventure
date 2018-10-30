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
    
    var gameOverViewController: GameOverViewController!
    
    var gameSettings: GameSettings!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var pauseButton: UIButton!
    
    @IBAction func pauseButtonPressed(sender: AnyObject) {
        
        gameScene.pauseTheGame()
        
        if gameScene.gameIsPaused {
            pauseButton.setImage(UIImage(named: "playBtn"), for: .normal)
        } else {
            pauseButton.setImage(UIImage(named: "pauseBtn"), for: .normal)
        }
        
        //present(pauseViewController, animated: true, completion: nil)
        showGameScreen(viewController: pauseViewController)
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameSettings = GameSettings()
        
        pauseViewController = storyboard?.instantiateViewController(withIdentifier: "pauseViewController") as? PauseViewController
        pauseViewController.delegate = self
        
        gameOverViewController = storyboard?.instantiateViewController(withIdentifier: "GameOverViewController") as? GameOverViewController
        gameOverViewController.delegate = self
        gameOverViewController.gameSettings = gameSettings
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                scene.size = UIScreen.main.bounds.size //ограничение размеров сцены размером устройства на котором запущено
                
                // Present the scene
                view.presentScene(scene)
                
                gameScene = scene as? GameScene
                gameScene.gameDelegate = self
                gameScene.gameSettings = gameSettings
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    func showGameScreen(viewController: UIViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.frame = view.bounds
        
        viewController.view.alpha = 0
        UIView.animate(withDuration: 0.5) {
            viewController.view.alpha = 1
        }
    }
    
    func hideGameScreen(viewController: UIViewController) {
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

//MARK: PauseViewControllerDelegate
extension GameViewController: PauseViewControllerDelegate {
    
    func pauseViewControllerPlayButtonPressed(viewConroller: PauseViewController) {
        hideGameScreen(viewController: pauseViewController)
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
    
    func pauseViewControllerMusicButtonPressed(viewConroller: PauseViewController) {
        gameScene.musicOn = !gameScene.musicOn
        gameScene.musicOnOrOff()
        
        gameSettings.saveSettings(settings: [gameScene.musicOn, gameScene.soundOn])
        
        let image = gameScene.musicOn ? UIImage(named: "onImage") : UIImage(named: "offImage")
        viewConroller.musicButton.setImage(image, for: .normal)
    }
    
    func pauseViewControllerSoundButtonPressed(viewConroller: PauseViewController) {
        gameScene.soundOn = !gameScene.soundOn
        
        gameSettings.saveSettings(settings: [gameScene.musicOn, gameScene.soundOn])
        
        let image = gameScene.soundOn ? UIImage(named: "onImage") : UIImage(named: "offImage")
        viewConroller.soundButton.setImage(image, for: .normal)
    }
    
}

//MARK: GameOverViewControllerDelegate
extension GameViewController: GameOverViewControllerDelegate {
    
    func gameOverViewControllerResetButtonPressed(gameOverViewController: GameOverViewController) {
        gameScene.resetTheGame()
        hideGameScreen(viewController: gameOverViewController)
    }
    
    func gameOverViewControllerTopScoreButtonPressed(gameOverViewController: GameOverViewController) {
        
    }
    
    func gameOverViewControllerMenuButtonPressed(gameOverViewController: GameOverViewController) {
        
    }
}

//MARK: GameDelegate
extension GameViewController: GameDelegate {
    
    func gameDelegateDidUpdateScore(score: Int) {
        scoreLabel.text = "\(self.gameSettings.currentScore)"
    }
    
    func gameDelegateReset() {
        scoreLabel.text = "\(self.gameSettings.currentScore)"
    }
    
    
    func gameDelegateUpdateScore(score: Int) {
    
    }
    
    func gameDelegateGameOver(score: Int) {
        gameSettings.recordScores(score: score)
        gameOverViewController.score = score
        showGameScreen(viewController: gameOverViewController)
    }
    
}
