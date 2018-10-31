//
//  GameScene.swift
//  SpaceAdventure
//
//  Created by Konstantin on 17/10/2018.
//  Copyright © 2018 Konstantin. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

protocol GameDelegate {
    func gameDelegateDidUpdateScore(score: Int)
    func gameDelegateGameOver(score: Int)
    func gameDelegateReset()
    
    func gameDelegateDidUpdateLives()
}

enum CollisionCategories: UInt32 {
    case None = 1
    case PlayerSpaceShip = 2
    case Asteroid = 4
    case EnemyShip = 8
}

class GameScene: SKScene {
    
    var gameDelegate: GameDelegate?
    var gameSettings: GameSettings!
    
    var spaceShipPickedUp: Bool = false
    var lastLocation: CGPoint = CGPoint.init()
    
    var gameOver = false
    var playerWasHit = false
    
    //создаем свойства
    var spaceShip: SKSpriteNode!
    var background: SKSpriteNode!
    
//    var score = 0
//    var scoreLabel: SKLabelNode!
    
    //слой космического корабля
    var spaceShipLayer: SKNode!
    
    //слой астероидов
    var asteroidLayer: SKNode!
    
    //слой звёзд
    var starsLayer: SKNode!
    
    //индикатор паузы игры
    var gameIsPaused: Bool = false
    
    //создаем проигрыватель
    var musicPlayer: AVAudioPlayer!
    
    //переменные для отображения звука и музыки
    var musicOn: Bool = true
    var soundOn: Bool = true
    
    func musicOnOrOff() {
        if musicOn {
            musicPlayer.play()
        } else {
            musicPlayer.stop()
        }
    }
    
    //функции паузы/снятия паузы/резета
    func pauseTheGame() {
        
        gameIsPaused = true
        
        self.asteroidLayer.isPaused = true
        //self.spaceShipLayer.isPaused = true
        self.starsLayer.isPaused = true
        physicsWorld.speed = 0
        
        musicOnOrOff()
        
    }
    
    func unpauseTheGame() {
        
        gameIsPaused = false
        
        self.asteroidLayer.isPaused = false
        self.spaceShipLayer.isPaused = false
        self.starsLayer.isPaused = false
        physicsWorld.speed = 1
        
        musicOnOrOff()
        
    }
    
    func resetTheGame() {
        
//        score = 0
//        scoreLabel.text = "Score: \(self.score)"
        
        gameSettings.resetCurrentScore()
        gameDelegate?.gameDelegateReset()
        
        
        // определяем позицию spaceShip на экране
        spaceShipLayer.position = CGPoint(x: 0, y: 0)
        
        asteroidLayer.removeAllChildren()
        gameOver = false
        playerWasHit = false
        self.unpauseTheGame()
        
    }
    
    func respawn() {

        unpauseTheGame()
        playerWasHit = false
        asteroidLayer.removeAllChildren()

        // определяем позицию spaceShip на экране
        spaceShipLayer.position = CGPoint(x: 0, y: 0)
        
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
        
        let starsEmitter = SKEmitterNode(fileNamed: "stars.sks")!
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
        // добавляем
        spaceShip.physicsBody = SKPhysicsBody(texture: spaceShip.texture!, size: spaceShip.size)
        spaceShip.physicsBody?.isDynamic = false
        spaceShip.physicsBody?.categoryBitMask = CollisionCategories.PlayerSpaceShip.rawValue
        spaceShip.physicsBody?.collisionBitMask = CollisionCategories.PlayerSpaceShip.rawValue | CollisionCategories.Asteroid.rawValue
        spaceShip.physicsBody?.contactTestBitMask = CollisionCategories.Asteroid.rawValue
        
        //        let colorAction1 = SKAction.colorize(with: UIColor.yellow, colorBlendFactor: 1, duration: 1)
        //        let colorAction2 = SKAction.colorize(with: UIColor.white, colorBlendFactor: 0, duration: 1)
        //        let colorSequenceAnimation = SKAction.sequence([colorAction1, colorAction2])
        //        let colorActionRepeat = SKAction.repeatForever(colorSequenceAnimation)
        //        spaceShip.run(colorActionRepeat)
        
        
        //создаем слой космического корабля
        spaceShipLayer = SKNode()
        spaceShipLayer.addChild(spaceShip)
        spaceShipLayer.zPosition = 3
        spaceShip.zPosition = 1
        spaceShipLayer.position = CGPoint(x: 0, y: 0)
        
        addChild(spaceShipLayer)
        
        //создаем огонь
        let fireEmitter = SKEmitterNode(fileNamed: "fire.sks")!
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
        
//        scoreLabel = SKLabelNode(text: "Score: \(score)")
//        scoreLabel.fontSize = 30
//        scoreLabel.fontName = "Futura"
//        scoreLabel.fontColor = #colorLiteral(red: 0.7655060279, green: 0.3717384464, blue: 0.1646142797, alpha: 1)
//        scoreLabel.position = CGPoint(x: 0, y: frame.size.height/2 - scoreLabel.calculateAccumulatedFrame().height - 15)
//        addChild(scoreLabel)
        
        background.zPosition = 0
//        scoreLabel.zPosition = 4
        
        gameSettings = GameSettings()
        
        musicOn = gameSettings.musicOn
        soundOn = gameSettings.soundOn
        
        playMusic()
        resetTheGame()
        
    }
    
