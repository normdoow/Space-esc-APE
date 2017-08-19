//
//  Character.swift
//  InAppPurchase
//
//  Created by Noah Bragg on 7/6/15.
//  Copyright (c) 2015 Brian Coleman. All rights reserved.
//

import Foundation
import SpriteKit

class Character {
    
    //need nsdefaults for current character
    //and active characters
    //and sound effects on/off
    //and ads on/off
    
    //variables
    private var name: String = ""               //name for the character
    private var id: String = ""                 //id from app store
    private var bananaPrice:Int = 0
    private var middleTexture = SKTexture()     //is a texture
    private var leftTexture = SKTexture()       //the left texture
    private var deathSound = ""                 //will be a sound file name
    private var isActivated = false             //know if character is chosen character
    private var isUnlocked = false              //know if character is boughten or unlocked
    
    init() {
        name = "nothing"
        id = "1234"
        isActivated = false
        isUnlocked = true
    }
    
    //initializes all the variables
    init(name:String,id:String,texture:SKTexture,deathSound:String,isActivated:Bool) {
        self.name = name
        self.id = id
        self.bananaPrice = 500
        self.middleTexture = texture
        self.deathSound = deathSound
        self.isActivated = isActivated
    }
//    init(count:Int, repeatedValue:Character) {
//        for var k = 0; k < count; k++ {
//            
//        }
//    }
    
