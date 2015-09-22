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
    var duration:NSTimeInterval = 0
    var frequency:NSTimeInterval = 0
    
    init() {
        
    }
    init(movement: Movement, damage: Damage, duration: NSTimeInterval, frequency: NSTimeInterval) {
        self.movement = movement
        self.damage = damage
        self.duration = duration
        self.frequency = frequency
    }
    
    func getSpeed() -> CGFloat {
        return movement.getSpeed()
    }
    func getDuration() -> NSTimeInterval {
        return duration
    }
    func getFrequency() -> NSTimeInterval {
        return frequency
    }
    func getCount() -> Int {
        return Int(duration / frequency)
    }
}