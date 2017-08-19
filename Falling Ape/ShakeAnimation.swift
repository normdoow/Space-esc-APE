//
//  ShakeAnimation.swift
//  Falling Ape
//
//  Created by Noah Bragg on 7/22/15.
//  Copyright (c) 2015 NoahBragg. All rights reserved.
//

import Foundation
import SpriteKit

extension SKAction {
    //this is a shake animation
    class func shake(duration:CGFloat, amplitudeX:CGFloat, amplitudeY:CGFloat) -> SKAction {
        let numberOfShakes = duration / 0.015 / 2.0
        var actionsArray:[SKAction] = []
        for _ in 1...Int(numberOfShakes) {
            let dx = CGFloat(arc4random_uniform(UInt32(amplitudeX))) - amplitudeX / 2
            let dy = CGFloat(arc4random_uniform(UInt32(amplitudeY))) - amplitudeY / 2
            let forward = SKAction.moveByX(dx, y:dy, duration: 0.015)
            let reverse = forward.reversedAction()
            actionsArray.append(forward)
            actionsArray.append(reverse)
        }
        return SKAction.sequence(actionsArray)
    }
}