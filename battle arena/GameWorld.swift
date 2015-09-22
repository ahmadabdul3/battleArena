//
//  GameWorld.swift
//  battle arena
//
//  Created by Abdul on 8/27/15.
//  Copyright (c) 2015 3bdugames. All rights reserved.
//

import Foundation
import SpriteKit
import Darwin

class GameWorld: SKSpriteNode, SKPhysicsContactDelegate {
    
    var physicsWorld = SKPhysicsWorld()
    var localPlayer = BaseCharacter()
    var remotePlayer = BaseCharacter()
    let baseCharArray = NSMutableArray()
    var networkingEngine = MultiplayerNetworking()
    
    init() {
        super.init(texture: nil, color: nil, size: CGSize(width: 1000, height: 1000))
        self.userInteractionEnabled = true
        
    }
    init(rectOfSize: CGSize) {
        super.init(texture: nil, color: UIColor.grayColor(), size: rectOfSize)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSelfScale(x: CGFloat, y: CGFloat) {
        self.xScale = x
        self.yScale = y
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
    }
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        
    }
    /*override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            if player1.hasAbilitySelected() {
                addChildNode(player1.getSelectedAbility(), location: location, zPosition: self.zPosition + 5)
            }
            
        }
    }*/
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        
    }
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            shootProjectileInDirection(location)
        }
    }
    
    func shootProjectileInDirection(direction: CGPoint) {
        var projectile = getFrostBolt()
        projectile.position = localPlayer.position
        var xminus = (direction.x - localPlayer.position.x)
        var yminus = (direction.y - localPlayer.position.y)
        var xpart = xminus * xminus
        var ypart = yminus * yminus
        var distance = sqrt(xpart + ypart)
        var duration = distance / 200
        networkingEngine.sendAddAbility("frostBolt", destX: direction.x, destY: direction.y, duration: duration)
        addChild(projectile)
        projectile.runAction(
            SKAction.sequence([
                SKAction.moveTo(direction, duration: NSTimeInterval(duration)),
                SKAction.runBlock({self.removeNode(projectile); return ()})
                ])
        )
        
    }
    func getFrostBolt() -> FrostBolt {
        var bolt = FrostBolt()
        bolt.casterName = localPlayer.name!
        return bolt
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
                (secondBody!.categoryBitMask == PhysicsCategory.Projectile)) {
                    handleCollision(firstBody?.node! as! BaseCharacter, ability: secondBody?.node! as! BaseAbility)
                    //projectileDidCollideWithMonster(secondBody!.node!, monster: firstBody!.node!)
            }
        }
        
    }
    func handleCollision(character: BaseCharacter, ability: BaseAbility) {
        if ability.casterName != character.name {
            character.applyAbilityEffect(ability.effect)
            ability.removeFromParent()
        }
    }
    
    func shootProjectileInDirectionWithDuration(direction:CGPoint, duration: CGFloat) {
        var projectile = getFrostBolt()
        projectile.casterName = remotePlayer.name!
        projectile.position = remotePlayer.position
        addChild(projectilse)
        projectile.runAction(
            SKAction.sequence([
                SKAction.moveTo(direction, duration: NSTimeInterval(duration)),
                SKAction.runBlock({self.removeNode(projectile); return ()})
                ])
        )
    }
    func removeNode(node:SKNode) {
        node.removeFromParent()
    }
    func addChildNode(node: SKNode,location: CGPoint, zPosition: CGFloat) {
        node.zPosition = zPosition
        node.position = location
        self.addChild(node)
    }
    
    func update() {
        updateBaseChar(localPlayer)
        
    }
    func updateBaseChar(char: BaseCharacter) {
        char.update()
    }
    
    
}
