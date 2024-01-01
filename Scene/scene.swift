//
//  scene.swift
//  VisionWeather
//
//  Created by JINSEN WU on 1/1/24.
//

import Foundation
import SpriteKit

class RainFall: SKScene {
    
    var frameSize: CGSize!
    
    override init(size: CGSize) {
        super.init(size: size)
        self.scaleMode = .resizeFill
        self.backgroundColor = .clear
        self.anchorPoint = CGPoint(x: 0.5, y: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sceneDidLoad() {
        
        scaleMode = .resizeFill
        
        backgroundColor = .clear
        
        anchorPoint = CGPoint(x: 0.5, y: 1)
        
        // creating node and adding to scene
        let node = SKEmitterNode(fileNamed: "RainFall.sks")!
        node.particlePositionRange.dx = self.size.width * 1.5
        addChild(node)
        
    }
}


class SnowFall: SKScene {
    
    var frameSize: CGSize!
    
    override init(size: CGSize) {
        super.init(size: size)
        self.scaleMode = .resizeFill
        self.backgroundColor = .clear
        self.anchorPoint = CGPoint(x: 0.5, y: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sceneDidLoad() {
        
//        size = view.bounds.size
        
        scaleMode = .resizeFill
        
        backgroundColor = .clear
        
        anchorPoint = CGPoint(x: 0.5, y: 1)
        
        // creating node and adding to scene
        let node = SKEmitterNode(fileNamed: "SnowFall.sks")!
        node.particlePositionRange.dx = self.size.width * 1.5
        addChild(node)
        
    }
}

class RainFallLanding: SKScene {

    var frameSize: CGSize!

    override init(size: CGSize) {
        super.init(size: size)
        self.scaleMode = .resizeFill
        self.backgroundColor = .clear
        self.anchorPoint = CGPoint(x: 0.5, y: 1)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func sceneDidLoad() {

        scaleMode = .resizeFill

        backgroundColor = .clear


        anchorPoint = CGPoint(x: 0.5, y: 1)

        // creating node and adding to scene
        let node = SKEmitterNode(fileNamed: "RainFallLanding.sks")!
        node.particlePositionRange.dx = self.size.width * 1.5
        addChild(node)

    }
}


class Star: SKScene {
    
    var frameSize: CGSize!
    
    override init(size: CGSize) {
        super.init(size: size)
        self.scaleMode = .resizeFill
        self.backgroundColor = .clear
        self.anchorPoint = CGPoint(x: 0.5, y: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sceneDidLoad() {
        
        scaleMode = .resizeFill
        
        backgroundColor = .clear
        
        anchorPoint = CGPoint(x: 0.5, y: 1)
        
        // creating node and adding to scene
        let node = SKEmitterNode(fileNamed: "Star.sks")!
        node.particlePositionRange.dx = self.size.width * 1.5
        node.particlePositionRange.dy = self.size.height * 0.6
        addChild(node)
        
    }
}


class Cloud: SKScene {
    
    var frameSize: CGSize!
    
    override init(size: CGSize) {
        super.init(size: size)
        self.scaleMode = .resizeFill
        self.backgroundColor = .clear
        self.anchorPoint = CGPoint(x: 0.5, y: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sceneDidLoad() {
        
        scaleMode = .resizeFill
        
        backgroundColor = .clear
        
        anchorPoint = CGPoint(x: 0.5, y: 1)
        
        // creating node and adding to scene
        let node = SKEmitterNode(fileNamed: "Cloud.sks")!
        node.particlePositionRange.dx = self.size.width * 1.5
        node.particlePositionRange.dy = self.size.height * 0.6
        addChild(node)
        
    }
}
