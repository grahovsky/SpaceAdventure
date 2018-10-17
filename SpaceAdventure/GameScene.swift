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
    
    //создаем свойство
    var spaceShip: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        
        // инициализируем свойство
        spaceShip = SKSpriteNode(imageNamed: "spaceShip")
        
        // определяем позицию spaceShip на экране
        spaceShip.position = CGPoint(x: 100, y: 100)
        
        // добавляем
        addChild(spaceShip)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
          
            // определяем точку прикосновения с экраном
            let touchLocation = touch.location(in: self)
            
            // создаем действие и применяем его
            let moveAction = SKAction.move(to: touchLocation, duration: 1.0)
            
            spaceShip.run(moveAction)
        }
        
    }
}
