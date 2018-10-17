//
//  GameScene.swift
//  SpaceAdventure
//
//  Created by Konstantin on 17/10/2018.
//  Copyright © 2018 Konstantin. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        let spaceShip = SKSpriteNode(imageNamed: "spaceShip")
        
        spaceShip.position = CGPoint(x: 100, y: 100)
        
        addChild(spaceShip)
    }
}
