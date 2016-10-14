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
    var missionDurationLabel = SKLabelNode(text: "Mission Duration")
    var missionMinuteLabel = SKLabelNode(text: "Minute")
    var missionHourLabel = SKLabelNode(text: "Hour")
    var missionDayLabel = SKLabelNode(text: "Day")
    var day = 0
    var hour = 0
    var minute = 0
    var dayTimeLabel = SKLabelNode(text: "")
    var hourTimeLabel = SKLabelNode(text: "")
    var minuteTimeLabel = SKLabelNode(text: "")
    
    var dodgedAsteroids = 0
    var asteroidsDodgedCountLabel = SKLabelNode(text: "0")
    var asteroidsDodgedLabel = SKLabelNode(text: "Asteroids dodged")
    var asteroidsDodgedImage = SKSpriteNode(imageNamed: "AsteroidsDodged")
    
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
        
        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.run(spawnAsteroid),
            SKAction.wait(forDuration: 1.0)
            ])), withKey: "spawnAsteroid")
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -0.9)
        
        satellite.physicsBody?.contactTestBitMask = bitMask.asteroid.rawValue
        satellite.physicsBody?.collisionBitMask = bitMask.frame.rawValue
        
        missionDurationLabel.fontSize = 30
        missionDurationLabel.fontName = "Helvetica Neue"
        missionDurationLabel.fontColor = SKColor.red
        missionDurationLabel.position = CGPoint(x: frame.size.width / 2, y: frame.size.height - 45)
        addChild(missionDurationLabel)
        
        missionMinuteLabel.fontSize = 30
        missionMinuteLabel.fontName = "Helvetica Neue"
        missionMinuteLabel.position = CGPoint(x: frame.size.width / 2 + 150, y: frame.size.height - 85)
        addChild(missionMinuteLabel)
        
        missionHourLabel.fontSize = 30
        missionHourLabel.fontName = "Helvetica Neue"
        missionHourLabel.position = CGPoint(x: frame.size.width / 2, y: frame.size.height - 85)
        addChild(missionHourLabel)
        
        missionDayLabel.fontSize = 30
        missionDayLabel.fontName = "Helvetica Neue"
        missionDayLabel.position = CGPoint(x: frame.size.width / 2 - 150, y: frame.size.height - 85)
        addChild(missionDayLabel)
        
        minuteTimeLabel.fontSize = 30
        minuteTimeLabel.fontName = "Helvetica Neue"
        minuteTimeLabel.position = CGPoint(x: frame.size.width / 2 + 150, y: frame.size.height - 120)
        addChild(minuteTimeLabel)
        
        hourTimeLabel.fontSize = 30
        hourTimeLabel.fontName = "Helvetica Neue"
        hourTimeLabel.position = CGPoint(x: frame.size.width / 2, y: frame.size.height - 120)
        addChild(hourTimeLabel)
        
        dayTimeLabel.fontSize = 30
        dayTimeLabel.fontName = "Helvetica Neue"
        dayTimeLabel.position = CGPoint(x: frame.size.width / 2 - 150, y: frame.size.height - 120)
        addChild(dayTimeLabel)
        
        asteroidsDodgedImage.position = CGPoint(x: frame.size.width / 5.7, y: frame.size.height - 350)
        addChild(asteroidsDodgedImage)
        
        asteroidsDodgedLabel.fontSize = 28
        asteroidsDodgedLabel.fontName = "Helvetica Neue"
        asteroidsDodgedLabel.position = CGPoint(x: frame.size.width / 4.7, y: frame.size.height - 400)
        asteroidsDodgedLabel.zPosition = 1
        addChild(asteroidsDodgedLabel)
        
        asteroidsDodgedCountLabel.fontSize = 30
        asteroidsDodgedCountLabel.fontName = "Helvetica Neue"
        asteroidsDodgedCountLabel.position = CGPoint(x: frame.size.width / 15.5, y: frame.size.height - 350)
        asteroidsDodgedCountLabel.zPosition = 1
        addChild(asteroidsDodgedCountLabel)
        
        
        let updateMissionTimeLabels = SKAction.run(updateMissionTime)
        let updateTime = SKAction.wait(forDuration: 1.0)
        let updateSequence = SKAction.sequence([updateMissionTimeLabels, updateTime])
        run(SKAction.repeatForever(updateSequence), withKey: "missionDurationTime")
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
        
        asteroid.name = "Asteroid"
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
            
            removeAction(forKey: "missionDurationTime")
            removeAction(forKey: "spawnAsteroid")
            
            enumerateChildNodes(withName: "Asteroid", using: { (asteroid, _) in
                asteroid.name = "dontCountMe"
            })
            
        default:
            return
        }
    }
    
    func updateMissionTime()
    {
        minute += 1
        
        if minute == 60
        {
            hour += 1
            minute = 0
        }
        
        if hour == 60
        {
            day += 1
            hour = 0
        }
        
        minuteTimeLabel.text = "\(minute)"
        hourTimeLabel.text = "\(hour)"
        dayTimeLabel.text = "\(day)"
        
        
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        enumerateChildNodes(withName: "Asteroid") { asteroid,_ in
            
            if asteroid.position.y <= 3
            {
                self.dodgedAsteroids += 1
                self.asteroidsDodgedCountLabel.text = (text: "\(self.dodgedAsteroids)")
                asteroid.removeFromParent()
            }
        }
        
    }
}
