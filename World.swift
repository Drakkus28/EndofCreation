//
//  World.swift
//  Stranded
//
//  Created by Michael Laufer on 4/4/19.
//  Copyright © 2019 Laufer, Michael R. All rights reserved.
//

import Foundation
import SpriteKit

struct World
{
    var image:SKSpriteNode
    var worldtiles:[[Int]]
    
    mutating func setup()
    {
        image.lightingBitMask = 0b0001
        image.zPosition = -2
        image.xScale = 2
        image.yScale = 2
        image.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        var top:Bool = false
        var right:Bool = false
        var structure:[[Int]] = [[2,2,1,1,1,2,2],
                                 [1,1,0,1,0,1,1],
                                 [2,1,1,0,1,1,2],
                                 [1,1,1,1,0,1,1],
                                 [2,1,0,1,1,0,1],
                                 [1,0,1,1,0,1,2],
                                 [2,1,2,1,1,2,2]]
        if worldtiles[0].isEmpty && worldtiles.count<2
        {
            for i in 0...99
            {
                for _ in 0...99
                {
                    if Int.random(in:1...10000)>9996
                    {
                        worldtiles[i].append(10)
                    }
                    else
                    {
                        worldtiles[i].append(0)
                    }
                }
                if i != 99
                {
                    worldtiles.append([])
                }
            }
            for j in 0...worldtiles.count-1
            {
                if let i = worldtiles[j].firstIndex(of:10)
                {
                    if i < 92
                    {
                        right = true
                    }
                    if j < 92
                    {
                        top = true
                    }
                    if top && right
                    {
                        for k in 0...6
                        {
                            for l in 0...6
                            {
                                worldtiles[j+k][i+l] = structure[k][l]
                            }
                        }
                    }
                    else if top && !right
                    {
                        for k in 0...6
                        {
                            for l in 0...6
                            {
                                worldtiles[j+k][i-l] = structure[k][6-l]
                            }
                        }
                    }
                    else if !top && right
                    {
                        for k in 0...6
                        {
                            for l in 0...6
                            {
                                worldtiles[j-k][i+l] = structure[6-k][l]
                            }
                        }
                    }
                    else
                    {
                        for k in 0...6
                        {
                            for l in 0...6
                            {
                                worldtiles[j-k][i-l] = structure[6-k][6-l]
                            }
                        }
                    }
                }
                top = false
                right = false
            }
        }
    }
    
    func update(delx:CGFloat,dely:CGFloat)
    {
        let move = SKAction.move(to: CGPoint(x: image.position.x - 2*delx,y: image.position.y - 2*dely),duration: 0.2)
        move.timingMode = .easeOut
        image.run(move)
    }
}
