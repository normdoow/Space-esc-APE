//
//  Sound.swift
//  InAppPurchase
//
//  Created by Noah Bragg on 7/6/15.
//  Copyright (c) 2015 Brian Coleman. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class Sound {
    
    //variables
    var soundIsOn = true
    var musicIsOn = true
    var scene = SKScene()       //variable to the scene
    //background music
    var audioPlayer = try? AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("wind", ofType: "wav")!))
    
    //initializer for the class
    init() {
        //var soundIsOn = true          //wasn't using these
        //var musicIsOn = true
    }
    
    init(soundIsOn:Bool, musicIsOn:Bool, scene:SKScene) {
        self.soundIsOn = soundIsOn
        self.musicIsOn = musicIsOn
        self.scene = scene
        
        //listeners for when ads come up
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "stopBackgroundSound", name: "NSNotificationForSound", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playBackgroundSound", name: "NSNotificationForSoundStart", object: nil)
        
        audioPlayer!.volume = 0.5        //set the volume
        audioPlayer!.numberOfLoops = -1
    }
    
    //setter
    func setSoundIsOn(soundIsOn:Bool) {
        self.soundIsOn = soundIsOn
    }
    
    //sound methods
    func playDeathSound(character:Character) {
        if soundIsOn {
            let sound = SKAction.playSoundFileNamed(character.getDeathSound(), waitForCompletion: false)
            scene.runAction(sound)
        }
    }
    
    func gotNannerSound() {
        if soundIsOn {
            let sound = SKAction.playSoundFileNamed("banana.wav", waitForCompletion: false)
            scene.runAction(sound)
        }
    }
    
    func buttonDown() {
        if soundIsOn {
            let sound = SKAction.playSoundFileNamed("buttonDown.wav", waitForCompletion: false)
            scene.runAction(sound)
        }
    }
    
    func buttonUp() {
        if soundIsOn {
            let sound = SKAction.playSoundFileNamed("buttonUp.wav", waitForCompletion: false)
            scene.runAction(sound)
        }
    }
    
    func largeAsteroid() {
        if soundIsOn {
            let sound = SKAction.playSoundFileNamed("largeAsteroid.wav", waitForCompletion: false)
            scene.runAction(sound)
        }
    }
    
    func hitAsteroid() {
        if soundIsOn {
            let sound = SKAction.playSoundFileNamed("hitAsteroid.wav", waitForCompletion: false)
            scene.runAction(sound)
        }
    }
    
    @objc func playBackgroundSound() {
        if soundIsOn {
            audioPlayer!.play()
        }
    }
    
    @objc func stopBackgroundSound() {
        if soundIsOn {
            audioPlayer!.stop()
        }
    }
    
    func highScore() {
        if soundIsOn {
            let sound = SKAction.playSoundFileNamed("highScore.wav", waitForCompletion: false)
            scene.runAction(sound)
        }
    }
    
    func selectScreen() {
        if soundIsOn {
            let sound = SKAction.playSoundFileNamed("characterSelect.wav", waitForCompletion: false)
            scene.runAction(sound)
        }
    }
    
    func homeNoise() {
        if soundIsOn {
            let sound = SKAction.playSoundFileNamed("homeNoise.wav", waitForCompletion: false)
            scene.runAction(sound)
        }
    }
    
}