//
//  BaseEffect.swift
//  battle arena
//
//  Created by Abdul on 8/28/15.
//  Copyright (c) 2015 3bdugames. All rights reserved.
//

import Foundation
import SpriteKit

class BaseEffect {
    
    var movement = Movement()
    var damage = Damage(initPhys: 0, xtndPhys: 0, initSpec: 0, xtndSpec: 0)
    var image = SKSpriteNode()
    var duration:CGFloat = 0
    var frequency:CGFloat = 0
    
    init() {
        
    }
    init(movement: Movement, damage: Damage, duration: CGFloat, frequency: CGFloat) {
        self.movement = movement
        self.damage = damage
        self.duration = duration
        self.frequency = frequency
    }
    
    func getSpeed() -> CGFloat {
        return movement.getSpeed()
    }
    func getDuration() -> CGFloat {
        return duration
    }
    func getFrequency() -> CGFloat {
        return frequency
    }
}