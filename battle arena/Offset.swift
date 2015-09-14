//
//  Offset.swift
//  battle arena
//
//  Created by Abdul on 8/29/15.
//  Copyright (c) 2015 3bdugames. All rights reserved.
//

import Foundation
import SpriteKit

class Offset {
    var offsetX: CGFloat = 0
    var offsetY: CGFloat = 0
    
    init(offsetX: CGFloat, offsetY: CGFloat) {
        self.offsetX = offsetX
        self.offsetY = offsetY
    }
    func getOffsetX() -> CGFloat {
        return offsetX
    }
    func getOffsetY() -> CGFloat {
        return offsetY
    }
    func setOffsetX(offset: CGFloat) {
        offsetX = offset
    }
    func setOffsetY(offset: CGFloat) {
        offsetY = offset
    }
}