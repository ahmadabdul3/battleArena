//
//  GameScene.swift
//  battle arena
//
//  Created by Abdul on 8/27/15.
//  Copyright (c) 2015 3bdugames. All rights reserved.
//

import SpriteKit
import Darwin
import GameKit


struct PhysicsCategory {
    static let None         : UInt32 = 0
    static let All          : UInt32 = UInt32.max
    static let Character    : UInt32 = 1
    static let Monster      : UInt32 = 2
    static let Projectile   : UInt32 = 3
    static let Barrier      : UInt32 = 4
}

class GameScene: SKScene, MultiplayerNetworkingProtocol {
    
    var gameWorld = GameWorld()
    var movementAnalog = MovementAnalog()
    var player1 = BaseCharacter()
    var player2 = BaseCharacter()
    var _currentPlayerIndex = 0
    var networkingEngine = MultiplayerNetworking()
    var localPlayerLastPositionSent = false
    
    override func didMoveToView(view: SKView) {
        self.anchorPoint = CGPointMake(0.5, 0.5)
        givePlayersNames()
        gameWorld.addChild(player1)
        gameWorld.localPlayer = self.player1
        gameWorld.addChild(player2)
        gameWorld.remotePlayer = self.player2
        addChild(gameWorld)
        addChild(movementAnalog)
        updateBorderLayerPosition()
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = gameWorld
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock({self.sendLocalPlayerPosition(true); return ()}),
                SKAction.waitForDuration(0.1)
            ])
        ))
    }
    
    override func update(currentTime: CFTimeInterval) {
        gameWorld.update()
        moveLocalPlayer()
    }
    func setNetworkingEngine(engine: MultiplayerNetworking) {
        self.networkingEngine = engine
        gameWorld.networkingEngine = engine
    }
    func givePlayersNames() {
        player1.name = "player1"
        player2.name = "player2"
    }
    
    func moveLocalPlayer() {
        if movementAnalog.analogIsEngaged() {
            localPlayerLastPositionSent = false
            var localPlayer = getLocalPlayer()
            var movementAmount = movementAnalog.getMovementAmount()
            localPlayer.movePosition(movementAmount)
        } else {
            if !localPlayerLastPositionSent {
                sendLocalPlayerPosition(false)
                localPlayerLastPositionSent = true
            }
        }
    }
    func sendLocalPlayerPosition(isAnalogDependant: Bool) {
        var localplayer = getLocalPlayer()
        if isAnalogDependant {
            if movementAnalog.analogIsEngaged() {
                networkingEngine.sendSyncRemotePlayerPosition(localplayer.position.x, posY: localplayer.position.y)
            }
        } else {
            networkingEngine.sendSyncRemotePlayerPosition(localplayer.position.x, posY: localplayer.position.y)
        }
    }
    override func didFinishUpdate() {
        var localPlayer = getLocalPlayer()
        centerWorldOnMainChar(localPlayer)
        updateBorderLayerPosition()
    }
    
    func getLocalPlayer() -> BaseCharacter {
        if _currentPlayerIndex == 0 {
            return player1
        }
        return player2
    }
    func getRemotePlayer() -> BaseCharacter {
        if _currentPlayerIndex == 0 {
            return player2
        }
        return player1
    }
    
    func centerWorldOnMainChar(char : BaseCharacter) {
        if let charPosition = char.scene?.convertPoint(char.position, fromNode: char.parent!) {
            let parentPosition = char.parent!.position
            char.parent!.position = CGPointMake(parentPosition.x - charPosition.x, parentPosition.y - charPosition.y)
        }
    }
    func updateBorderLayerPosition() {
        self.childNodeWithName("borderLayer")?.position = gameWorld.position
    }
    
    
    func matchEnded() {
    }
    func shootProjectileInDirectionWithDuration(destX:CGFloat, destY:CGFloat, duration: CGFloat) {
        
        gameWorld.shootProjectileInDirectionWithDuration(CGPointMake(destX, destY), duration: duration)
    }
    func setCurrentPlayerIndex(index:Int) {
        _currentPlayerIndex = index
        if _currentPlayerIndex == 0 {
            gameWorld.localPlayer = player1
            gameWorld.remotePlayer = player2
        } else {
            gameWorld.localPlayer = player2
            gameWorld.remotePlayer = player1
        }
    }
    
    func movePlayerAtIndex(/*index:Int*/posX:CGFloat, posY:CGFloat) {
        
    }
    func syncRemotePlayerPosition(posX:CGFloat, posY:CGFloat) {
        getRemotePlayer().slideToPosition(CGPointMake(posX, posY))
    }
    func gameOver(player1Won:Bool) {
        
    }
    
    func setPlayerAliases(playerAliases:NSArray) {
        
    }
}
