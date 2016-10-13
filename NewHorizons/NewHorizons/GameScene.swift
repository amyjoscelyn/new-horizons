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
    var asteroid = SKSpriteNode(imageNamed: "Asteroid")
    
    override func didMove(to view: SKView)
    {
        backgroundColor = SKColor.black
        
        //set up scene here
        satellite.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        addChild(satellite)
        
        asteroid.position = CGPoint(x: frame.size.width / 2 - 200, y: frame.size.height / 2 - 100)
        addChild(asteroid)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        //this is called before each frame is rendered
    }
}
