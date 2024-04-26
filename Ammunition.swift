//
//  Ammunition.swift
//  Stranded
//
//  Created by Laufer, Michael R on 4/17/18.
//  Copyright © 2018-2019 Laufer, Michael R. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

struct Ammunition
{
    var image:SKSpriteNode
    
    func setup()
    {
        //image.lightingBitMask = 0b0001
        image.physicsBody = SKPhysicsBody(rectangleOf: image.size)
        image.physicsBody?.isDynamic = true
        image.physicsBody?.usesPreciseCollisionDetection = true
        image.physicsBody?.categoryBitMask = PhysicsCategory.Ammunition
        image.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        image.physicsBody?.collisionBitMask = PhysicsCategory.None
        image.xScale = 2
        image.yScale = 2
        image.zPosition = 0
    }
    
    func update(delx:CGFloat,dely:CGFloat)
    {
        let move = SKAction.move(to: CGPoint(x: image.position.x - 2*delx,y: image.position.y - 2*dely),duration: 0.2)
        move.timingMode = .easeOut
        image.run(move)
    }
}
