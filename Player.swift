//
//  Player.swift
//  Stranded
//
//  Created by Laufer, Michael R on 1/26/18.
//  Copyright © 2018-2019 Laufer, Michael R. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

struct Player
{
    //var images:[SKTexture]
    var image:SKSpriteNode
    var health:Int
    var rifle:Int
    var uzi:Int
    var shotgun:Int
    var blunderbuss:Int
    var material:Int
    
    func setup()
    {
        image.physicsBody = SKPhysicsBody(rectangleOf: image.size)
        image.physicsBody?.isDynamic = true
        image.physicsBody?.usesPreciseCollisionDetection = true
        image.physicsBody?.categoryBitMask = PhysicsCategory.Player
        image.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
        image.physicsBody?.collisionBitMask = PhysicsCategory.None
        image.zPosition = 0
        image.xScale = 2
        image.yScale = 2
    }
    
    mutating func giveAmmo()
    {
        switch Int(arc4random_uniform(4)) {
        case 0:
            rifle+=10
        case 1:
            uzi+=50
        case 2:
            shotgun+=8
        case 3:
            blunderbuss+=5
        default:
            rifle+=10
        }
    }
    
    mutating func giveMaterial()
    {
        material+=1
    }
}
