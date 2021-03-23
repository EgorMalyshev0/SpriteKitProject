//
//  GameOverScene.swift
//  #16
//
//  Created by Egor Malyshev on 22.03.2021.
//

import SpriteKit
import GameplayKit

class GameOverScene: SKScene {
    
    let label = SKLabelNode(text: "Game Over!")
    var scoreLabel: SKLabelNode!
    var score = 0
    
    init(size: CGSize, score: Int) {
        super.init(size: size)
        self.score = score
        scoreLabel = SKLabelNode(text: "Your score: \(score)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)

        label.position = CGPoint(x: view.frame.midX, y: view.frame.midY)
        scoreLabel.position = CGPoint(x: view.frame.midX, y: label.position.y - label.frame.height / 2 - 30)
        scoreLabel.fontSize = 20
        
        addChild(label)
        addChild(scoreLabel)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        let scene = GameScene(size: size)
        let transition = SKTransition.flipHorizontal(withDuration: 0.5)
        view?.presentScene(scene, transition: transition)
    }

}
