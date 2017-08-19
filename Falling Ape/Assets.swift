//
//  Assets.swift
//  Falling Ape
//
//  Created by Noah Bragg on 7/3/15.
//  Copyright (c) 2015 NoahBragg. All rights reserved.
//

import Foundation
import SpriteKit

class Assets {
    
    //var monkiesAtlas = SKTextureAtlas()                   //commented this stuff out because we don't use these assets anymore
    //var monkiesAtlasLeft = SKTextureAtlas()
    var bananaAnimatedAtlas = SKTextureAtlas()
    var asteroidAtlas1 = SKTextureAtlas()
    var asteroidAtlas2 = SKTextureAtlas()
    var asteroidAtlas3 = SKTextureAtlas()
    var menuAtlas = SKTextureAtlas()
    
    //monkey textures that will be used in the scene
    //var monkeyTextures:[SKTexture]!
    //var monkeyLeftTextures:[SKTexture]!
    var bananaFrames:[SKTexture]!
    var smallAsteroidTextures:[SKTexture]!
    var mediumAsteroidTextures:[SKTexture]!
    var largeAsteroidTectures:[SKTexture]!
    var menuTextures:[SKTexture]!
    
    func initAtlases(/*monkiesAtlas:SKTextureAtlas, monkiesAtlasLeft:SKTextureAtlas, */bananaAnimatedAtlas:SKTextureAtlas, asteroidAtlas1:SKTextureAtlas, asteroidAtlas2:SKTextureAtlas, asteroidAtlas3:SKTextureAtlas, menuAtlas:SKTextureAtlas) {
        //self.monkiesAtlas = monkiesAtlas
        //self.monkiesAtlasLeft = monkiesAtlasLeft
        self.bananaAnimatedAtlas = bananaAnimatedAtlas
        self.asteroidAtlas1 = asteroidAtlas1
        self.asteroidAtlas2 = asteroidAtlas2
        self.asteroidAtlas3 = asteroidAtlas3
        self.menuAtlas = menuAtlas
    }
    
    //init the monkies textures
//    func initMonkies() -> [SKTexture] {
//        //get textures from the atlas
//        var tempMonkeyTextures = [SKTexture]()
//        let numImages = monkiesAtlas.textureNames.count
//        for var i = 1; i <= numImages; i++ {                //put all the atlas images into array of textures
//            tempMonkeyTextures.append(monkiesAtlas.textureNamed("monkey\(i)"))
//        }
//        return tempMonkeyTextures
//    }
//    
//    //init the monkies textures
//    func initLeftMonkies() -> [SKTexture] {
//        //get textures from the atlas
//        var tempMonkeyTextures = [SKTexture]()
//        let numImages = monkiesAtlas.textureNames.count
//        for var i = 1; i <= numImages; i++ {                //put all the atlas images into array of textures
//            tempMonkeyTextures.append(monkiesAtlasLeft.textureNamed("MonkeyLeft\(i)"))
//        }
//        return tempMonkeyTextures
//    }

    //set up the banana frames
    func initBananaFrames() -> [SKTexture] {
        var tempBananaFrames = [SKTexture]()
        let numImages = bananaAnimatedAtlas.textureNames.count
        for var i = 1; i <= numImages; i++ {
            tempBananaFrames.append(bananaAnimatedAtlas.textureNamed("banana\(i)"))
        }
        return tempBananaFrames
    }
    
    //init the asteroids textures
    func initSmallAsteroids() -> [SKTexture] {
        //get textures from the atlas
        var tempAsteroidTextures = [SKTexture]()
        let numImages = asteroidAtlas1.textureNames.count
        for var i = 1; i <= numImages; i++ {                //put all the atlas images into array of textures
            tempAsteroidTextures.append(asteroidAtlas1.textureNamed("asteroid\(i)"))
        }
        return tempAsteroidTextures
    }
    
    //init the asteroids textures
    func initMediumAsteroids() -> [SKTexture] {
        //get textures from the atlas
        var tempAsteroidTextures = [SKTexture]()
        let numImages = asteroidAtlas2.textureNames.count
        for var i = 1; i <= numImages; i++ {                //put all the atlas images into array of textures
            tempAsteroidTextures.append(asteroidAtlas2.textureNamed("asteroid\(i)"))
        }
        return tempAsteroidTextures
    }
    
    //init the asteroids textures
    func initLargeAsteroids() -> [SKTexture] {
        //get textures from the atlas
        var tempAsteroidTextures = [SKTexture]()
        let numImages = asteroidAtlas3.textureNames.count
        for var i = 1; i <= numImages; i++ {                //put all the atlas images into array of textures
            tempAsteroidTextures.append(asteroidAtlas3.textureNamed("asteroid\(i)"))
        }
        return tempAsteroidTextures
    }
    
    //init the menu textures
    func initMenu() -> [SKTexture] {
        //get textures from the atlas
        var tempMenuTextures = [SKTexture]()
        let numImages = menuAtlas.textureNames.count
        for var i = 1; i <= numImages; i++ {                //put all the atlas images into array of textures
            tempMenuTextures.append(menuAtlas.textureNamed("menu\(i)"))
        }
        return tempMenuTextures
    }
    
}