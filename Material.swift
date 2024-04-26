//
//  Material.swift
//  Stranded
//
//  Created by Michael Laufer on 4/4/19.
//  Copyright © 2019 Laufer, Michael R. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

struct Material
{
    var image:SKSpriteNode
    
    func setup()
    {
        image.lightingBitMask = 0b0001
        image.physicsBody = SKPhysicsBody(rectangleOf: image.size)
        image.physicsBody?.isDynamic = true
        image.physicsBody?.usesPreciseCollisionDetection = true
        image.physicsBody?.categoryBitMask = PhysicsCategory.Material
        image.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        image.physicsBody?.collisionBitMask = PhysicsCategory.None
    }
    
    func update(delx:CGFloat,dely:CGFloat)
    {
        let move = SKAction.move(to: CGPoint(x: image.position.x - delx,y: image.position.y - dely),duration: 0.2)
        move.timingMode = .easeOut
        image.run(move)
    }
}
