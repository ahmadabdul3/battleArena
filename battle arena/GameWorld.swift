//
//  GameWorld.swift
//  battle arena
//
//  Created by Abdul on 8/27/15.
//  Copyright (c) 2015 3bdugames. All rights reserved.
//

import Foundation
import SpriteKit
import Darwin

class GameWorld: SKSpriteNode {
    
    var physicsWorld = SKPhysicsWorld()
    var player1 = BaseCharacter()
    var player2 = BaseCharacter()
    let baseCharArray = NSMutableArray()
    
    init() {
        super.init(texture: nil, color: nil, size: CGSize(width: 1000, height: 1000))
        self.userInteractionEnabled = true
    }
    init(rectOfSize: CGSize) {
        super.init(texture: nil, color: UIColor.grayColor(), size: rectOfSize)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSelfScale(x: CGFloat, y: CGFloat) {
        self.xScale = x
        self.yScale = y
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
    }
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        
    }
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            if player1.hasAbilitySelected() {
                addChildNode(player1.getSelectedAbility(), location: location, zPosition: self.zPosition + 5)
            }
            
        }
    }
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        
    }
    
    
    func addChildNode(node: SKNode,location: CGPoint, zPosition: CGFloat) {
        node.zPosition = zPosition
        node.position = location
        self.addChild(node)
    }
    
    func update() {
        updateBaseChar(player1)
        
    }
    func updateBaseChar(char: BaseCharacter) {
        char.update()
    }
    
    
}
