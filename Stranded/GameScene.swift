//
//  GameScene.swift
//  Stranded
//
//  Created by Laufer, Michael R on 10/30/17.
//  Copyright © 2017-2019 Laufer, Michael R. All rights reserved.
//

import SpriteKit
import GameplayKit
import MultipeerConnectivity

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Monster   : UInt32 = 0b1
    static let Projectile: UInt32 = 0b10
    static let Player    : UInt32 = 0b100
    static let Ammunition: UInt32 = 0b1000
    static let Health    : UInt32 = 0b10000
    static let Material  : UInt32 = 0b100000
    static let Floor     : UInt32 = 0b1000000
    static let Wall      : UInt32 = 0b10000000
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var optimizeScale = 2
    var medkit:[Medkit] = []
    var ammunit:[Ammunition] = []
    var width:CGFloat = 0
    var height:CGFloat = 0
    let tabledata1 = UserDefaults.standard.array(forKey: "Names")
    let tabledata2 = UserDefaults.standard.array(forKey: "Scores")
    var highScoresN:[String] = ["Dev"]
    var highScoresS:[Int] = [1000]
    var player = Player(image: SKSpriteNode(imageNamed:"character"), health: 100, rifle: 0, uzi: 0, shotgun: 0, blunderbuss: 0, material: 0)
    let worldt = UserDefaults.standard.array(forKey:"World")
    var world:World = World(image:SKSpriteNode(), worldtiles:[[]])
    var worldTiles:[[Tile]] = [[]]
    var Mplayers:[Player] = []
    var mPlayersData:[Data] = []
    let base1 = SKSpriteNode(imageNamed:"bases")
    let base2 = SKSpriteNode(imageNamed:"bases")
    var stickActive = false
    var stick2Active = false
    var travel = 0
    var angle: CGFloat = 0
    var location: CGPoint = CGPoint()
    var location2: CGPoint = CGPoint()
    let lightNode = SKLightNode()
    let ball1X = 54
    var ballY = 263
    var ball2X = 543
    let ball1 = UIImageView(image: #imageLiteral(resourceName: "ball"))
    let ball2 = UIImageView(image: #imageLiteral(resourceName: "ball"))
    let pistol:Weapon = Weapon(name: "Pistol", rof: 3, cartrigeSize: 12
        , damage: 25.0, image: SKSpriteNode(imageNamed: "EOC_Pistol"))
    let rifle:Weapon = Weapon(name: "Rifle", rof: 1, cartrigeSize: 10
        , damage: 50.0, image: SKSpriteNode(imageNamed: "EOC_Rifle"))
    let uzi:Weapon = Weapon(name: "Uzi", rof: 50, cartrigeSize: 50
        , damage: 10.0, image: SKSpriteNode(imageNamed: "EOC_Uzi"))
    let shotgun:Weapon = Weapon(name: "Shotgun", rof: 1, cartrigeSize: 8, damage: 15.0, image: SKSpriteNode(imageNamed: "EOC_Shotgun"))
    let blunderbuss:Weapon = Weapon(name: "Blunderbuss", rof: 1, cartrigeSize: 1, damage: 20, image: SKSpriteNode(imageNamed: "EOC_Blunderbuss"))
    var arsenalSelected = 0
    var mats:[Material] = []
    var bullets:[bullet] = []
    var zombies:[Zombie] = []
    var arsenal:[Weapon] = []
    var lastTime:Double = 0
    var lastTimeBullet:Double = 0
    var fired:Int = 0
    let mySegLabel: UILabel = UILabel(frame: CGRect(x: 0,y: 0,width: 150,height: 150))
    var score = SKLabelNode(fontNamed: "Arial")
    var ammo = SKLabelNode(fontNamed: "Arial")
    var life = SKLabelNode(fontNamed: "Arial")
    let mySegcon: UISegmentedControl = UISegmentedControl(items: [#imageLiteral(resourceName: "EOC_Pistol"),#imageLiteral(resourceName: "EOC_Rifle"),#imageLiteral(resourceName: "EOC_Uzi"),#imageLiteral(resourceName: "EOC_Shotgun"),#imageLiteral(resourceName: "EOC_Blunderbuss")])
    var killed = 0
    var spawnTime = 1.5
    var named = UIDevice.current.name
    var cSpawnTimeS:Double = 30
    var modify = true
    var alldelx:CGFloat = 0
    var alldely:CGFloat = 0
    //let serviceManager = ServiceManager()
    
    override func didMove(to view: SKView) {
        //serviceManager.delegate = self as? ServiceManagerDelegate
        //Mplayers.append(player)
        scene?.scaleMode = .resizeFill
        width = (self.view?.frame.size.width)!
        height = (self.view?.frame.size.height)!
        ballY = Int((self.view?.frame.maxY)!) - 124
        ball2X = Int((self.view?.frame.maxX)!) - 124
        //UserDefaults.standard.set([12, 45, 9283], forKey: "Test")
        if let worldt:[[Int]] = worldt as? [[Int]]
        {
            world = World(image: SKSpriteNode(imageNamed:"World"),worldtiles:worldt)
        }
        else
        {
            world = World(image: SKSpriteNode(imageNamed:"World"),worldtiles:[[]])
        }
        world.setup()
        for i in 0...99
        {
            for j in 0...99
            {
                worldTiles[i].append(Tile(type:world.worldtiles[i][j], image: SKSpriteNode(imageNamed: "Empty.png")))
            }
            worldTiles.append([])
        }
        for i in 0...99
        {
            for j in 0...99
            {
                worldTiles[i][j].setup()
                worldTiles[i][j].image.position = CGPoint(x:Double(42*j)-2079,y:Double(42*i)-2079)
                //self.addChild(worldTiles[i][j].image)
            }
            print(world.worldtiles[i])
        }
        self.addChild(world.image)
        if let data1:[String] = tabledata1 as? [String], let data2:[Int] = tabledata2 as? [Int]
        {
            if !data1.isEmpty && !data2.isEmpty
            {
                highScoresN = data1
                highScoresS = data2
            }
        }
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
        player.setup()
        ball1.frame = CGRect(x: ball1X, y: ballY, width: 70, height: 70)
        ball2.frame = CGRect(x: ball2X, y: ballY, width: 70, height: 70)
        view.addSubview(ball1)
        view.addSubview(ball2)
        self.backgroundColor = .black
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.addChild(player.image)
        self.addChild(base1)
        self.addChild(base2)
        player.image.position = CGPoint(x: 0, y: 0)
        base1.position = CGPoint(x: -(0.5*width)+89, y: -(0.5*height)+89)
        base2.position = CGPoint(x: (0.5*width)-89, y: -(0.5*height)+89)
        base1.setScale(4)
        base2.setScale(4)
        base1.alpha = 0.4
        base2.alpha = 0.4
        ball1.isUserInteractionEnabled = true
        ball2.isUserInteractionEnabled = true
        lightNode.position = CGPoint(x: 0, y: 0)
        lightNode.categoryBitMask = 0b0001
        lightNode.lightColor = .white
        self.addChild(lightNode)
        player.image.lightingBitMask = 0b0001
        player.image.shadowCastBitMask = 0b0001
        let stick1: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(GameScene.handlePan1(_:)))
        ball1.addGestureRecognizer(stick1)
        let stick2: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(GameScene.handlePan2(_:)))
        ball2.addGestureRecognizer(stick2)
        arsenal.append(pistol)
        arsenal.append(rifle)
        arsenal.append(uzi)
        arsenal.append(shotgun)
        arsenal.append(blunderbuss)
        mySegcon.center = CGPoint(x: (0.5*width), y: 25) 
        mySegcon.backgroundColor = UIColor.black
        mySegcon.tintColor = UIColor.white
        mySegcon.selectedSegmentIndex = 0
        mySegcon.addTarget(self, action: #selector(GameScene.segmentedValueChanged(_:)), for: .valueChanged)
        self.view?.addSubview(mySegcon)
        score.text = "Score: 0"
        score.fontSize = 12
        score.fontColor = SKColor.white
        score.position = CGPoint(x: -(0.5*width)+34, y: (0.5*height)-13)//-300, 175
        self.addChild(score)
        ammo.text = "Ammo: "
        ammo.fontSize = 12
        ammo.fontColor = SKColor.white
        ammo.position = CGPoint(x: -(0.5*width)+34, y: (0.5*height)-28)//-300, 160
        self.addChild(ammo)
        life.text = "Health: "
        life.fontSize = 12
        life.fontColor = SKColor.white
        life.position = CGPoint(x: -(0.5*width)+34, y: (0.5*height)-43)//-300, 145
        life.zPosition = 1
        self.addChild(life)
        player.image.zPosition = 0
    }
    
    @objc func segmentedValueChanged(_ sender:UISegmentedControl!)
    {
        arsenalSelected = sender.selectedSegmentIndex
        switch arsenalSelected {
        case 1:
            if player.rifle > 0
            {
                fired = 10-(player.rifle%10)
            }
            else
            {
                sender.selectedSegmentIndex = 0
                arsenalSelected = 0
            }
        case 2:
            if player.uzi > 0
            {
                fired = 50-(player.uzi%50)
            }
            else
            {
                sender.selectedSegmentIndex = 0
                arsenalSelected = 0
            }
        case 3:
            if player.shotgun > 0
            {
                fired = 8-(player.shotgun%8)
            }
            else
            {
                sender.selectedSegmentIndex = 0
                arsenalSelected = 0
            }
        case 4:
            if player.blunderbuss > 0
            {
                fired = 0
            }
            else
            {
                sender.selectedSegmentIndex = 0
                arsenalSelected = 0
            }
        default:
            fired = 0
        }
    }
    
    @objc func handlePan1(_ recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        if recognizer.state == .ended
        {
            ball1.frame = CGRect(x: ball1X, y: ballY, width: 70, height: 70)
        }
    }
    
    @objc func handlePan2(_ recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        if recognizer.state == .ended
        {
            ball2.frame = CGRect(x: ball2X, y: ballY, width: 70, height: 70)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        for row in worldTiles
        {
            for tile in row
            {
                if tile.image.position.x<(0-width/2) || tile.image.position.x>(0+width/2) || tile.image.position.y<(0-height/2) || tile.image.position.y>(0+height/2)
                {
                    tile.image.removeFromParent()
                }
                else
                {
                    if !self.children.contains(tile.image)
                    {
                        self.addChild(tile.image)
                    }
                }
                tile.image.position.x-=0.2*alldelx
                tile.image.position.y-=0.2*alldely
                /*let move = SKAction.move(to: CGPoint(x: tile.image.position.x - alldelx,y: tile.image.position.y - alldely),duration: 0.2)
                move.timingMode = .linear
                tile.image.run(move)*/
            }
        }
        /*if player.health>0
        {
            var dataArr: [Data] = []
            let data:Data = Data(buffer: UnsafeBufferPointer(start: &player.image, count: 19))
            dataArr.append(data)
            serviceManager.send(data: data)
        }*/
        if currentTime > cSpawnTimeS
        {
            switch arc4random_uniform(2)
            {
            case 0:
                let kitI = SKSpriteNode(imageNamed: "EOC_Medkit")
                kitI.position = CGPoint(x: Double(arc4random_uniform(UInt32(width)))-Double(width/2), y: Double(arc4random_uniform(UInt32(height)))-Double(height/2))
                medkit.append(Medkit(image: kitI))
                medkit.last?.setup()
                self.addChild((medkit.last?.image)!)
                cSpawnTimeS += (currentTime+1)
            case 1:
                let kitI = SKSpriteNode(imageNamed: "EOC_Ammo")
                kitI.position = CGPoint(x: Double(arc4random_uniform(UInt32(width)))-Double(width/2), y: Double(arc4random_uniform(UInt32(height)))-Double(height/2))
                ammunit.append(Ammunition(image: kitI))
                ammunit.last?.setup()
                self.addChild((ammunit.last?.image)!)
                cSpawnTimeS += (currentTime+0.2)
            default: break
            }
        }
        playerMove(ball: ball1.frame, base: CGPoint(x: ball1X+35, y: ballY+35))
        playerAngle(ball: ball1.frame, base: CGPoint(x: ball1X+35, y: ballY+35))
        if stick2Active
        {
            playerAngle(ball: ball2.frame, base: CGPoint(x: ball2X+35, y: ballY+35))
        }
        var image = SKSpriteNode()
        switch arc4random_uniform(9)
        {
        case 0:
            image = SKSpriteNode(imageNamed:"EOC_Zombie_1")
        case 1:
            image = SKSpriteNode(imageNamed:"EOC_Zombie_2")
        case 2:
            image = SKSpriteNode(imageNamed:"EOC_Zombie_3")
        case 3:
            image = SKSpriteNode(imageNamed:"EOC_Zombie_4")
        case 4:
            image = SKSpriteNode(imageNamed:"EOC_Zombie_Hulk")
        case 5:
            image = SKSpriteNode(imageNamed:"EOC_Zombie_1")
        case 6:
            image = SKSpriteNode(imageNamed:"EOC_Zombie_2")
        case 7:
            image = SKSpriteNode(imageNamed:"EOC_Zombie_3")
        case 8:
            image = SKSpriteNode(imageNamed:"EOC_Zombie_4")
        default:
            print("Error:2 - Missing sprite")
        }
        if Double(currentTime)-lastTime > spawnTime || lastTime == 0
        {
            if zombies.count < 60
            {
                zombies.append(Zombie(health: Int(arc4random_uniform(50))+50, speed: Double(arc4random_uniform(10)+6)/*0*/ , image: image, damage: Int(arc4random_uniform(4)+7), target: 0))
                zombies[zombies.count-1].setup()
                guard let zombi:Zombie = zombies.last else
                {
                    print("Error:1 - Missing reference")
                    return
                }
                //zombi.setup()
                zombi.image.position = CGPoint(x: Double(CGFloat(arc4random_uniform(UInt32(width)))-0.5*width), y: Double(CGFloat(arc4random_uniform(UInt32(height)))-0.5*height))
                self.addChild(zombi.image)
                lastTime = Double(currentTime)
                if spawnTime > 0.755
                {
                    spawnTime-=0.005
                }
            }
        }
        if ball2.frame.minX != CGFloat(ball2X) || ball2.frame.minY != CGFloat(ballY)
        {
            if fired < arsenal[arsenalSelected].cartrigeSize
            {
                if lastTimeBullet == 0 || Double(currentTime) - lastTimeBullet > Double(1/arsenal[arsenalSelected].rof)
                {
                    if arsenalSelected == 1
                    {
                        player.rifle-=1
                    }
                    if arsenalSelected == 2
                    {
                        player.uzi-=1
                    }
                    if arsenalSelected == 3
                    {
                        for _ in 0...5
                        {
                            fire()
                        }
                        player.shotgun-=1
                    }
                    if arsenalSelected == 4
                    {
                        for _ in 0...7
                        {
                            fire()
                        }
                        player.blunderbuss-=1
                    }
                    fire()
                    fired += 1
                    lastTimeBullet = currentTime
                }
            }
        }
        ammo.text = "Ammo: \(arsenal[arsenalSelected].cartrigeSize - fired)"
        life.text = "Health: \(player.health)"
        var count = 0
        while count < bullets.count
        {
            if bullets[count].image.position.x > 0.5*width || bullets[count].image.position.x < -0.5*width || bullets[count].image.position.y > 0.5*height || bullets[count].image.position.y < -0.5*height
            {
                bullets[count].image.removeFromParent()
                bullets.remove(at: count)
            }
            count += 1
        }
        for bullet in bullets
        {
            bullet.update(delx:alldelx,dely:alldely)
        }
        for zombie in zombies
        {
            zombie.update(player: player.image, delx: alldelx, dely: alldely)
        }
        for kit in medkit
        {
            kit.update(delx: alldelx, dely: alldely)
        }
        for crate in ammunit
        {
            crate.update(delx: alldelx, dely: alldely)
        }
        for mat in mats
        {
            mat.update(delx: alldelx, dely: alldely)
        }
        world.update(delx: alldelx, dely: alldely)
        if player.health < 1
        {
            gameOver()
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        // 1
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // 2
        if ((firstBody.categoryBitMask & PhysicsCategory.Monster != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Projectile != 0)) {
            if let monster = firstBody.node as? SKSpriteNode, let
                projectile = secondBody.node as? SKSpriteNode {
                projectileDidCollideWithMonster(projectile: projectile, monster: monster)
            }
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Player != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Ammunition != 0)) {
            if let player = firstBody.node as? SKSpriteNode, let
                projectile = secondBody.node as? SKSpriteNode {
                playerDidCollideWithAmmo(target: projectile, plr: player)
            }
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Player != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Health != 0)) {
            if let player = firstBody.node as? SKSpriteNode, let
                projectile = secondBody.node as? SKSpriteNode {
                playerDidCollideWithHealth(target: projectile, plr: player)
            }
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Monster != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Monster != 0)) {
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Monster != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Player != 0)) {
            if let monster = firstBody.node as? SKSpriteNode, let
                player = secondBody.node as? SKSpriteNode {
                projectileDidCollideWithMonster2(target: player, monster: monster)
            }
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Wall != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Monster != 0)) {
            if let wall = firstBody.node as? SKSpriteNode, let
                monster = secondBody.node as? SKSpriteNode {
                monsterCollidedWithBound(target: wall, monster: monster)
            }
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Floor != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Monster != 0)) {
            if let floor = firstBody.node as? SKSpriteNode, let
                monster = secondBody.node as? SKSpriteNode {
                monsterCollidedWithBound(target: floor, monster: monster)
            }
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Wall != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Player != 0)) {
            if let wall = firstBody.node as? SKSpriteNode, let
                player = secondBody.node as? SKSpriteNode {
                playerCollidedWithWall(target: wall, monster: player)
            }
        }
    }
    
    func shake()
    {
        switch mySegcon.selectedSegmentIndex {
        case 1:
            if player.rifle > 0
            {
                fired = 0
                player.rifle-=1
            }
        case 2:
            if player.uzi > 0
            {
                fired = 0
                player.uzi-=1
            }
        case 3:
            if player.shotgun > 0
            {
                fired = 0
                player.shotgun-=1
            }
        case 4:
            if player.blunderbuss > 0
            {
                fired = 0
                player.blunderbuss-=1
            }
        default:
            fired = 0
        }
    }
    
    func projectileDidCollideWithMonster(projectile: SKSpriteNode, monster: SKSpriteNode) {
        projectile.removeFromParent()
        var count = 0
        var countB = 0
        while count < zombies.count
        {
            if zombies[count].image == monster
            {
                while countB < bullets.count
                {
                    if bullets[countB].image == projectile
                    {
                        zombies[count].health -= Int(bullets[countB].damage)
                        bullets.remove(at: countB)
                        if zombies[count].health < 1
                        {
                            zombies[count].image.removeFromParent()
                            zombies.remove(at: count)
                            killed += 1
                            score.text = "Score: \(killed*20)"
                        }
                    }
                    countB += 1
                }
            }
            count += 1
        }
    }
    
    func projectileDidCollideWithMonster2(target: SKSpriteNode, monster: SKSpriteNode) {
        //to do when player struct completed
        for zombie in zombies
        {
            if zombie.image == monster
            {
                player.health -= zombie.damage
            }
        }
    }
    
    func playerDidCollideWithHealth(target: SKSpriteNode, plr: SKSpriteNode) {
        player.health += 20
        for kit in 0...medkit.count-1
        {
            if medkit[kit].image == target
            {
                medkit[kit].image.removeFromParent()
                medkit.remove(at: kit)
            }
        }
    }
    
    func playerDidCollideWithAmmo(target: SKSpriteNode, plr: SKSpriteNode) {
        player.giveAmmo()
        for kit in 0...ammunit.count-1
        {
            if ammunit[kit].image == target
            {
                ammunit[kit].image.removeFromParent()
                ammunit.remove(at: kit)
            }
        }
    }
    
    func playerDidCollideWithMaterial(target: SKSpriteNode, plr: SKSpriteNode) {
        player.giveMaterial()
        for mat in 0...mats.count-1
        {
            if mats[mat].image == target
            {
                mats[mat].image.removeFromParent()
                mats.remove(at: mat)
            }
        }
    }
    
    func monsterCollidedWithBound(target: SKSpriteNode, monster: SKSpriteNode) {
        //to do when player struct completed
        print("zombie and wall/floor collision")
        for row in worldTiles
        {
            for tile in row
            {
                if tile.image == target
                {
                    for zombie in zombies
                    {
                        if zombie.image == monster
                        {
                            if zombie.image.position.x > tile.image.position.x || zombie.image.position.x < tile.image.position.x
                            {
                                alldelx = 0
                            }
                            if zombie.image.position.y > tile.image.position.y || zombie.image.position.y < tile.image.position.y
                            {
                                alldely = 0
                            }
                        }
                    }
                }
            }
        }
    }
    
    func playerCollidedWithWall(target: SKSpriteNode, monster: SKSpriteNode) {
        //to do when player struct completed
        print("Player & wall collision")
        for row in worldTiles
        {
            for tile in row
            {
                if tile.image == target
                {
                    if player.image.position.x > tile.image.position.x || player.image.position.x < tile.image.position.x
                    {
                        alldelx = 0
                    }
                    if player.image.position.y > tile.image.position.y || player.image.position.y < tile.image.position.y
                    {
                        alldely = 0
                    }
                }
            }
        }
    }
    
    func gameOver()
    {
        player.health = 100
        for _ in zombies
        {
            zombies.removeLast()
        }
        for _ in bullets
        {
            bullets.removeLast()
        }
        worldsave()
        lastTime = 0
        lastTimeBullet = 0
        self.removeAllChildren()
        ball1.removeFromSuperview()
        ball2.removeFromSuperview()
        mySegcon.removeFromSuperview()
        lastTime = 1.5
        self.view?.presentScene(GameOverScene(size: self.size, score: self.killed, scoreList: self.highScoresS, nameList: self.highScoresN))
    }
    
    func playerMove(ball: CGRect, base: CGPoint)
    {
        var delta = hypotf(Float(ball.midX - base.x), Float(ball.midY - base.y))
        if delta > 30
        {
            delta = 30
        }
        else if delta < -30
        {
            delta = -30
        }
        let angle = atan2(((base.y)-(ball.midY)), ((ball.midX)-(base.x)))
        let deltaX = 0.5*CGFloat(delta)*cos(angle)
        alldelx = deltaX
        let deltaY = 0.5*CGFloat(delta)*sin(angle)
        alldely = deltaY
        let move = SKAction.move(to: CGPoint(x: player.image.position.x + deltaX, y: player.image.position.y + deltaY), duration: 0.2)
        move.timingMode = .linear
        world.image.run(move)
    }
    
    func playerAngle(ball: CGRect, base: CGPoint)
    {
        if modify
        {
            let angle = atan2(((base.x)-(ball.midX)), ((base.y)-(ball.midY)))
            player.image.zRotation = angle
        }
    }
    
    func fire()
    {
        bullets.append(bullet(angle: ((drand48()/5)-0.1)+atan2((Double(CGFloat(ballY+25)-ball2.frame.midY)), (Double(CGFloat(ball2X+25)-ball2.frame.midX))), speed: 80, image: SKSpriteNode(imageNamed: "Bullet"), damage: arsenal[arsenalSelected].damage))
        guard let bullet:bullet = bullets.last else
        {
            print("Error:0 - Missing reference")
            return
        }
        bullet.setup()
        bullet.image.position = player.image.position
        self.addChild(bullet.image)
    }
    
    func worldsave()
    {
        UserDefaults.standard.set(world.worldtiles, forKey: "World")
    }
}

/*extension GameScene : ServiceManagerDelegate
{
    func connectedDevicesChanged(manager: ServiceManager, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            NSLog("%@", "Connections: \(connectedDevices)")
        }
    }
    func dataChanged(manager: ServiceManager, data: Data) {
        OperationQueue.main.addOperation {
            
        }
    }
}*/
