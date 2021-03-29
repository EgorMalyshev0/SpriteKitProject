//
//  SquareGameScene.swift
//  #16
//
//  Created by Egor Malyshev on 23.03.2021.
//

import SpriteKit

class SquareGameScene: SKScene {
    
    let player = SKSpriteNode(color: .gray, size: CGSize(width: 30, height: 30))
    var ground = SKSpriteNode()
    let scoreLabel = SKLabelNode(text: "")
        
    var isInAir = false
    var currentSpeed: CGFloat = 200
    var score = 0.0
    
    var coefficient: Double {
        Double(currentSpeed) / 200.0
    }
    
    var record: Double {
        get {
            let value = UserDefaults.standard.double(forKey: UserDefaultsRecordKeys.square.rawValue)
            return value
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultsRecordKeys.square.rawValue)
        }
    }

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -5)
        backgroundColor = .white
        
        scoreLabel.fontSize = 35
        scoreLabel.fontColor = .gray
        scoreLabel.position = CGPoint(x: view.frame.midX, y: view.frame.height - 100)
        
        player.position = CGPoint(x: player.size.width, y: view.frame.midY)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = true
        player.physicsBody?.restitution = 0.0
        player.physicsBody?.categoryBitMask = PhysicsBodyCategory.player
        player.physicsBody?.contactTestBitMask = PhysicsBodyCategory.all
        
        ground = SKSpriteNode(color: .black, size: CGSize(width: view.frame.width, height: 2))
        ground.position = CGPoint(x: view.frame.midX, y: player.frame.minY - 1)
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.restitution = 0.0
        ground.physicsBody?.categoryBitMask = PhysicsBodyCategory.ground
        ground.physicsBody?.contactTestBitMask = PhysicsBodyCategory.player
        
        addChild(player)
        addChild(ground)
        addChild(scoreLabel)
        
        let obstacleGeneration = SKAction.run {
            let obstacle = self.createObstacle(speed: self.currentSpeed)
            self.addChild(obstacle)
        }
        let obstacleGenerationDelay = SKAction.wait(forDuration: 1 / TimeInterval(coefficient), withRange: 0.5 * TimeInterval(coefficient))
        let sequence = SKAction.sequence([obstacleGeneration, obstacleGenerationDelay])
        run(SKAction.repeatForever(sequence))
        
        let scoreIncreasing = SKAction.run {
            self.currentSpeed += 1
            self.score += self.coefficient / 10
            self.scoreLabel.text = "\(Int(self.score))"
        }
        let scoreIncreasingDelay = SKAction.wait(forDuration: 0.1)
        let secondSequence = SKAction.sequence([scoreIncreasing, scoreIncreasingDelay])
        run(SKAction.repeatForever(secondSequence))
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard !isInAir else { return }
        move(node: player, to: CGPoint(x: player.size.width, y: player.position.y + player.size.height * 3), speed: 400)
    }
    
    func move(node: SKNode, to toPoint: CGPoint, speed: CGFloat, removeWhenDone: Bool = false){
        let x = node.position.x
        let y = node.position.y
        
        let distance = sqrt((x - toPoint.x) * (x - toPoint.x) + (y - toPoint.y) * (y - toPoint.y))
        let duration = TimeInterval(distance / speed)
        var actions: [SKAction] = []
        actions.append(SKAction.move(to: toPoint, duration: duration))
        if removeWhenDone {
            actions.append(SKAction.removeFromParent())
        }
        node.run(SKAction.sequence(actions))
    }
    
    func createObstacle(speed: CGFloat) -> SKNode {
        guard let skView = self.view else { return SKNode() }
        let enemy = SKSpriteNode(color: .black, size: CGSize(width: 15, height: 15))
        enemy.position = CGPoint(x: skView.frame.width + enemy.frame.width / 2, y: ground.frame.maxY + enemy.size.height / 2)
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.categoryBitMask = PhysicsBodyCategory.enemy
        enemy.physicsBody?.contactTestBitMask = PhysicsBodyCategory.all
        move(node: enemy, to: CGPoint(x: -enemy.size.width, y: enemy.position.y), speed: speed, removeWhenDone: true)
        return enemy
    }
    
    func loseAction() {
        if record < score {
            record = score
        }
        let scene = GameOverScene(size: size, score: score, sceneType: .square)
        let transition = SKTransition.flipHorizontal(withDuration: 0.5)
        view?.presentScene(scene, transition: transition)
    }
}

extension SquareGameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == PhysicsBodyCategory.player &&
            contact.bodyB.categoryBitMask == PhysicsBodyCategory.ground) ||
            (contact.bodyA.categoryBitMask == PhysicsBodyCategory.ground &&
            contact.bodyB.categoryBitMask == PhysicsBodyCategory.player) {
            isInAir = false
        }
        if (contact.bodyA.categoryBitMask == PhysicsBodyCategory.player &&
                    contact.bodyB.categoryBitMask == PhysicsBodyCategory.enemy) ||
                    (contact.bodyA.categoryBitMask == PhysicsBodyCategory.enemy &&
                    contact.bodyB.categoryBitMask == PhysicsBodyCategory.player) {
            loseAction()
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == PhysicsBodyCategory.player &&
            contact.bodyB.categoryBitMask == PhysicsBodyCategory.ground) ||
            (contact.bodyA.categoryBitMask == PhysicsBodyCategory.ground &&
            contact.bodyB.categoryBitMask == PhysicsBodyCategory.player) {
            isInAir = true
        }
    }
}

