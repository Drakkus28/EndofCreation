//
//  GameOver.swift
//  Stranded
//
//  Created by Laufer, Michael R on 1/26/18.
//  Copyright © 2018-2019 Laufer, Michael R. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    var board:[SKLabelNode] = [SKLabelNode(fontNamed: "Arial")]
    var highScoresN:[String] = []
    var highScoresS:[Int] = []
    
    init(size: CGSize, score:Int, scoreList: [Int], nameList: [String]) {
        super.init(size: size)
        highScoresN = nameList
        highScoresS = scoreList
        board[0].text = ""
        board[0].fontSize = 12
        board[0].fontColor = SKColor.white
        board[0].position = CGPoint(x: self.frame.midX, y: self.frame.height-40)
        backgroundColor = SKColor.black
        highScoresS.append(20*score)
        highScoresN.append(UIDevice.current.name)
        highScoresS = highScoresS.sorted { $0 > $1 }
        var i = 0
        while i < highScoresS.count-1
        {
            if highScoresS[i] == (20*score)
            {
                let hold = highScoresN[i]
                highScoresN[i] = UIDevice.current.name
                highScoresN[i+1] = hold
            }
            i+=1
        }
        if highScoresN.count>10
        {
            for _ in 0...highScoresN.count-10
            {
                highScoresN.removeLast()
                highScoresS.removeLast()
            }
        }
        for count in 0...highScoresN.count-1
        {
            board[count].text = "\(highScoresN[count]) - \(highScoresS[count])"
            self.addChild(board[count])
            if count < 9
            {
                board.append(SKLabelNode(fontNamed: "Arial"))
                board[count+1].text = ""
                board[count+1].fontSize = 12
                board[count+1].fontColor = SKColor.white
                board[count+1].position = CGPoint(x: self.frame.midX, y: CGFloat(Int(self.frame.height)-((count+3)*20)))
            }
        }
        UserDefaults.standard.set(highScoresS, forKey: "Scores")
        UserDefaults.standard.set(highScoresN, forKey: "Names")
        UserDefaults.standard.synchronize()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view?.presentScene(GameScene(size: self.size))
    }
    
    // 6
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
