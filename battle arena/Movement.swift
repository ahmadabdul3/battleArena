//
//  Movement.swift
//  battle arena
//
//  Created by Abdul on 8/28/15.
//  Copyright (c) 2015 3bdugames. All rights reserved.
//

import Foundation
import SpriteKit

class Movement {
    var speed:CGFloat
    
    init() {
        speed = 1
    }
    init(speed:CGFloat) {
        self.speed = speed
    }
    
    func getSpeed() -> CGFloat {
        return speed
    }
    
}