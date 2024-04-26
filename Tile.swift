//
//  Tile.swift
//  Stranded
//
//  Created by Michael Laufer on 4/4/19.
//  Copyright © 2019 Laufer, Michael R. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

struct Tile
{
    var type:Int
    var image:SKSpriteNode = SKSpriteNode()
    
    mutating func setup()
    {
        image.lightingBitMask = 0b0001
        image.physicsBody = SKPhysicsBody(rectangleOf: image.size)
        image.physicsBody?.isDynamic = true
        image.physicsBody?.usesPreciseCollisionDetection = true
        image.zPosition = -1.9
        image.setScale(2)
        if type == 0
        {
            image = SKSpriteNode(imageNamed: "Empty.png")
            image.physicsBody = SKPhysicsBody(rectangleOf: image.size)
            image.physicsBody?.categoryBitMask = PhysicsCategory.None
            image.physicsBody?.contactTestBitMask = PhysicsCategory.None
            image.physicsBody?.collisionBitMask = PhysicsCategory.None
            image.setScale(2)
            image.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        }
        else if type == 1
        {
            image = SKSpriteNode(imageNamed: "Floor.png")
            image.physicsBody = SKPhysicsBody(rectangleOf: image.size)
            image.physicsBody?.categoryBitMask = PhysicsCategory.Floor
            image.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
            image.physicsBody?.collisionBitMask = PhysicsCategory.None
            image.setScale(2)
            image.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        }
        else if type == 2
        {
            image = SKSpriteNode(imageNamed: "EOC_Barricade.png")
            image.physicsBody = SKPhysicsBody(rectangleOf: image.size)
            image.physicsBody?.categoryBitMask = PhysicsCategory.Floor
            image.physicsBody?.contactTestBitMask = PhysicsCategory.Monster | PhysicsCategory.Player
            image.physicsBody?.collisionBitMask = PhysicsCategory.None
            image.setScale(2)
            image.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        }
    }
}
