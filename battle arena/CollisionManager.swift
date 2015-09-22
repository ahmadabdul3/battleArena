//
//  CollisionHandler.swift
//  battle arena
//
//  Created by Abdul on 9/19/15.
//  Copyright (c) 2015 3bdugames. All rights reserved.
//

import Foundation

class CollisionManager {
    
    //var collisionsMap = [1 : CharacterAbilityCollision()]
    
    func getCollisionHanlder(addedCollisionBitMask : UInt32) -> ICollisionHandler {
        var collisionMap : [UInt32 : ICollisionHandler] = [4 : CharacterAbilityCollision()]
        return collisionMap[addedCollisionBitMask]!
    }
}