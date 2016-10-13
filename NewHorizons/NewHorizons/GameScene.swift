//
//  GameScene.swift
//  NewHorizons
//
//  Created by Amy Joscelyn on 10/13/16.
//  Copyright © 2016 Amy Joscelyn. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene
{
    var satellite = SKSpriteNode(imageNamed: "sat2")
//    var asteroid = SKSpriteNode(imageNamed: "Asteroid")
    
    override func didMove(to view: SKView)
    {
        backgroundColor = SKColor.black
        
        //set up scene here
        satellite.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        addChild(satellite)
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(spawnAsteroid),
                SKAction.wait(forDuration: 1.0)
                ])
        ))
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -0.9)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first! as UITouch
        let touchLocation = touch.location(in: self)
        print(touchLocation)
        
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
        asteroid.physicsBody = SKPhysicsBody(circleOfRadius: asteroid.frame.size.width * 0.3)
        addChild(asteroid)
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        //this is called before each frame is rendered
    }
}
