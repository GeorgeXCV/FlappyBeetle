//
//  GameElements.swift
//  FlappyBeetle
//
//  Created by George on 12/11/2018.
//  Copyright © 2018 George. All rights reserved.
//

import SpriteKit

struct CollisionBitMask {
    static let birdCategory:UInt32 = 0x1 << 0
    static let pillarCategory:UInt32 = 0x1 << 1
    static let flowerCategory:UInt32 = 0x1 << 2
    static let groundCategory:UInt32 = 0x1 << 3
}

extension GameScene {
    
    func createBird() -> SKSpriteNode {
        
        // Create Bird sprite and set its size and center of screen
        let bird = SKSpriteNode(texture: SKTextureAtlas(named:"player").textureNamed("bird1"))
        bird.size = CGSize(width: 50, height: 50)
        bird.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        
        // Defined physics radius, half of its width
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.width / 2)
        bird.physicsBody?.linearDamping = 1.1
        bird.physicsBody?.restitution = 0
        
        // If two bodies collide, we identify the two bodies by their categoryBitMasks.
        // The collisionBitMask is set to pillarCategory and groundCategory to detect collisions with pillar and ground for this body.
        // The contactTestBitMask is assigned to pillar, ground and flower because you will want to check for contacts with these bodies.
        bird.physicsBody?.categoryBitMask = CollisionBitMask.birdCategory
        bird.physicsBody?.collisionBitMask = CollisionBitMask.pillarCategory | CollisionBitMask.groundCategory
        bird.physicsBody?.contactTestBitMask = CollisionBitMask.pillarCategory | CollisionBitMask.flowerCategory | CollisionBitMask.groundCategory
        
        // Set bird to be affected by gravity
        bird.physicsBody?.affectedByGravity = false
        bird.physicsBody?.isDynamic = true
        
        return bird
    }
    
    // Create Restart Button and add to scene when called
    func createRestartButton() {
        restartButton = SKSpriteNode(imageNamed: "restart")
        restartButton.size = CGSize(width:100, height:100)
        restartButton.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        restartButton.zPosition = 6
        restartButton.setScale(0)
        self.addChild(restartButton)
        restartButton.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    
    // Create Puase Button and add to scene when called
    func createPauseButton() {
        pauseButton = SKSpriteNode(imageNamed: "pause")
        pauseButton.size = CGSize(width:40, height:40)
        pauseButton.position = CGPoint(x: self.frame.width - 30, y: 30)
        pauseButton.zPosition = 6
        self.addChild(pauseButton)
    }
    
    // Create Score label. Then creates background of the label.
    func createScoreLabel() -> SKLabelNode {
        let scoreLabel = SKLabelNode()
        scoreLabel.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 2.6)
        scoreLabel.text = "\(score)"
        scoreLabel.zPosition = 5
        scoreLabel.fontSize = 50
        scoreLabel.fontName = "HelveticaNeue-Bold"
        
        let scoreBg = SKShapeNode()
        scoreBg.position = CGPoint(x: 0, y: 0)
        scoreBg.path = CGPath(roundedRect: CGRect(x: CGFloat(-50), y: CGFloat(-30), width: CGFloat(100), height: CGFloat(100)), cornerWidth: 50, cornerHeight: 50, transform: nil)
        let scoreBgColor = UIColor(red: CGFloat(0.0 / 255.0), green: CGFloat(0.0 / 255.0), blue: CGFloat(0.0 / 255.0), alpha: CGFloat(0.2))
        scoreBg.strokeColor = UIColor.clear
        scoreBg.fillColor = scoreBgColor
        scoreBg.zPosition = -1
        scoreLabel.addChild(scoreBg)
        return scoreLabel
    }
    
    // Create High Score label and place it at the top right corner. Saved in UserDefaults, if no found score is 0.
    func createHighscoreLabel() -> SKLabelNode {
        let highscoreLabel = SKLabelNode()
        highscoreLabel.position = CGPoint(x: self.frame.width - 80, y: self.frame.height - 22)
        if let highestScore = UserDefaults.standard.object(forKey: "highestScore"){
            highscoreLabel.text = "Highest Score: \(highestScore)"
        } else {
            highscoreLabel.text = "Highest Score: 0"
        }
        highscoreLabel.zPosition = 5
        highscoreLabel.fontSize = 15
        highscoreLabel.fontName = "Helvetica-Bold"
        return highscoreLabel
    }
    
    // Create Logo and animate its size when it shows up on screen
    func createLogo() {
        logoImage = SKSpriteNode()
        logoImage = SKSpriteNode(imageNamed: "logo")
        logoImage.size = CGSize(width: 272, height: 65)
        logoImage.position = CGPoint(x:self.frame.midX, y:self.frame.midY + 100)
        logoImage.setScale(0.5)
        self.addChild(logoImage)
        logoImage.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    
    // Create Tap to Play label and add it below the bird
    func createTapToPlayLabel() -> SKLabelNode {
        let tapToPlayLabel = SKLabelNode()
        tapToPlayLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 100)
        tapToPlayLabel.text = "Tap anywhere to play"
        tapToPlayLabel.fontColor = UIColor(red: 63/255, green: 79/255, blue: 145/255, alpha: 1.0)
        tapToPlayLabel.zPosition = 5
        tapToPlayLabel.fontSize = 20
        tapToPlayLabel.fontName = "HelveticaNeue"
        return tapToPlayLabel
    }
    
    func createWalls() -> SKNode  {
        //  Create Flower
        let flowerNode = SKSpriteNode(imageNamed: "flower")
        flowerNode.size = CGSize(width: 40, height: 40)
        flowerNode.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2)
        flowerNode.physicsBody = SKPhysicsBody(rectangleOf: flowerNode.size)
        flowerNode.physicsBody?.affectedByGravity = false
        flowerNode.physicsBody?.isDynamic = false
        flowerNode.physicsBody?.categoryBitMask = CollisionBitMask.flowerCategory
        flowerNode.physicsBody?.collisionBitMask = 0
        flowerNode.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        flowerNode.color = SKColor.blue
        // Create SKNode wallPair and add top/bottom at its childs. Create them and scale to half size.
        wallPair = SKNode()
        wallPair.name = "wallPair"
        
        let topWall = SKSpriteNode(imageNamed: "pillar")
        let btmWall = SKSpriteNode(imageNamed: "pillar")
        
        topWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 + 420)
        btmWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 - 420)
        
        topWall.setScale(0.5)
        btmWall.setScale(0.5)
        
        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        topWall.physicsBody?.categoryBitMask = CollisionBitMask.pillarCategory
        topWall.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
        topWall.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        topWall.physicsBody?.isDynamic = false
        topWall.physicsBody?.affectedByGravity = false
        
        btmWall.physicsBody = SKPhysicsBody(rectangleOf: btmWall.size)
        btmWall.physicsBody?.categoryBitMask = CollisionBitMask.pillarCategory
        btmWall.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
        btmWall.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        btmWall.physicsBody?.isDynamic = false
        btmWall.physicsBody?.affectedByGravity = false
        
        topWall.zRotation = CGFloat(M_PI)
        
        wallPair.addChild(topWall)
        wallPair.addChild(btmWall)
        
        wallPair.zPosition = 1
        // Generate random number and assign it to wall Y poisition. Places walls at random heights.
        let randomPosition = random(min: -200, max: 200)
        wallPair.position.y = wallPair.position.y +  randomPosition
        wallPair.addChild(flowerNode)
        
        wallPair.run(moveAndRemove)                 // Moves it horizontally and removes it when it reaches other side of screen 
        
        return wallPair
    }
    
    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min : CGFloat, max : CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
    
}
