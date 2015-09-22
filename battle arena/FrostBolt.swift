//
//  FrostBolt.swift
//  battle arena
//
//  Created by Abdul on 9/18/15.
//  Copyright (c) 2015 3bdugames. All rights reserved.
//

import Foundation
import SpriteKit

class FrostBolt : BaseAbility {
    
    override init() {
        super.init()
        projectileHead = SKSpriteNode(imageNamed: "spark.png")
        setSize(projectileHead)
        SpritePhysicsSetUpHelper().basicSetUpPhysics(self, pBody: SKPhysicsBody(circleOfRadius: convertToSprite(self.projectileHead).size.width / 2), dynamic: true, categoryBitMask: PhysicsCategory.Projectile, contactTestBitMask: PhysicsCategory.All, collisionBitMask: PhysicsCategory.Barrier, preciseCollision: true)
        texture = SKEmitterNode(fileNamed: "FrostBolt.sks")
        addChild(projectileHead)
        addChild(texture)
        effect = FreezeEffect()
    }
    convenience init(casterName: String) {
        self.init()
        self.casterName = casterName
    }
    func convertToSprite(node : SKNode) -> SKSpriteNode {
        return node as! SKSpriteNode
    }
    func setSize(node : SKNode) {
        var snode = node as! SKSpriteNode
        snode.size = CGSize(width: snode.size.width / 2, height: snode.size.height / 2)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}