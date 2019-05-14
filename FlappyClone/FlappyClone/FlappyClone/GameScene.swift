//
//  GameScene.swift
//  FlappyClone
//
//  Created by Shemon on 4/28/19.
//  Copyright © 2019 Shemon. All rights reserved.
//

import SpriteKit 
import UIKit

struct PhysicsCatagory {
    static let Ghost : UInt32 = 0x1 << 1
    static let Ground : UInt32 = 0x1 << 2
    static let Wall : UInt32 = 0x1 << 3
    static let Score : UInt32 = 0x1 << 4
}


class GameScene: SKScene,SKPhysicsContactDelegate {
    
     var game = Game()  // game object
     var i = 0
     var min = 0

     //jump height
     var jmp = 300
    
     var Ground = SKSpriteNode()
    
     var Ghost = SKSpriteNode()
     var GhostName = "Ghost"
    
     var wallPair = SKNode()
    
     var moveAndRemove = SKAction()
     var gameStarted = Bool()
     var score = 0
     let scoreLbl = SKLabelNode()
     var died = Bool()
     var restartBTN = SKSpriteNode()
    
    func restartScene(){
        
        self.removeAllChildren()
        self.removeAllActions()
        died = false
        gameStarted = false
        score = 0 // reseting the score use this place to store top 3 scores
        CreateScene()
    }
    
    func CreateScene(){
        
        self.physicsWorld.contactDelegate = self
        
        for i in 0..<2 {
            let background = SKSpriteNode(imageNamed: "Background")
            background.anchorPoint = CGPoint(x: 0 , y: 0)
            background.position = CGPoint(x: CGFloat(i) * self.frame.width, y: 0)
            background.name = "background"
            background.size = (self.view?.bounds.size)!
            self.addChild(background)
            
        }
        
        //set up label for score
        scoreLbl.fontName = "FlappyBirdy"
        scoreLbl.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 + self.frame.height/2.5)
        scoreLbl.text  = "\(score)"
        scoreLbl.fontSize = 60
        self.addChild(scoreLbl)
        scoreLbl.zPosition = 5
        
