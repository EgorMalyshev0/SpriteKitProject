//
//  PauseViewController.swift
//  #16
//
//  Created by Egor Malyshev on 29.03.2021.
//

import UIKit

protocol PauseVCDelegate {
    func hidePauseViewController()
}

class PauseViewController: UIViewController {
    
    var delegate: PauseVCDelegate?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        delegate?.hidePauseViewController()
    }
    
    @IBAction func exitButtonTapped(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(identifier: "StartViewController") {
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
}
