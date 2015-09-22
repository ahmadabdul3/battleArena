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
    
    var healthLabel = SKLabelNode(text: "100/100")
    var damageLabel = ""
    var isMoving = false
    var baseMovementSpeed:CGFloat = 1
    var weapon = ""
    var maxHp = "100"
    var hitPoints: CGFloat = 100
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
        setUpHpLabel()
        SpritePhysicsSetUpHelper().basicSetUpPhysics(self, pBody: SKPhysicsBody(rectangleOfSize: convertNodeToSprite(self.childNodeWithName("charBody")!).size), dynamic: true, categoryBitMask: PhysicsCategory.Character, contactTestBitMask: PhysicsCategory.All, collisionBitMask: PhysicsCategory.Barrier, preciseCollision: true)
    }
    
    func setUpHpLabel() {
        healthLabel.fontName = "Arial-BoldMT"
        healthLabel.fontSize = 15
        healthLabel.fontColor = UIColor.redColor()
        healthLabel.position = CGPointMake(self.position.x, self.position.y + 55)
        addChild(healthLabel)
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
    func slideToPosition(newPosition: CGPoint) {
        var slideToNewPosition = SKAction.moveTo(newPosition, duration: 0.1)
        self.runAction(slideToNewPosition)
    }
    func convertNodeToSprite(node : SKNode) -> SKSpriteNode {
        return node as! SKSpriteNode
    }
    
    
    func applyAbilityEffect(effect:BaseEffect) {
        
        negativeEffect = effect
        applyInitialDamage()
        applyExtendedDamage()
        resetNegativeEffectWithDelay(negativeEffect.duration)
    }
    func applyInitialDamage() {
        deductHp(negativeEffect.damage.getInitPhys() + negativeEffect.damage.getInitSpec())
    }
    func applyExtendedDamage() {
        if negativeEffect.damage.getXtndSpec() > 0 || negativeEffect.damage.getXtndPhys() > 0 {
            runAction(
                SKAction.repeatAction (
                SKAction.sequence([
                    SKAction.waitForDuration(negativeEffect.frequency),
                    SKAction.runBlock({
                        self.deductHp(self.negativeEffect.damage.getXtndPhys() + self.negativeEffect.damage.getXtndSpec())
                        return ()
                    })
                    
                    ]),
                    count : negativeEffect.getCount()
                )
            )
        }
    }
    
    
    func deductHp(amount: CGFloat) {
        hitPoints -= amount
        updateHpLabel()
    }
    func resetNegativeEffectWithDelay(delay: NSTimeInterval) {
        runAction(
            SKAction.sequence([
                SKAction.waitForDuration(delay),
                SKAction.runBlock({
                    self.updateNegEffect(BaseEffect())
                    return ()
                })
            ])
        )
    }
    func update() {
        
    }

    func updateHpLabel() {
        healthLabel.text = String(stringInterpolationSegment: hitPoints) + "/" + maxHp
    }
    
    //getters/setters
    
    func updateNegEffect(effect: BaseEffect) {
        negativeEffect = effect
        
    }
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
