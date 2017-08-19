//
//  GameScene.swift
//  Falling Ape
//
//  Created by Noah Bragg on 4/30/15.
//  Copyright (c) 2015 NoahBragg. All rights reserved.
//

import SpriteKit
import GameKit

class GameScene : SKScene {
    
    var playButton = SKSpriteNode(imageNamed: "play")
    var viewController: UIViewController?
    var save = Save()
    var sound = Sound()
    
    override func didMoveToView(view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "HomeScreen.png")
        background.position = CGPointMake(self.frame.midX, self.frame.midY)
        let scaleBy = self.frame.height / 2211  //this is the size of the image
        background.runAction(SKAction.scaleTo(scaleBy, duration: 0))
        //self.backgroundColor = UIColor.grayColor()
        
        self.playButton = SKSpriteNode(imageNamed: "menu6.png")
        self.playButton.position = CGPointMake(self.frame.midX, self.frame.midY + self.frame.size.height)
        self.playButton.zPosition = 100;
        self.scaleSpritePlus(self.playButton)
        self.addChild(background)
        self.addChild(self.playButton)
        animatePlayButtonSlideIn()
        
        //play the sound
        sound = Sound(soundIsOn: save.getSoundIsOn(), musicIsOn: true, scene: self)
        sound.homeNoise()
        
    }
    
    func animatePlayButtonSlideIn() {
        let slideIn = SKAction.moveToY(self.frame.midY, duration: 0.3)
        self.playButton.runAction(slideIn)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch:AnyObject in touches {
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.playButton {
                playButton.color = UIColor.blackColor()
                playButton.colorBlendFactor = 0.5
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch:AnyObject in touches {
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.playButton {
                let scene = PlayScene(size: self.size)
                let skView = self.view as SKView!
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .ResizeFill
                scene.size = skView.bounds.size
                scene.viewController = self.viewController
                skView.presentScene(scene)
                //let nextViewController = PlayViewController()
                //self.viewController?.presentViewController(nextViewController, animated: false, completion: nil)
                
            }
        }
        playButton.colorBlendFactor = 0.0           //make sure it isn't highlighted anymore
    }
    
    //scales the sprite to the correct size for the screen based on 6Plus
    private func scaleSpritePlus(sprite:SKSpriteNode) {
        let scaleBy = self.frame.width / 2300   //scale by 6 Plus version which images are made for
        sprite.runAction(SKAction.scaleTo(scaleBy, duration: 0))
    }

    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
