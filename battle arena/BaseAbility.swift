//
//  BaseAbility.swift
//  battle arena
//
//  Created by Abdul on 8/28/15.
//  Copyright (c) 2015 3bdugames. All rights reserved.
//

import Foundation
import SpriteKit

class BaseAbility:SKNode {
    
    var texture = SKNode()
    var effect = BaseEffect()
    
    func performAction() {
        
    }
    func getEffect() -> BaseEffect {
        return effect
    }
    
    
    
}