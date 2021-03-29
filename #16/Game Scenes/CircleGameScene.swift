//
//  GameScene.swift
//  #16
//
//  Created by Egor Malyshev on 22.03.2021.
//

import SpriteKit

class CircleGameScene: SKScene {
    
    let initialRadius: CGFloat = 25.0
        
    var player = SKShapeNode()
    var enemy = SKShapeNode()
    let scoreLabel = SKLabelNode(text: "")
    
    var score = 0.0
    var currentEnemyincrease: CGFloat = -1.0
    
    var record: Double {
        get {
            let value = UserDefaults.standard.double(forKey: UserDefaultsRecordKeys.circle.rawValue)
            return value
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultsRecordKeys.circle.rawValue)
        }
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)

        physicsWorld.contactDelegate = self
        
        backgroundColor = .black
        addPlayerNode()
        player.position = CGPoint(x: view.frame.midX, y: view.frame.midY)
        
        enemy = SKShapeNode(circleOfRadius: initialRadius)
        enemy.fillColor = .red
        enemy.strokeColor = .red
        setEnemyPhysicsBodyRadius(initialRadius)
        enemy.position = CGPoint(x: view.frame.midX, y: enemy.frame.height / 2)

        scoreLabel.fontSize = 35
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: view.frame.midX, y: view.frame.height - 100)
        
        addChild(player)
        addChild(enemy)
        addChild(scoreLabel)
        
        addActions()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if let view = view, !view.isPaused, let location = touches.first?.location(in: self) {
            move(node: player, to: location, speed: 150)
        }
    }
    
    func addPlayerNode(){
        player = SKShapeNode(circleOfRadius: initialRadius)
        player.fillColor = .green
        player.strokeColor = .green
        player.physicsBody = SKPhysicsBody(circleOfRadius: initialRadius)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = PhysicsBodyCategory.player
        player.physicsBody?.contactTestBitMask = PhysicsBodyCategory.enemy
        player.physicsBody?.collisionBitMask = PhysicsBodyCategory.none
    }
    
    func addActions(){
        let plusOneSecond = SKAction.run {
            self.move(node: self.enemy, to: self.player.position, speed: 120)
            self.score = self.score + 1 + Double(self.currentEnemyincrease)
            self.scoreLabel.text = "\(Int(self.score))"
        }
        let plusOneSecondDelay = SKAction.wait(forDuration: 1)
        let sequence = SKAction.sequence([plusOneSecond, plusOneSecondDelay])
        run(SKAction.repeatForever(sequence))
        
        let plusFiveSecond = SKAction.run {
            self.currentEnemyincrease += 1
            let newScale = (self.initialRadius + self.currentEnemyincrease) / self.initialRadius
            self.enemy.setScale(CGFloat(newScale))
            self.setEnemyPhysicsBodyRadius(CGFloat(self.initialRadius + self.currentEnemyincrease))
        }
        let plusFiveSecondDelay = SKAction.wait(forDuration: 5)
        let secondSequence = SKAction.sequence([plusFiveSecond, plusFiveSecondDelay])
        run(SKAction.repeatForever(secondSequence))
    }
    
    func loseAction() {
        if record < score {
            record = score
        }
        let scene = GameOverScene(size: size, score: score, sceneType: .circle)
        let transition = SKTransition.flipHorizontal(withDuration: 0.5)
        view?.presentScene(scene, transition: transition)
    }
    
    func move(node: SKNode, to toPoint: CGPoint, speed: CGFloat){
        let x = node.position.x
        let y = node.position.y
        
        let distance = sqrt((x - toPoint.x) * (x - toPoint.x) + (y - toPoint.y) * (y - toPoint.y))
        let duration = TimeInterval(distance / speed)
        let move = SKAction.move(to: toPoint, duration: duration)
        node.run(move)
    }
    
    func setEnemyPhysicsBodyRadius(_ radius: CGFloat) {
        let physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody.affectedByGravity = false
        physicsBody.categoryBitMask = PhysicsBodyCategory.enemy
        physicsBody.contactTestBitMask = PhysicsBodyCategory.player
        physicsBody.collisionBitMask = PhysicsBodyCategory.none
        enemy.physicsBody = physicsBody
    }
}

// MARK: SKPhysicsContactDelegate
extension CircleGameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == PhysicsBodyCategory.player &&
            contact.bodyB.categoryBitMask == PhysicsBodyCategory.enemy) ||
            (contact.bodyA.categoryBitMask == PhysicsBodyCategory.enemy &&
            contact.bodyB.categoryBitMask == PhysicsBodyCategory.player) {
            loseAction()
        }
    }
}
