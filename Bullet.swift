//
//  Bullet.swift
//  Stranded
//
//  Created by Laufer, Michael R on 12/12/17.
//  Copyright © 2017-2018 Laufer, Michael R. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

struct bullet
{
    var angle:Double
    var speed:Int
    let image:SKSpriteNode
    var damage:Double
    
    func setup()
    {
        image.lightingBitMask = 0b0001
        image.physicsBody = SKPhysicsBody(rectangleOf: image.size)
        image.physicsBody?.isDynamic = true
        //image.physicsBody?.usesPreciseCollisionDetection = true
        image.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        image.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
        image.physicsBody?.collisionBitMask = PhysicsCategory.None
        image.xScale = 2
        image.yScale = 2
    }
    
    func update(delx:CGFloat,dely:CGFloat)
    {
        let move = SKAction.move(to: CGPoint(
            x: image.position.x - CGFloat(CGFloat(speed)*CGFloat(cos(angle))+2*delx),
            y: image.position.y + CGFloat(CGFloat(speed)*CGFloat(sin(angle))+2*dely)),
            duration: 0.2)
        move.timingMode = .easeOut
        image.run(move)
    }
}
