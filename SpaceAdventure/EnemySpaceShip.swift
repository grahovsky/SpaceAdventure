//
//  EnemySpaceShip.swift
//  SpaceAdventure
//
//  Created by Konstantin on 01/11/2018.
//  Copyright © 2018 Konstantin. All rights reserved.
//

import UIKit
import SpriteKit

class EnemySpaceShip: SKSpriteNode {
    
    init() {
        let enemyTexture = SKTexture(imageNamed: "enemySpaceShip")
        super.init(texture: enemyTexture, color: UIColor.red, size: enemyTexture.size())
        
        zRotation = .pi
        
        //создаем физическое тело
        physicsBody = SKPhysicsBody(texture: enemyTexture, size: enemyTexture.size())
        
        //physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
        
        physicsBody?.categoryBitMask = CollisionCategories.EnemySpaceShip.rawValue
        physicsBody?.contactTestBitMask = CollisionCategories.PlayerSpaceShip.rawValue | CollisionCategories.PlayerLaser.rawValue
        physicsBody?.collisionBitMask = CollisionCategories.PlayerSpaceShip.rawValue | CollisionCategories.PlayerLaser.rawValue

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fly() {
        if let scene = scene {
            
            let width = (scene.size.width)/2
            let random = CGFloat.random(in: -width + size.width/2...width - size.width/2)
            position.x = random;
            position.y = scene.size.height/2 + size.height
            
            let moveLeft = SKAction.moveBy(x: -50, y: 0, duration: 2.0)
            moveLeft.timingMode = .easeInEaseOut
            let moveRight = SKAction.moveBy(x: 50, y: 0, duration: 2.0)
            moveRight.timingMode = .easeInEaseOut
            let sideMovementSequence = SKAction.sequence([moveLeft, moveRight])
            
            let moveDown = SKAction.moveBy(x: 0, y: -100, duration: 4.0)
            
            let enemyGroupMovement = SKAction.group([sideMovementSequence, moveDown])
            
            let repeatMoveDownAction = SKAction.repeatForever(enemyGroupMovement)
            
            run(repeatMoveDownAction)

        }
    }
    
}
