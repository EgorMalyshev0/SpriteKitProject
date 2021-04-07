//
//  BearScene.swift
//  #16
//
//  Created by Egor Malyshev on 02.04.2021.
//

import SpriteKit

class BearScene: SKScene {
    private var bear = SKSpriteNode()
    private var bearWalkingFrames: [SKTexture] = []
    
    override func didMove(to view: SKView) {
        backgroundColor = .blue
        
        buildBear()
        animateBear()
    }
    
    func buildBear() {
        let bearAnimatedAtlas = SKTextureAtlas(named: "bears")
        var walkFrames: [SKTexture] = []
        
        let numImages = bearAnimatedAtlas.textureNames.count
        for i in 1...numImages {
            let bearTextureName = "bear\(i)"
            walkFrames.append(bearAnimatedAtlas.textureNamed(bearTextureName))
        }
        bearWalkingFrames = walkFrames
        
        let firstFrameTexture = bearWalkingFrames[0]
        bear = SKSpriteNode(texture: firstFrameTexture)
        bear.position = CGPoint(x: frame.midX, y: frame.midY)

        bear.scale(to: frame.size)
        addChild(bear)
    }
    
    func animateBear(){
        bear.run(SKAction.repeatForever(
                    SKAction.animate(with: bearWalkingFrames,
                                     timePerFrame: 0.1,
                                     resize: false,
                                     restore: true)),
                 withKey:"walkingInPlaceBear")
    }
}
