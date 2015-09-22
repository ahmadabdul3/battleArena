//
//  FreezeEffect.swift
//  battle arena
//
//  Created by Abdul on 9/19/15.
//  Copyright (c) 2015 3bdugames. All rights reserved.
//

import Foundation
import SpriteKit

class FreezeEffect : BaseEffect {
    
    override init() {
        super.init()
        movement = Movement(speed: 0)
        damage = Damage(initPhys: 0, xtndPhys: 0, initSpec: 5, xtndSpec: 0)
        duration = 2
        frequency = 0
    }
    
}

