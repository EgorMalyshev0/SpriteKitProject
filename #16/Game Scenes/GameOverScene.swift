//
//  GameOverScene.swift
//  #16
//
//  Created by Egor Malyshev on 22.03.2021.
//

import SpriteKit

class GameOverScene: SKScene {
    
    let label = SKLabelNode(text: "Game Over!")
    var scoreLabel: SKLabelNode!
    var recordLabel: SKLabelNode!
    var score = 0.0
    var sceneType: SceneType!
        
    init(size: CGSize, score: Double, sceneType: SceneType) {
        super.init(size: size)
        self.score = score
        self.sceneType = sceneType
        scoreLabel = SKLabelNode(text: "Your score: \(Int(score))")
        switch sceneType {
        case .circle:
            let record = UserDefaults.standard.double(forKey: UserDefaultsRecordKeys.circle.rawValue)
            recordLabel = SKLabelNode(text: "Your record: \(Int(record))")
        case .square:
            let record = UserDefaults.standard.double(forKey: UserDefaultsRecordKeys.square.rawValue)
            recordLabel = SKLabelNode(text: "Your record: \(Int(record))")
        default:
            return
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)

        label.position = CGPoint(x: view.frame.midX, y: view.frame.midY)
        scoreLabel.position = CGPoint(x: view.frame.midX, y: label.position.y - label.frame.height / 2 - 30)
        scoreLabel.fontSize = 20
        recordLabel.position = CGPoint(x: view.frame.midX, y: scoreLabel.position.y - scoreLabel.frame.height / 2 - 30)
        recordLabel.fontSize = 20
        
        addChild(label)
        addChild(scoreLabel)
        addChild(recordLabel)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        guard let skView = view else { return }
        var scene = SKScene()
        switch sceneType {
        case .circle:
            scene = CircleGameScene(size: skView.bounds.size)
        case .square:
            scene = SquareGameScene(size: skView.bounds.size)
        default:
            return
        }
        let transition = SKTransition.flipHorizontal(withDuration: 0.5)
        view?.presentScene(scene, transition: transition)
    }
}
