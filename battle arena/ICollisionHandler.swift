//
//  IHandleCollision.swift
//  battle arena
//
//  Created by Abdul on 9/19/15.
//  Copyright (c) 2015 3bdugames. All rights reserved.
//

import Foundation
import SpriteKit

protocol ICollisionHandler {
    func handleCollision(character : SKNode, ability : SKNode)
}