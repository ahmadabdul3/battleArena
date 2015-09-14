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

class GameScene: SKScene, SKPhysicsContactDelegate, MultiplayerNetworkingProtocol {
    
    var gameWorld = GameWorld()
    var movementAnalog = MovementAnalog()
    var player1 = BaseCharacter()
    var player2 = BaseCharacter()
    var _currentPlayerIndex = 0
    var _players = NSMutableArray()
    var networkingEngine = MultiplayerNetworking()
    var frameNumber = 0
    
    var remotePlayerMoving = false
    
    var remotePlayerLastMove = CGPointMake(0, 0)
    var remotePlayerReceivedMoveFrame = 0
    var positionFrameNumber = 0
    
    override func didMoveToView(view: SKView) {
        self.anchorPoint = CGPointMake(0.5, 0.5)
        gameWorld.addChild(player1)
        gameWorld.player1 = self.player1
        gameWorld.addChild(player2)
        gameWorld.player2 = self.player2
        addChild(gameWorld)
        addChild(movementAnalog)
        updateBorderLayerPosition()
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        
    }
    override func update(currentTime: CFTimeInterval) {
        gameWorld.update()
        moveLocalPlayer()
        moveRemotePlayer()
        sendSyncPositionData()
        updateFrameNumber()
        updatePositionFrameNumber()
        
    }
    
    func moveLocalPlayer() {
        if movementAnalog.analogIsEngaged() {
            var localPlayer = getLocalPlayer()
            var movementAmount = movementAnalog.getMovementAmount()
            localPlayer.movePosition(movementAmount)
            if frameNumber == 0 {
                networkingEngine.sendMove(movementAmount.x, posY: movementAmount.y)
            }
        } else {
            if frameNumber == 0 {
                networkingEngine.sendMove(0, posY: 0)
            }
        }
    }
    func moveRemotePlayer() {
        //if remotePlayerMoving {
            //if frameNumber != 0 {
                estimateRemotePlayerMovement()
            //}
        //}
    }
    func estimateRemotePlayerMovement() {
        getRemotePlayer().movePosition(remotePlayerLastMove)
    }
    func sendSyncPositionData() {
        if positionFrameNumber == 0 {
            if remotePlayerLastMove.x != 0 && remotePlayerLastMove.y != 0 {
                var localplayer = getLocalPlayer()
                networkingEngine.sendSyncRemotePlayerPosition(localplayer.position.x, posY: localplayer.position.y)
            }
        }
    }
    func updateFrameNumber() {
        frameNumber++
        if frameNumber == 4 {
            frameNumber = 0
        }
    }
    func updatePositionFrameNumber() {
        positionFrameNumber++
        if positionFrameNumber == 4 {
            positionFrameNumber = 0
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
    
    func didBeginContact(contact: SKPhysicsContact) {
  
        var firstBody: SKPhysicsBody?
        var secondBody: SKPhysicsBody?
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (firstBody!.node != nil && secondBody!.node != nil) {
            
            if ((firstBody!.categoryBitMask == PhysicsCategory.Character) &&
                (secondBody!.categoryBitMask == PhysicsCategory.Barrier)) {
                    
                    //projectileDidCollideWithMonster(secondBody!.node!, monster: firstBody!.node!)
            }
        }
        
    }
    
    
    func matchEnded() {
    }
    
    func setCurrentPlayerIndex(index:Int) {
        _currentPlayerIndex = index
    }
    
    func movePlayerAtIndex(/*index:Int*/posX:CGFloat, posY:CGFloat) {
        //if posX != 0 && posY != 0 {
            //remotePlayerMoving = true
            remotePlayerLastMove = CGPointMake(posX, posY)
            //getRemotePlayer().movePosition(remotePlayerLastMove)
        //} else {
        //    remotePlayerMoving = false
        //    remotePlayerLastMove = CGPointMake(0, 0)
        //}
    }
    func syncRemotePlayerPosition(posX:CGFloat, posY:CGFloat) {
        getRemotePlayer().updatePosition(CGPointMake(posX, posY))
    }
    func gameOver(player1Won:Bool) {
        
    }
    
    func setPlayerAliases(playerAliases:NSArray) {
        
    }
}
