//
//  StartViewController.swift
//  #16
//
//  Created by Egor Malyshev on 23.03.2021.
//

import SpriteKit

class StartViewController: UIViewController {

    @IBOutlet weak var skView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = BearScene(size: skView.bounds.size)
        scene.scaleMode = .resizeFill
        
        skView.ignoresSiblingOrder = true
        skView.presentScene(scene)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    @IBAction func playCircleGame(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "gameViewController") as! GameViewController
        vc.sceneType = .circle
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    @IBAction func playSquareGame(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "gameViewController") as! GameViewController
        vc.sceneType = .square
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}
