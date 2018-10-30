//
//  GameOverViewController.swift
//  SpaceAdventure
//
//  Created by Konstantin on 23/10/2018.
//  Copyright © 2018 Konstantin. All rights reserved.
//

import UIKit

protocol GameOverViewControllerDelegate {
    func gameOverViewControllerResetButtonPressed(gameOverViewController: GameOverViewController)
    func gameOverViewControllerTopScoreButtonPressed(gameOverViewController: GameOverViewController)
    func gameOverViewControllerMenuButtonPressed(gameOverViewController: GameOverViewController)
}

class GameOverViewController: UIViewController {
    
    var score = 0
    var delegate: GameOverViewControllerDelegate!
    var gameSettings: GameSettings!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        delegate.gameOverViewControllerResetButtonPressed(gameOverViewController: self)
    }
    
    @IBAction func topScoreButtonPressed(_ sender: Any) {
        delegate.gameOverViewControllerTopScoreButtonPressed(gameOverViewController: self)
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        delegate.gameOverViewControllerMenuButtonPressed(gameOverViewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {        
        //scoreLabel.text = "\(score)"
        scoreLabel.text = "\(gameSettings.highscore)"
        
        super.viewDidAppear(animated)
    }

}