    //фоновая музыка
    
    func playMusic() {
        let musicPath = Bundle.main.url(forResource: "backgroundMusic", withExtension: "m4a")!
        musicPlayer = try! AVAudioPlayer(contentsOf: musicPath)
        musicOnOrOff()
        
        musicPlayer.numberOfLoops = -1
        musicPlayer.volume = 0.3
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
                
                if nodes(at: touchLocation).contains(spaceShip) {
                    //spaceShipLayer.position = touchLocation
                    lastLocation = touchLocation
                    
                    spaceShipPickedUp = true
                } else {
                    spaceShipLayer.run(moveAction)
                }
                
                let bgMoveAction = SKAction.move(to: CGPoint(x: -touchLocation.x / 50, y: -touchLocation.y / 50), duration: time)
                background.run(bgMoveAction)
                
                let starsMoveAction = SKAction.move(to: CGPoint(x: -touchLocation.x / 40, y: -touchLocation.y / 40), duration: time)
                
                starsLayer.run(starsMoveAction)
                
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !gameIsPaused {
            
            if let touch = touches.first {
                
                // определяем точку прикосновения с экраном
                let touchLocation = touch.location(in: self)
                if spaceShipPickedUp {
                    
                    //spaceShipLayer.position = touchLocation
                    
                    let translation = CGPoint(x: touchLocation.x - lastLocation.x, y: touchLocation.y - lastLocation.y)
                    
                    spaceShipLayer.position.x += translation.x
                    spaceShipLayer.position.y += translation.y
                    
                    lastLocation = touchLocation
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        spaceShipPickedUp = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        spaceShipPickedUp = false
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
        
        asteroid.physicsBody?.categoryBitMask = CollisionCategories.Asteroid.rawValue
        asteroid.physicsBody?.collisionBitMask = CollisionCategories.PlayerSpaceShip.rawValue
        asteroid.physicsBody?.contactTestBitMask = CollisionCategories.PlayerSpaceShip.rawValue
        
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
                
//                self.score += 1
//                self.scoreLabel.text = "Score: \(self.score)"
                self.addPoints(points: 1)
                
            }
        }
    }
    
    func addPoints(points: Int) {
        gameSettings.currentScore += points
        gameDelegate?.gameDelegateDidUpdateScore(score: self.gameSettings.currentScore)
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == CollisionCategories.PlayerSpaceShip.rawValue && contact.bodyB.categoryBitMask == CollisionCategories.Asteroid.rawValue ||
            contact.bodyA.categoryBitMask == CollisionCategories.Asteroid.rawValue && contact.bodyB.categoryBitMask == CollisionCategories.PlayerSpaceShip.rawValue {
        }
        
        if !gameOver && !playerWasHit {
        
            self.playerWasHit = true
            
            self.pauseTheGame()
            
            //определяем анимацию столкновения с астероидом
            let fadeOutAction = SKAction.fadeOut(withDuration: 0.1)
            fadeOutAction.timingMode = SKActionTimingMode.easeOut
            
            let fadeInAction = SKAction.fadeIn(withDuration: 0.1)
            fadeInAction.timingMode = SKActionTimingMode.easeOut
            
            let blinkAction = SKAction.sequence([fadeOutAction, fadeInAction])
            let blinkRepeatAction = SKAction.repeat(blinkAction, count: 3)
            
            let delayAction = SKAction.wait(forDuration: 0.2)
            
            let gameOverAction = SKAction.run {
                
                self.gameSettings.lives -= 1
                self.gameDelegate?.gameDelegateDidUpdateLives()
                
                if self.gameSettings.lives > 0 {
                    self.respawn()
                } else
                {
                    self.gameSettings.recordScores(score: self.gameSettings.currentScore)
                    self.gameDelegate?.gameDelegateGameOver(score: self.gameSettings.currentScore)
                    self.spaceShipLayer.isPaused = true
                    self.gameOver = true
                    self.pauseTheGame()
                }
            }
            
            let gameOverSequence = SKAction.sequence([blinkRepeatAction, delayAction, gameOverAction])
            spaceShipLayer.run(gameOverSequence)
            
        }
        
        
        if soundOn {
            let hitSoundAction = SKAction.playSoundFileNamed("hitSound", waitForCompletion: true)
            run(hitSoundAction)
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
    
}
