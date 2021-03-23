//
//  GameScene.swift
//  #16
//
//  Created by Egor Malyshev on 22.03.2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let initialRadius: CGFloat = 25.0
        
    var player = SKShapeNode()
    var enemy = SKShapeNode()
    let scoreLabel = SKLabelNode(text: "")
    
    var moovingTimer: Timer?
    var resizingTimer: Timer?
    
    var score = 0
    var currentEnemyincrease: CGFloat = 0.0
    
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
        
        moovingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(plusOneSecond), userInfo: nil, repeats: true)
        resizingTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(plusFiveSeconds), userInfo: nil, repeats: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if let location = touches.first?.location(in: self) {
            move(node: player, to: location, speed: 150)
        }
    }
    
    func addPlayerNode(){
        player = SKShapeNode(circleOfRadius: initialRadius)
        player.fillColor = .green
        player.strokeColor = .green
        player.physicsBody = SKPhysicsBody(circleOfRadius: initialRadius)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = PhysicsBodyCategory.player.rawValue
        player.physicsBody?.contactTestBitMask = PhysicsBodyCategory.enemy.rawValue
        player.physicsBody?.collisionBitMask = PhysicsBodyCategory.none.rawValue
    }
    
    func loseAction() {
        moovingTimer?.invalidate()
        resizingTimer?.invalidate()
        let scene = GameOverScene(size: size, score: score)
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
        physicsBody.categoryBitMask = PhysicsBodyCategory.enemy.rawValue
        physicsBody.contactTestBitMask = PhysicsBodyCategory.player.rawValue
        physicsBody.collisionBitMask = PhysicsBodyCategory.none.rawValue
        enemy.physicsBody = physicsBody
    }
    
    @objc func plusOneSecond() {
        move(node: enemy, to: player.position, speed: 120)
        score = score + 1 + Int(currentEnemyincrease)
        scoreLabel.text = "\(score)"
    }
    
    @objc func plusFiveSeconds() {
        currentEnemyincrease += 1
        let newScale = (initialRadius + currentEnemyincrease) / initialRadius
        enemy.setScale(CGFloat(newScale))
        setEnemyPhysicsBodyRadius(CGFloat(initialRadius + currentEnemyincrease))
        print(newScale)
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == PhysicsBodyCategory.player.rawValue &&
            contact.bodyB.categoryBitMask == PhysicsBodyCategory.enemy.rawValue) ||
            (contact.bodyA.categoryBitMask == PhysicsBodyCategory.enemy.rawValue &&
            contact.bodyB.categoryBitMask == PhysicsBodyCategory.player.rawValue) {
            loseAction()
        }
    }
}

enum PhysicsBodyCategory: UInt32{
    case none = 0
    case player = 10
    case enemy = 20
}
