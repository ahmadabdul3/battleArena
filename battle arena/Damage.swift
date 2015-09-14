//
//  Damage.swift
//  battle arena
//
//  Created by Abdul on 8/28/15.
//  Copyright (c) 2015 3bdugames. All rights reserved.
//

import Foundation
import SpriteKit

class Damage {
    
    var initPhys: CGFloat = 0
    var xtndPhys: CGFloat = 0
    var initSpec: CGFloat = 0
    var xtndSpec: CGFloat = 0
    
    init() {
        
    }
    init(initPhys: CGFloat, xtndPhys: CGFloat, initSpec: CGFloat, xtndSpec: CGFloat) {
        self.initPhys = initPhys
        self.xtndPhys = xtndPhys
        self.initSpec = initSpec
        self.xtndSpec = xtndSpec
    }
    
    func getInitPhys() -> CGFloat {
        return initPhys
    }
    func getXtndPhys() -> CGFloat {
        return xtndPhys
    }
    func getInitSpec() -> CGFloat {
        return initSpec
    }
    func getXtndSpec() -> CGFloat {
        return xtndSpec
    }
}
