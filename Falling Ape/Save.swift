//
//  Save.swift
//  Falling Ape
//
//  Created by Noah Bragg on 6/6/15.
//  Copyright (c) 2015 NoahBragg. All rights reserved.
//

import Foundation
import UIKit

public class Save {
    
    private var highScore:Int
    private var monkeyIndex:Int
    private var totalBananas:Int
    private var soundIsOn = true
    private var vibrateIsOn = true
    private var adsAreOn = true
    private var charactersUnlocked = [Bool]()
    private var charactersActivated = [Bool]()
    let defaults = NSUserDefaults.standardUserDefaults()
    
    //initializer
    init(){
        highScore = 0
        monkeyIndex = 0
        totalBananas = 0
        soundIsOn = true
        vibrateIsOn = true
        adsAreOn = true
        //init arrays for very first game
        for var k = 0; k < 16; k++ {
            charactersActivated.append(false)
        }
        charactersActivated[0] = true
        for var k = 0; k < 16; k++ {
            charactersUnlocked.append(false)
        }
        charactersUnlocked[0] = true
    }
    
    //getters
    public func getHighScore() -> Int {
        
        if defaults.objectForKey("HighScore") != nil {
            return defaults.objectForKey("HighScore") as! Int
        }
        return 0
    }
    
    public func getMonkeyIndex() -> Int {
        
        if defaults.objectForKey("MonkeyIndex") != nil {
            return defaults.objectForKey("MonkeyIndex") as! Int
        }
        return 0
    }
    
    public func getTotalBananas() -> Int {
        
        if defaults.objectForKey("TotalBananas") != nil {
            return defaults.objectForKey("TotalBananas") as! Int
        }
        return 0  //for people to get a head start with bananas
    }
    
    public func getSoundIsOn() -> Bool {
        
        if defaults.objectForKey("SoundIsOn") != nil {
            return defaults.objectForKey("SoundIsOn") as! Bool
        }
        return soundIsOn
    }
    
    public func getVibrateIsOn() -> Bool {
        
        if defaults.objectForKey("VibrateIsOn") != nil {
            return defaults.objectForKey("VibrateIsOn") as! Bool
        }
        return vibrateIsOn
    }
    
    public func getAdsAreOn() -> Bool {
        
        if defaults.objectForKey("AdsAreOn") != nil {
            return defaults.objectForKey("AdsAreOn") as! Bool
        }
        return adsAreOn
    }
    
    public func getCharactersUnlocked() -> [Bool] {
        var tempArray = charactersUnlocked
        for var k = 0; k < tempArray.count; k++ {
            if defaults.objectForKey("CharactersUnlocked\(k)") != nil {
                 tempArray[k] = (defaults.objectForKey("CharactersUnlocked\(k)") as! Bool)
            }
        }
        return tempArray
    }
    
    public func getCharactersActivated() -> [Bool] {
        var tempArray = charactersActivated
        for var k = 0; k < tempArray.count; k++ {
            if defaults.objectForKey("CharactersActivated\(k)") != nil {
                tempArray[k] = (defaults.objectForKey("CharactersActivated\(k)") as! Bool)
            }
        }
        return tempArray
    }
    
    //savers
    public func saveHighScore(highScore:Int) {
        
        //save the theyHitOdds var of what numbers where chosen
        defaults.setObject(highScore, forKey: "HighScore")
        defaults.synchronize()
    }
    
    public func saveMonkeyIndex(monkeyIndex:Int) {
        
        //save the theyHitOdds var of what numbers where chosen
        defaults.setObject(monkeyIndex, forKey: "MonkeyIndex")
        defaults.synchronize()
    }
    
    public func saveTotalBananas(total:Int) {
        
        //save the theyHitOdds var of what numbers where chosen
        defaults.setObject(total, forKey: "TotalBananas")
        defaults.synchronize()
    }
    
    public func saveSoundIsOn(soundIsOn:Bool) {
        
        //save the theyHitOdds var of what numbers where chosen
        defaults.setObject(soundIsOn, forKey: "SoundIsOn")
        defaults.synchronize()
    }
    
    public func saveVibrateIsOn(vibrateIsOn:Bool) {
        
        //save the theyHitOdds var of what numbers where chosen
        defaults.setObject(vibrateIsOn, forKey: "VibrateIsOn")
        defaults.synchronize()
    }
    
    public func saveAdsAreOn(adsAreOn:Bool) {
        
        //save the theyHitOdds var of what numbers where chosen
        defaults.setObject(adsAreOn, forKey: "AdsAreOn")
        defaults.synchronize()
    }
    
    public func saveCharactersUnlocked(charactersUnlocked:[Bool]) {
        for var k = 0; k < charactersUnlocked.count; k++ {
            defaults.setObject(charactersUnlocked[k], forKey: "CharactersUnlocked\(k)")
        }
        defaults.synchronize()
    }
    public func saveCharacterActivatedAt(index:Int, isActivated:Bool) {
        var tempArray = charactersActivated
        for var k = 0; k < charactersActivated.count; k++ {
            if k == index {
                tempArray[k] = true
            } else {
                tempArray[k] = false
            }
        }
        saveCharactersActivated(tempArray)
    }
    
    public func saveCharactersActivated(charactersActivated:[Bool]) {
        for var k = 0; k < charactersActivated.count; k++ {
            defaults.setObject(charactersActivated[k], forKey: "CharactersActivated\(k)")
        }
        defaults.synchronize()
    }
    
}