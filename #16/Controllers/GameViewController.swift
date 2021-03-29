//
//  GameViewController.swift
//  #16
//
//  Created by Egor Malyshev on 22.03.2021.
//

import SpriteKit

class GameViewController: UIViewController {
    
    var sceneType: SceneType?
    var pauseViewController: PauseViewController?
        
    @IBOutlet weak var pauseButton: UIButton!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let skView = view as? SKView else { return }
        var scene = SKScene()
        switch sceneType {
        case .circle:
            scene = CircleGameScene(size: skView.bounds.size)
        case .square:
            scene = SquareGameScene(size: skView.bounds.size)
        default:
            return
        }
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        
        pauseViewController = storyboard?.instantiateViewController(identifier: "PauseViewController") as? PauseViewController
        pauseViewController?.delegate = self
    }
    
    @IBAction func pauseButtonTapped(_ sender: Any) {
        showPauseViewController()
    }
    
    func showPauseViewController() {
        guard let skView = view as? SKView, let vc = pauseViewController else { return }
        skView.isPaused = true
            addChild(vc)
            view.addSubview(vc.view)
            vc.view.frame = view.bounds
    }
}

extension GameViewController: PauseVCDelegate {
    func hidePauseViewController() {
        pauseViewController?.willMove(toParent: nil)
        pauseViewController?.removeFromParent()
        pauseViewController?.view.removeFromSuperview()
        guard let skView = view as? SKView else { return }
        skView.isPaused = false
    }
}
