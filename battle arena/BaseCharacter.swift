//
//  BaseCharacter.swift
//  battle arena
//
//  Created by Abdul on 8/27/15.
//  Copyright (c) 2015 3bdugames. All rights reserved.
//

import Foundation
import SpriteKit

class BaseCharacter : SKNode {
    
    var healthLabel = ""
    var damageLabel = ""
    var isMoving = false
    var baseMovementSpeed:CGFloat = 1
    var weapon = ""
    var maxHp = ""
    var target = ""
    var isAbilitySelected = false
    var canMove = true
    
    var selectedAbility = BaseAbility()
    var negativeEffect = BaseEffect()
    var positiveEffect = BaseEffect()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
        self.name = "mainChar"
        addChild(getCharacterBody())
        SpritePhysicsSetUpHelper().basicSetUpPhysics(self, pBody: SKPhysicsBody(rectangleOfSize: convertNodeToSprite(self.childNodeWithName("charBody")!).size), dynamic: true, categoryBitMask: PhysicsCategory.Character, contactTestBitMask: PhysicsCategory.All, collisionBitMask: PhysicsCategory.Barrier, preciseCollision: true)
    }
    
    func getCharacterBody() -> SKSpriteNode {
        let texture = SKTexture(imageNamed: "batman-sprite.png")
        let body = SKSpriteNode(texture: texture, color: nil, size: CGSize(width: 80, height: 100))
        body.name = "charBody"
        return body
    }

    func applyMovementSpeed(moveAmount: CGFloat) -> CGFloat {
        if negativeEffect.getSpeed() < 1 {
            return moveAmount * negativeEffect.getSpeed()
        }
        return moveAmount * positiveEffect.getSpeed()
    }
    func movePosition(point : CGPoint) {
            position.x += applyMovementSpeed(point.x)
            position.y += applyMovementSpeed(point.y)
    }
    func updatePosition(point: CGPoint) {
        position = point
    }
    func convertNodeToSprite(node : SKNode) -> SKSpriteNode {
        return node as! SKSpriteNode
    }
    
    
    func update() {
        
    }

    
    
    //getters/setters
    
    func hasAbilitySelected() -> Bool {
        return isAbilitySelected
    }
    func assignIsAbilitySelected(selected: Bool) {
        isAbilitySelected = selected
    }
    func getSelectedAbility() -> BaseAbility {
        return selectedAbility
    }

    func getMovementSpeed() -> CGFloat {
        if negativeEffect.getSpeed() < 1 {
            return negativeEffect.getSpeed()
        }
        return positiveEffect.getSpeed()
    }
    
}