        addGround()
        addGhost()
        
    }
    
     override func didMove(to view: SKView) {
       CreateScene()
        
    }
    
    //creating the ground
    //setup for ground
    //physics for ground
    func addGround(){
        // floor ground
        Ground = SKSpriteNode(imageNamed: "Ground")
        Ground.setScale(1)
        Ground.position = CGPoint(x: self.frame.width / 2, y: 0 + Ground.frame.height / 2)
        Ground.physicsBody = SKPhysicsBody(rectangleOf: Ground.size) // giving physics to ground
        Ground.physicsBody?.categoryBitMask = PhysicsCatagory.Ground // applying the pgysics to ground
        Ground.physicsBody?.collisionBitMask = PhysicsCatagory.Ghost // if collision with ghost
        // ground dosent collides with the wall
        Ground.physicsBody?.contactTestBitMask  = PhysicsCatagory.Ghost//tests weather 2 have collided
        Ground.physicsBody?.affectedByGravity = false//gravity does not affect ground
        Ground.physicsBody?.isDynamic = false//ground does not move if something hits it
        
        Ground.zPosition = 3
        self.addChild(Ground)

    }
    
    //creating a ghost
    //setup for ghost
    //physics for ghost
    func addGhost(){
        Ghost = SKSpriteNode(imageNamed: GhostName)
        Ghost.size = CGSize(width: 100, height: 120)
        Ghost.position = CGPoint(x: self.frame.width / 2 - Ghost.frame.width, y: self.frame.height / 2)
        
        Ghost.physicsBody = SKPhysicsBody(circleOfRadius: Ghost.frame.height / 2)
        Ghost.physicsBody?.categoryBitMask = PhysicsCatagory.Ghost
        Ghost.physicsBody?.collisionBitMask = PhysicsCatagory.Ground | PhysicsCatagory.Wall //collides with both ground and walls
        Ghost.physicsBody?.contactTestBitMask = PhysicsCatagory.Ground | PhysicsCatagory.Wall | PhysicsCatagory.Score //tests weather they have collided
        Ghost.physicsBody?.affectedByGravity = false //does not get affected by gravity
        Ghost.physicsBody?.isDynamic = true //moves when collided
        
        Ghost.zPosition = 2
        
        self.addChild(Ghost)
      
    }
    
    func createBTN(){
        restartBTN = SKSpriteNode(imageNamed: "RestartBtn")
        restartBTN.size = CGSize(width: 200,height: 100)
        restartBTN.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        restartBTN.zPosition = 6
        restartBTN.setScale(0)
        addChild(restartBTN)
        
        restartBTN.run(SKAction.scale(to: 1.0, duration: 0.3))//anumating the button
        
    }
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == PhysicsCatagory.Score && secondBody.categoryBitMask == PhysicsCatagory.Ghost{
            
            score += 1
            scoreLbl.text = "\(score)"
            firstBody.node?.removeFromParent()  // removing the score node
            
        }
        else if firstBody.categoryBitMask == PhysicsCatagory.Ghost && secondBody.categoryBitMask == PhysicsCatagory.Score {
            
            score += 1
            scoreLbl.text = "\(score)"
            secondBody.node?.removeFromParent() // removing
            
        }
            
        else if firstBody.categoryBitMask == PhysicsCatagory.Ghost && secondBody.categoryBitMask == PhysicsCatagory.Wall || firstBody.categoryBitMask == PhysicsCatagory.Wall && secondBody.categoryBitMask == PhysicsCatagory.Ghost{
           
            enumerateChildNodes(withName: "wallPair", using: ({  // all the wall pair nodes picked up in the scene
                (node, error) in
                
                node.speed = 0 // stop the scene
                // this only stops the firs wall pair LOL
                self.removeAllActions()//stoppling all the walls
                
            }))
            if died == false{
                died = true
                 maxScores() //
                createBTN()
            }
        }
        else if firstBody.categoryBitMask == PhysicsCatagory.Ghost && secondBody.categoryBitMask == PhysicsCatagory.Ground || firstBody.categoryBitMask == PhysicsCatagory.Ground && secondBody.categoryBitMask == PhysicsCatagory.Ghost{
            enumerateChildNodes(withName: "wallPair", using: ({
                (node, error) in
                node.speed = 0
                self.removeAllActions()
                
            }))
            if died == false{
                died = true
                maxScores() //
                createBTN()
            }
        }
    }
    
    
    func createWalls(){
        
        let scoreNode = SKSpriteNode(imageNamed: "Coin")
        
        scoreNode.size = CGSize(width: 50, height: 50)
        scoreNode.position = CGPoint(x: self.frame.width + 25, y: self.frame.height/2)
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNode.size)
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.isDynamic = false
        scoreNode.physicsBody?.categoryBitMask = PhysicsCatagory.Score
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.contactTestBitMask = PhysicsCatagory.Ghost
        //scoreNode.color = SKColor.blue
        
        wallPair = SKNode()
        wallPair.name = "wallPair"
        let topWall = SKSpriteNode(imageNamed: "Wall")
        let btmWall = SKSpriteNode(imageNamed: "Wall")
        
        //x and y for the top and bottom pipes
        topWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 + 600)
        btmWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 - 600)
        
        topWall.setScale(0.8)
        btmWall.setScale(0.8)
        
        //top wall setup
        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        topWall.physicsBody?.categoryBitMask = PhysicsCatagory.Wall
        topWall.physicsBody?.collisionBitMask = PhysicsCatagory.Ghost // collide only with ghost
        topWall.physicsBody?.contactTestBitMask = PhysicsCatagory.Ghost
        topWall.physicsBody?.isDynamic = false
        topWall.physicsBody?.affectedByGravity = false
        
        //botom wall setup
        btmWall.physicsBody = SKPhysicsBody(rectangleOf: btmWall.size)
        btmWall.physicsBody?.categoryBitMask = PhysicsCatagory.Wall
        btmWall.physicsBody?.collisionBitMask = PhysicsCatagory.Ghost //collide only with ghost
        btmWall.physicsBody?.contactTestBitMask = PhysicsCatagory.Ghost
        btmWall.physicsBody?.isDynamic = false
        btmWall.physicsBody?.affectedByGravity = false
       
        topWall.zRotation = CGFloat.pi  // reverse the top wall because is was showin up upside down for top
        
        // addting walls to wallpair
        wallPair.addChild(topWall)
        wallPair.addChild(btmWall)
        
        wallPair.zPosition = 1
        
        let randomPosition = CGFloat.random(min: -200, max: 200)
        
        wallPair.position.y = wallPair.position.y + randomPosition
        wallPair.addChild(scoreNode)
        
        wallPair.run(moveAndRemove)
        self.addChild(wallPair)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        Ghost.physicsBody?.affectedByGravity = true // ghost will be affected by gravity as soon as we click
        if gameStarted == false{
            gameStarted = true
            let spawn = SKAction.run({
                () in
                self.createWalls()
            })
            
            let delay = SKAction.wait(forDuration: 2.0) // wall delay here
            let SpawnDelay = SKAction.sequence([spawn, delay])
            let spawnDelayForever = SKAction.repeatForever(SpawnDelay)
            self.run(spawnDelayForever)
            
            let distance = CGFloat(self.frame.width + wallPair.frame.width)
            let movePipes = SKAction.moveBy(x: -distance - 50, y: 0, duration: (TimeInterval(0.008 * distance))) // speed of the pipes
            let removePipes = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([movePipes, removePipes])
            
            Ghost.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            Ghost.physicsBody?.applyImpulse(CGVector(dx: 0, dy: jmp)) // jump height ------------------------
            
        }
        else{
            if died == true {
                
            }
            else {
                Ghost.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                Ghost.physicsBody?.applyImpulse(CGVector(dx: 0, dy: jmp)) // jump height ------------------
            }
        }
        
        
        for touch in touches {
            let location = touch.location(in: self)
            if died == true{
                if restartBTN.contains(location){
                    restartScene()
                }
                
            }
        }
    }

    override func update(_ currentTime: CFTimeInterval) {
        if gameStarted == true{
            if died == false{
                enumerateChildNodes(withName: "background", using: ({
                    (node, error) in
                    
                    let bg = node as! SKSpriteNode
                    
                    bg.position = CGPoint(x: bg.position.x - 2, y: bg.position.y)
                    
                    if bg.position.x <= -bg.size.width {
                        bg.position = CGPoint(x: bg.position.x + bg.size.width * 2, y: bg.position.y)
                        
                    }
                    
                }))
                
            }
            
            
        }
        
    }
    
    func maxScores(){
        
        // finding the location of the minimum score
        if game.scores[0]<game.scores[1] && game.scores[0]<game.scores[2]{
            min = 0;
        }
        else if game.scores[1]<game.scores[0] && game.scores[1]<game.scores[2]{
            min = 1;
        }
        else if game.scores[2]<game.scores[0] && game.scores[2]<game.scores[1]{
            min = 2;
        }
        
        // putting the scores in the array
        if game.scores[i] == 0{
            game.scores[i] = score;
            i = i+1;
        }
        else{ // replacing the lowest score with new score
            if score > game.scores[min] {
                game.scores[min] = score;
            }
        }
        
        if i==3{
            i=0;
        }
        
        
    }
    
    
}
