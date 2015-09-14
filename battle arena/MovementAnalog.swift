//
//  MovementAnalog.swift
//  battle arena
//
//  Created by Abdul on 8/29/15.
//  Copyright (c) 2015 3bdugames. All rights reserved.
//
import Foundation
import SpriteKit
class MovementAnalog : SKNode {
    
    var player = BaseCharacter()
    var background = SKSpriteNode(texture: nil, color: UIColor.orangeColor(), size: CGSize(width: 100, height: 100))
    var innerDot = SKSpriteNode(texture: SKTexture(imageNamed: "spark.png"))
    var analogEngaged = false
    
    override init() {
        super.init()
        zPosition = 30
        setUpSelfPosition()
        userInteractionEnabled = true
        addChild(background)
        addChild(innerDot)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUpSelfPosition() {
        self.position.x = -220
        self.position.y = -100
    }
    func updateInnerDotPosition(position: CGPoint) {
        innerDot.position = position
    }
    func resetInnerDotPosition() {
        innerDot.position = CGPoint(x: 0, y: 0)
    }
    func keepDotWithinBounds(point: CGPoint, bounds: CGFloat) -> CGPoint {
        var xPos = point.x
        var yPos = point.y
        
        if (point.x > bounds || point.x < bounds * -1) {
            xPos = point.x * abs(bounds / point.x)
        }
        if (point.y > bounds || point.y < bounds * -1) {
            yPos = point.y * abs(bounds / point.y)
        }
        return CGPoint(x: xPos, y: yPos)
    }
    func normalizeMovementAmount() -> CGPoint {
        return CGPoint(x: innerDot.position.x / 10, y: innerDot.position.y / 10)
    }
    func getMovementAmount() -> CGPoint {
        return normalizeMovementAmount()
    }
    func analogIsEngaged() -> Bool {
        return analogEngaged
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        analogEngaged = true
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            updateInnerDotPosition(location)
        }
        
    }
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            updateInnerDotPosition(keepDotWithinBounds(location, bounds: background.size.width / 2))
        }
    }
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        analogEngaged = false
        resetInnerDotPosition()
    }
}