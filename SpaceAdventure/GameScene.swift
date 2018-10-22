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
    var background: SKSpriteNode!
    
    var score = 0
    var scoreLabel: SKLabelNode!
    
    //слой космического корабля
    var spaceShipLayer: SKNode!
    
    //слой астероидов
    var asteroidLayer: SKNode!
    
    //слой звёзд
    var starsLayer: SKNode!
    
    //индикатор паузы игры
    var gameIsPaused: Bool = false
    
    //функции паузы/снятия паузы/резета
    func pauseTheGame() {
        
        gameIsPaused = true
        
        self.asteroidLayer.isPaused = true
        self.spaceShipLayer.isPaused = true
        self.starsLayer.isPaused = true
        physicsWorld.speed = 0
        
    }
    
    func unpauseTheGame() {
        
        gameIsPaused = false
        
        self.asteroidLayer.isPaused = false
        self.spaceShipLayer.isPaused = false
        self.starsLayer.isPaused = false
        physicsWorld.speed = 1
        
    }
    
    func resetTheGame() {
        
        score = 0
        scoreLabel.text = "Score: \(self.score)"
        
        gameIsPaused = false
        
        self.asteroidLayer.isPaused = false
        physicsWorld.speed = 1
        
    }
    
    
    
    override func didMove(to view: SKView) {
        
        //делаем уникальный сид для рандомной функции drand48()
        srand48(time(nil))
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -0.5)
        
        //создаем фон
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 0, y: 0)
        background.size = CGSize(width: width + 8, height: height + 6)
        addChild(background)
        
        //создаем слой звёзд
        let starsPath = Bundle.main.path(forResource: "stars", ofType: "sks")!
        let starsEmitter = NSKeyedUnarchiver.unarchiveObject(withFile: starsPath) as! SKEmitterNode
        
        starsEmitter.position = CGPoint(x: 0, y: frame.size.height/2)
        starsEmitter.particlePositionRange.dx = frame.size.width + 10
        starsEmitter.advanceSimulationTime(100)
        
        starsLayer = SKNode()
        starsLayer.zPosition = 1
        starsLayer.addChild(starsEmitter)
        addChild(starsLayer)
        
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
        
        let colorAction1 = SKAction.colorize(with: UIColor.yellow, colorBlendFactor: 1, duration: 1)
        let colorAction2 = SKAction.colorize(with: UIColor.white, colorBlendFactor: 0, duration: 1)
        let colorSequenceAnimation = SKAction.sequence([colorAction1, colorAction2])
        let colorActionRepeat = SKAction.repeatForever(colorSequenceAnimation)
        spaceShip.run(colorActionRepeat)

        
        //создаем слой космического корабля
        spaceShipLayer = SKNode()
        spaceShipLayer.addChild(spaceShip)
        spaceShipLayer.zPosition = 3
        spaceShip.zPosition = 1
        spaceShipLayer.position = CGPoint(x: 0, y: 0)
        
        addChild(spaceShipLayer)
        
        //создаем огонь
        let firePath = Bundle.main.path(forResource: "fire", ofType: "sks")!
        let fireEmitter = NSKeyedUnarchiver.unarchiveObject(withFile: firePath) as! SKEmitterNode
        
        fireEmitter.zPosition = 0
        fireEmitter.position.y = -50
        //fireEmitter.targetNode = self
        spaceShipLayer.addChild(fireEmitter)
        
        //Генерируем астероиды
        asteroidLayer = SKNode()
        asteroidLayer.zPosition = 2
        addChild(asteroidLayer)
        
        let asteroidCreateAction = SKAction.run {
            let asteroid = self.createAnAsteroid()
            self.asteroidLayer.addChild(asteroid)
        }
        
        let asteroidsPerSecond: Double = 1;
        let asteroidCreationDelay = SKAction.wait(forDuration: 1.0 / asteroidsPerSecond, withRange: 0.5)
        let asteroidSequenceAction = SKAction.sequence([asteroidCreateAction, asteroidCreationDelay])
        let asteroidRunAction = SKAction.repeatForever(asteroidSequenceAction)
        
        self.asteroidLayer.run(asteroidRunAction)
        
        scoreLabel = SKLabelNode(text: "Score: \(score)")
        scoreLabel.fontSize = 30
        scoreLabel.fontName = "Futura"
        scoreLabel.fontColor = SKColor.yellow
        scoreLabel.position = CGPoint(x: 0, y: frame.size.height/2 - scoreLabel.calculateAccumulatedFrame().height - 15)
        addChild(scoreLabel)
        
        background.zPosition = 0
        scoreLabel.zPosition = 4
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !gameIsPaused {
            
            if let touch = touches.first {
                
                // определяем точку прикосновения с экраном
                let touchLocation = touch.location(in: self)
                
                // создаем действие и применяем его
                
                let distance = distanceCalc(a: spaceShipLayer.position, b: touchLocation)
                let speed: CGFloat = 200
                let time = timeToTravelDistance(distance: distance, speed: speed)
                
                let moveAction = SKAction.move(to: touchLocation, duration: time)
                moveAction.timingMode = SKActionTimingMode.easeInEaseOut
                spaceShipLayer.run(moveAction)
                
                let bgMoveAction = SKAction.move(to: CGPoint(x: -touchLocation.x / 50, y: -touchLocation.y / 50), duration: time)
                background.run(bgMoveAction)
                
                let starsMoveAction = SKAction.move(to: CGPoint(x: -touchLocation.x / 40, y: -touchLocation.y / 40), duration: time)
                starsLayer.run(starsMoveAction)
                
            }
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
        
        let asteroidImageArray = ["asteroid", "asteroid2"]
        let randomIndex = Int.random(in: 0...asteroidImageArray.count-1)
        let asteroid = SKSpriteNode(imageNamed: asteroidImageArray[randomIndex])
        
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
        
        //asteroid.zPosition = 2
        
        //drand48 - возвращает значение от 0 до 1
        asteroid.physicsBody?.angularVelocity = CGFloat(drand48() * 2 - 1) * 3
        let asteroidSpeedX: CGFloat = 100
        asteroid.physicsBody?.velocity.dx = CGFloat(drand48() * 2 - 1) * asteroidSpeedX
        
        
        return asteroid
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        //        let asteroid = createAnAsteroid()
        //        self.addChild(asteroid)
        
    }
    
    override func didFinishUpdate() {
        asteroidLayer.enumerateChildNodes(withName: "asteroid") { (asteroid: SKNode, stop: UnsafeMutablePointer<ObjCBool>) in
            
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
