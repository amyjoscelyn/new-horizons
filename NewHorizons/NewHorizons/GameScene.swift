//
//  GameScene.swift
//  NewHorizons
//
//  Created by Amy Joscelyn on 10/13/16.
//  Copyright © 2016 Amy Joscelyn. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate
{
    enum bitMask: UInt32
    {
        case satellite = 1
        case asteroid = 2
        case frame = 4
    }
    
    var satellite = SKSpriteNode(imageNamed: "sat2")
    
    override func didMove(to view: SKView)
    {
        backgroundColor = SKColor.black
        
        //set up scene here
        satellite.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        satellite.physicsBody = SKPhysicsBody(texture: satellite.texture!, size: satellite.frame.size)
        satellite.physicsBody?.isDynamic = false
        satellite.physicsBody?.affectedByGravity = false
        satellite.physicsBody?.allowsRotation = false
        satellite.physicsBody?.categoryBitMask = bitMask.satellite.rawValue
        satellite.physicsBody?.contactTestBitMask = bitMask.asteroid.rawValue
        satellite.physicsBody?.collisionBitMask = 0 //prevents satellite from bouncing off the asteroids
        
        addChild(satellite)
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(spawnAsteroid),
                SKAction.wait(forDuration: 1.0)
                ])
        ))
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -0.9)
        
        satellite.physicsBody?.contactTestBitMask = bitMask.asteroid.rawValue
        satellite.physicsBody?.collisionBitMask = bitMask.frame.rawValue
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first! as UITouch
        let touchLocation = touch.location(in: self)
//        print(touchLocation)
        let moveTo = SKAction.move(to: touchLocation, duration: 1.0)
        satellite.run(moveTo)
    }
    
    func randomNumber(min: CGFloat, max: CGFloat) -> CGFloat
    {
        let random = CGFloat(Float(arc4random()) / 0xFFFFFFFF)
        return random * (max - min) + min
    }
    
    func spawnAsteroid()
    {
        let asteroid = SKSpriteNode(imageNamed: "Asteroid")
        asteroid.position = CGPoint(x: frame.size.width * randomNumber(min: 0, max: 1), y: frame.size.height + asteroid.size.height)
//        asteroid.physicsBody = SKPhysicsBody(circleOfRadius: asteroid.frame.size.width * 0.3)
        asteroid.physicsBody = SKPhysicsBody(texture: asteroid.texture!, size: asteroid.frame.size)
        asteroid.physicsBody?.categoryBitMask = bitMask.asteroid.rawValue
        asteroid.physicsBody?.contactTestBitMask = bitMask.satellite.rawValue
        
        addChild(asteroid)
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch contactMask
        {
        case bitMask.satellite.rawValue | bitMask.asteroid.rawValue:
            let secondNode = contact.bodyB.node
            secondNode?.physicsBody?.allowsRotation = true
            let firstNode = contact.bodyA.node
            firstNode?.physicsBody?.allowsRotation = true
            firstNode?.removeFromParent()
        default:
            return
        }
    }
}
