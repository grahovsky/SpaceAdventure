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
        
        //создаем фон
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let backgound = SKSpriteNode(imageNamed: "background")
        backgound.position = CGPoint(x: 0, y: 0)
        backgound.size = CGSize(width: width, height: height)
        addChild(backgound)
        
        //Создаем космический корабль
        // инициализируем свойство
        spaceShip = SKSpriteNode(imageNamed: "spaceShip")
        // определяем позицию spaceShip на экране
        spaceShip.position = CGPoint(x: 0, y: 0)
        // добавляем
        spaceShip.physicsBody = SKPhysicsBody(texture: spaceShip.texture!, size: spaceShip.size)
        spaceShip.physicsBody?.isDynamic = false
        addChild(spaceShip)
        
        //Генерируем астероиды
        let asteroidCreateAction = SKAction.run {
            let asteroid = self.createAnAsteroid()
            self.addChild(asteroid)
        }
        
        let asteroidCreationDelay = SKAction.wait(forDuration: 1.0, withRange: 0.5)
        let asteroidSequenceAction = SKAction.sequence([asteroidCreateAction, asteroidCreationDelay])
        let asteroidRunAction = SKAction.repeatForever(asteroidSequenceAction)
        
        run(asteroidRunAction)
        
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
    
    func createAnAsteroid() -> SKSpriteNode {
        
        let asteroid = SKSpriteNode(imageNamed: "asteroid2")
        
        asteroid.xScale = 0.5
        asteroid.yScale = 0.5
        
        let width = (frame.size.width)/2
        let random = CGFloat.random(in: -width...width)
        asteroid.position.x = random;
        asteroid.position.y = frame.size.height/2 + asteroid.size.height
        
        asteroid.physicsBody = SKPhysicsBody(texture: asteroid.texture!, size: asteroid.size)
        
        return asteroid
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
//        let asteroid = createAnAsteroid()
//        self.addChild(asteroid)
        
    }
    
    
    
    
}