    func initArrayOfCharacters(isUnlockedArray:[Bool], isActivatedArray:[Bool]/*,leftTextures:[SKTexture], middleTextures:[SKTexture]*/) -> [Character] {                                                               //took this out to fix images
        var tempCharacters = [Character]()
        for var k = 0; k < 16; k++ {            //init this
            tempCharacters.append(Character())
        }

        //create the array stuff
        //astronaut
        tempCharacters[0].name = "Neil"
        tempCharacters[0].id = "none"
        tempCharacters[0].deathSound = "astronaut-death.wav"
        tempCharacters[0].middleTexture = SKTexture(imageNamed: "monkey1")          //added all these in to fix images
        tempCharacters[0].leftTexture = SKTexture(imageNamed: "MonkeyLeft1")
        tempCharacters[0].bananaPrice = 0
        
        tempCharacters[1].name = "Meredith"
        tempCharacters[1].id = "none"
        tempCharacters[1].deathSound = "girl-death.wav"
        tempCharacters[1].middleTexture = SKTexture(imageNamed: "monkey2")
        tempCharacters[1].leftTexture = SKTexture(imageNamed: "MonkeyLeft2")
        tempCharacters[1].bananaPrice = 0
        
        tempCharacters[2].name = "Arnold"
        tempCharacters[2].id = "none"
        tempCharacters[2].deathSound = "nerd-death.wav"
        tempCharacters[2].middleTexture = SKTexture(imageNamed: "monkey3")
        tempCharacters[2].leftTexture = SKTexture(imageNamed: "MonkeyLeft3")
        tempCharacters[2].bananaPrice = 0
        
        tempCharacters[3].name = "Otis"
        tempCharacters[3].id = "com.NoahBragg.SpaceEscape.Otis"
        tempCharacters[3].deathSound = "blackHat-death.wav"
        tempCharacters[3].middleTexture = SKTexture(imageNamed: "monkey4")
        tempCharacters[3].leftTexture = SKTexture(imageNamed: "MonkeyLeft4")
        tempCharacters[3].bananaPrice = 250
        
        tempCharacters[4].name = "Walter"
        tempCharacters[4].id = "com.NoahBragg.SpaceEscape.Walter"
        tempCharacters[4].deathSound = "military-death.wav"
        tempCharacters[4].middleTexture = SKTexture(imageNamed: "monkey5")
        tempCharacters[4].leftTexture = SKTexture(imageNamed: "MonkeyLeft5")
        tempCharacters[4].bananaPrice = 500
        
        tempCharacters[5].name = "Won J"
        tempCharacters[5].id = "com.NoahBragg.SpaceEscape.WonJ"
        tempCharacters[5].deathSound = "ninja-death.wav"
        tempCharacters[5].middleTexture = SKTexture(imageNamed: "monkey6")
        tempCharacters[5].leftTexture = SKTexture(imageNamed: "MonkeyLeft6")
        tempCharacters[5].bananaPrice = 500
        
        tempCharacters[6].name = "Eugene"
        tempCharacters[6].id = "com.NoahBragg.SpaceEscape.Eugene"
        tempCharacters[6].deathSound = "grandpa-death.wav"
        tempCharacters[6].middleTexture = SKTexture(imageNamed: "monkey7")
        tempCharacters[6].leftTexture = SKTexture(imageNamed: "MonkeyLeft7")
        tempCharacters[6].bananaPrice = 750
        
        tempCharacters[7].name = "Ethel"
        tempCharacters[7].id = "com.NoahBragg.SpaceEscape.Ethel"
        tempCharacters[7].deathSound = "grandma-death.wav"
        tempCharacters[7].middleTexture = SKTexture(imageNamed: "monkey8")
        tempCharacters[7].leftTexture = SKTexture(imageNamed: "MonkeyLeft8")
        tempCharacters[7].bananaPrice = 750
        
        tempCharacters[8].name = "Blaze"
        tempCharacters[8].id = "com.NoahBragg.SpaceEscape.Blaze"
        tempCharacters[8].deathSound = "Cowboy-death.wav"
        tempCharacters[8].middleTexture = SKTexture(imageNamed: "monkey9")
        tempCharacters[8].leftTexture = SKTexture(imageNamed: "MonkeyLeft9")
        tempCharacters[8].bananaPrice = 750
        
        tempCharacters[9].name = "Running Fish"
        tempCharacters[9].id = "com.NoahBragg.SpaceEscape.RunningFish"
        tempCharacters[9].deathSound = "indian-death.wav"
        tempCharacters[9].middleTexture = SKTexture(imageNamed: "monkey10")
        tempCharacters[9].leftTexture = SKTexture(imageNamed: "MonkeyLeft10")
        tempCharacters[9].bananaPrice = 750
        
        tempCharacters[10].name = "Terrell"
        tempCharacters[10].id = "com.NoahBragg.SpaceEscape.Terrell"
        tempCharacters[10].deathSound = "thug-death.wav"
        tempCharacters[10].middleTexture = SKTexture(imageNamed: "monkey11")
        tempCharacters[10].leftTexture = SKTexture(imageNamed: "MonkeyLeft11")
        tempCharacters[10].bananaPrice = 1000
        
        tempCharacters[11].name = "Brody"
        tempCharacters[11].id = "com.NoahBragg.SpaceEscape.Brody"
        tempCharacters[11].deathSound = "brody-death.wav"
        tempCharacters[11].middleTexture = SKTexture(imageNamed: "monkey12")
        tempCharacters[11].leftTexture = SKTexture(imageNamed: "MonkeyLeft12")
        tempCharacters[11].bananaPrice = 1000
        
        tempCharacters[12].name = "Marcel"
        tempCharacters[12].id = "com.NoahBragg.SpaceEscape.Marcel"
        tempCharacters[12].deathSound = "mime-death.wav"
        tempCharacters[12].middleTexture = SKTexture(imageNamed: "monkey13")
        tempCharacters[12].leftTexture = SKTexture(imageNamed: "MonkeyLeft13")
        tempCharacters[12].bananaPrice = 2000
        
        tempCharacters[13].name = "Kymani"
        tempCharacters[13].id = "com.NoahBragg.SpaceEscape.Kymani"
        tempCharacters[13].deathSound = "jamaican-death.wav"
        tempCharacters[13].middleTexture = SKTexture(imageNamed: "monkey14")
        tempCharacters[13].leftTexture = SKTexture(imageNamed: "MonkeyLeft14")
        tempCharacters[13].bananaPrice = 3000
        
        tempCharacters[14].name = "Asger"
        tempCharacters[14].id = "com.NoahBragg.SpaceEscape.Asger"
        tempCharacters[14].deathSound = "viking-death.wav"
        tempCharacters[14].middleTexture = SKTexture(imageNamed: "monkey15")
        tempCharacters[14].leftTexture = SKTexture(imageNamed: "MonkeyLeft15")
        tempCharacters[14].bananaPrice = 5000
        
        tempCharacters[15].name = "Unlock All"
        tempCharacters[15].id = "com.NoahBragg.SpaceEscape.UnlockAll"
        tempCharacters[15].deathSound = "astronaut-death.wav"
        tempCharacters[15].middleTexture = SKTexture(imageNamed: "monkey16")
        tempCharacters[15].leftTexture = SKTexture(imageNamed: "MonkeyLeft16")
        tempCharacters[15].bananaPrice = 0
        
        //init other array stuff
        for var k = 0; k < tempCharacters.count; k++ {
            tempCharacters[k].isActivated = isActivatedArray[k]
            tempCharacters[k].isUnlocked = isUnlockedArray[k]
//            tempCharacters[k].middleTexture = middleTextures[k]
//            tempCharacters[k].leftTexture = leftTextures[k]
            
        }
        return tempCharacters
    }
    
    //getters
    func getName() -> String{
        return name
    }
    func getID() -> String {
        return id
    }
    func getBananaPrice() -> Int {
        return bananaPrice
    }
    func getMiddleTexture() -> SKTexture {
        return middleTexture
    }
    func getLeftTexture() -> SKTexture {
        return leftTexture
    }
    func getDeathSound() -> String {
        return deathSound
    }
    func getIsActivated() -> Bool {
        return isActivated
    }
    func getIsUnlocked() -> Bool {
        return isUnlocked
    }

    
    //setters
    func setName(name:String) {
        self.name = name
    }
    func setID(id:String) {
        self.id = id
    }
    func setID(bananaPrice:Int) {
        self.bananaPrice = bananaPrice
    }
    func setMiddleTexture(texture:SKTexture) {
        self.middleTexture = texture
    }
    func setLeftTexture(texture:SKTexture) {
        self.leftTexture = texture
    }
    func setDeathSound(sound:String) {
        self.deathSound = sound
    }
    func setIsActivated(isActivated:Bool) {
        self.isActivated = isActivated
    }
    func setIsUnlocked(isUnlocked:Bool) {
        self.isUnlocked = isUnlocked
    }
}
