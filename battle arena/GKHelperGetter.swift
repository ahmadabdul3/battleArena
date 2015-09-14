//
//  GKHelperGetter.swift
//  battle arena
//
//  Created by Abdul on 9/7/15.
//  Copyright (c) 2015 3bdugames. All rights reserved.
//

import Foundation

class GKHelperGetter {
    static var gameKitHelper:GameKitHelper?
    
    static func getGameKitHelperInstance() -> GameKitHelper {
        if let gkhelper = gameKitHelper {
            return gkhelper
        }
        gameKitHelper = GameKitHelper()
        return gameKitHelper!
    }
    
}