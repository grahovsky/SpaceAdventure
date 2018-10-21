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
    
    let spaceShipCategory: UInt32 = 0x1 << 0
    let asteroidCategory: UInt32 = 0x1 << 1
    
    //создаем свойства
    var spaceShip: SKSpriteNode!
    var score = 0
    var scoreLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -0.5)
        
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
        spaceShip.physicsBody?.categoryBitMask = spaceShipCategory
        spaceShip.physicsBody?.collisionBitMask = asteroidCategory | asteroidCategory
        spaceShip.physicsBody?.contactTestBitMask = asteroidCategory
        
        addChild(spaceShip)
        
        //Генерируем астероиды
        let asteroidCreateAction = SKAction.run {
            let asteroid = self.createAnAsteroid()
            self.addChild(asteroid)
        }
        
        let asteroidsPerSecond: Double = 1;
        let asteroidCreationDelay = SKAction.wait(forDuration: 1.0 / asteroidsPerSecond, withRange: 0.5)
        let asteroidSequenceAction = SKAction.sequence([asteroidCreateAction, asteroidCreationDelay])
        let asteroidRunAction = SKAction.repeatForever(asteroidSequenceAction)
        
        run(asteroidRunAction)
        
        scoreLabel = SKLabelNode(text: "Score: \(score)")
        scoreLabel.fontSize = 30
        scoreLabel.fontName = "Futura"
        scoreLabel.fontColor = SKColor.yellow
        scoreLabel.position = CGPoint(x: 0, y: frame.size.height/2 - scoreLabel.calculateAccumulatedFrame().height - 15)
        addChild(scoreLabel)
        
        backgound.zPosition = 0
        spaceShip.zPosition = 1
        scoreLabel.zPosition = 3
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
          
            // определяем точку прикосновения с экраном
            let touchLocation = touch.location(in: self)
            
            // создаем действие и применяем его
            
            let distance = distanceCalc(a: spaceShip.position, b: touchLocation)
            let speed: CGFloat = 200
            let time = timeToTravelDistance(distance: distance, speed: speed)
    
            let moveAction = SKAction.move(to: touchLocation, duration: time)
            
            spaceShip.run(moveAction)
        }
        
    }
    
    func distanceCalc(a: CGPoint, b: CGPoint) -> CGFloat {
        return sqrt(pow(b.x - a.x, 2) + pow(b.y - a.y, 2))
    }
    
    func timeToTravelDistance(distance: CGFloat, speed: CGFloat) -> TimeInterval {
        let time = distance/speed
        return TimeInterval(time)
    }
    
    func createAnAsteroid() -> SKSpriteNode {
        
        let asteroid = SKSpriteNode(imageNamed: "asteroid2")
        
        //меняем масштаб астероида в пределах 0.2 - 0.5 от исходного размера
        let randomScale = CGFloat.random(in: 0.2...0.5)
        asteroid.xScale = randomScale
        asteroid.yScale = randomScale
        
        //устанавливаем позицию образования астероидов
        let width = (frame.size.width)/2
        let random = CGFloat.random(in: -width...width)
        asteroid.position.x = random;
        asteroid.position.y = frame.size.height/2 + asteroid.size.height
        
        //присваиваем астероиду физическое тело
        asteroid.physicsBody = SKPhysicsBody(texture: asteroid.texture!, size: asteroid.size)
        asteroid.name = "asteroid"
        
        asteroid.physicsBody?.categoryBitMask = asteroidCategory
        asteroid.physicsBody?.collisionBitMask = spaceShipCategory
        asteroid.physicsBody?.contactTestBitMask = spaceShipCategory
        
        asteroid.zPosition = 2
        
        return asteroid
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
//        let asteroid = createAnAsteroid()
//        self.addChild(asteroid)
        
    }
    
    override func didFinishUpdate() {
        enumerateChildNodes(withName: "asteroid") { (asteroid: SKNode, stop: UnsafeMutablePointer<ObjCBool>) in
            
            if asteroid.position.y < -(self.frame.size.height/2 + asteroid.calculateAccumulatedFrame().height) {
                asteroid.removeFromParent()
                
                self.score += 1
                self.scoreLabel.text = "Score: \(self.score)"
                
            }
        }
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
 
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == spaceShipCategory && contact.bodyB.categoryBitMask == asteroidCategory ||
            contact.bodyA.categoryBitMask == asteroidCategory && contact.bodyB.categoryBitMask == spaceShipCategory {
            self.score = 0
            self.scoreLabel.text = "Score: \(self.score)"
        }
        
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
    
}
