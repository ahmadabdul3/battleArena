//
//  SpritePhysicsSetUpHelper.swift
//  battle arena
//
//  Created by Abdul on 8/27/15.
//  Copyright (c) 2015 3bdugames. All rights reserved.
//

import Foundation
import SpriteKit

class SpritePhysicsSetUpHelper {
    
    func basicSetUpPhysics(node: SKNode, pBody: SKPhysicsBody, dynamic: Bool, categoryBitMask: UInt32, contactTestBitMask: UInt32, collisionBitMask: UInt32, preciseCollision: Bool) {
        node.physicsBody = pBody
        node.physicsBody?.dynamic = dynamic
        node.physicsBody?.categoryBitMask = categoryBitMask
        node.physicsBody?.contactTestBitMask = contactTestBitMask
        node.physicsBody?.collisionBitMask = collisionBitMask
        node.physicsBody?.usesPreciseCollisionDetection = preciseCollision
    }
    
}
