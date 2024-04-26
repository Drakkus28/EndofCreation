//
//  Zombie.swift
//  Stranded
//
//  Created by Laufer, Michael R on 1/3/18.
//  Copyright © 2018-2019 Laufer, Michael R. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

struct Zombie
{
    var health:Int
    var speed:Double
    var image:SKSpriteNode
    var damage:Int
    var target:Int
    
    mutating func setup()
    {
        if image == #imageLiteral(resourceName: "EOC_Zombie_Hulk")
        {
            health += 100
            speed /= 2
            damage = Int(Double(damage) * 2.5)
        }
        else if arc4random_uniform(9) == 8
        {
            image.alpha = 0.15
        }
        image.lightingBitMask = 0b0001
        image.physicsBody = SKPhysicsBody(rectangleOf: image.size)
        image.physicsBody?.restitution = 0.01
        image.physicsBody?.linearDamping = 0
        image.physicsBody?.friction = 0.3
        image.physicsBody?.isDynamic = true
        image.physicsBody?.usesPreciseCollisionDetection = true
        image.physicsBody?.categoryBitMask = PhysicsCategory.Monster
        image.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        image.physicsBody?.collisionBitMask = PhysicsCategory.Monster
        image.zPosition = 0
        image.xScale = 2
        image.yScale = 2
    }
    
    func update(player:SKSpriteNode, delx:CGFloat, dely:CGFloat)
    {
        var angle = atan2(Double(player.position.x-image.position.x), Double(player.position.y-image.position.y))
        //Gather the angle of the zombie to the player
        angle += 1.5708
        //adjust a quarter turn to get the apropriate angle to the player
        let move = SKAction.move(to: CGPoint(
            x: image.position.x - CGFloat(speed)*CGFloat(cos(angle))-2*delx,
            y: image.position.y + CGFloat(speed)*CGFloat(sin(angle))-2*dely),
            duration: 0.2)
        //use rect.x+=_ and rect.y+=_ when calculating the distance traveled
        angle = atan2(Double(player.position.y-image.position.y), Double(player.position.x-image.position.x))
        //take the angle again, or subtract 3.1415 from angle
        angle -= 1.5708
        image.zRotation = CGFloat(angle)
        move.timingMode = .linear
        image.run(move)
    }
}
