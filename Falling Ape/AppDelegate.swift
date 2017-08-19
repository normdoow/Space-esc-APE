//
//  AppDelegate.swift
//  Falling Ape
//
//  Created by Noah Bragg on 4/30/15.
//  Copyright (c) 2015 NoahBragg. All rights reserved.
//

import UIKit
import GameKit
import Fabric
import Crashlytics
import SpriteKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //variables for textures
    //var monkeyTextures = [SKTexture]()                    //not using these anymore
    //var monkeyLeftTextures = [SKTexture]()
    var bananaFrames:[SKTexture]!
    var backgroundTextures:[SKTexture]!
    var smallAsteroidTextures:[SKTexture]!
    var mediumAsteroidTextures:[SKTexture]!
    var largeAsteroidTextures:[SKTexture]!
    var menuTextures:[SKTexture]!
    
    //pre load the textures
    func preLoadAllAssets() {
        let assets = Assets()   //make instance of the assets
        
        //let monkiesAtlas = SKTextureAtlas(named: "Monkies")
        //let monkiesAtlasLeft = SKTextureAtlas(named: "MonkiesLeft")
        let bananaAnimatedAtlas = SKTextureAtlas(named: "Banana")
        let asteroidAtlas1 = SKTextureAtlas(named: "SmallAsteroids")
        let asteroidAtlas2 = SKTextureAtlas(named: "MediumAsteroids")
        let asteroidAtlas3 = SKTextureAtlas(named: "LargeAsteroids")
        let menuAtlas = SKTextureAtlas(named: "Menu")

        SKTextureAtlas.preloadTextureAtlases([/*monkiesAtlas, monkiesAtlasLeft, */bananaAnimatedAtlas, asteroidAtlas1, asteroidAtlas2, asteroidAtlas3, menuAtlas], withCompletionHandler: {
                //initialize the different textures
                assets.initAtlases(/*monkiesAtlas, monkiesAtlasLeft: monkiesAtlasLeft,*/ bananaAnimatedAtlas, asteroidAtlas1: asteroidAtlas1, asteroidAtlas2: asteroidAtlas2, asteroidAtlas3: asteroidAtlas3, menuAtlas: menuAtlas)
                //self.monkeyTextures = assets.initMonkies()
                //self.monkeyLeftTextures = assets.initLeftMonkies()
                self.bananaFrames = assets.initBananaFrames()
                self.smallAsteroidTextures = assets.initSmallAsteroids()
                self.mediumAsteroidTextures = assets.initMediumAsteroids()
                self.largeAsteroidTextures = assets.initLargeAsteroids()
                self.menuTextures = assets.initMenu()
                print("Finished preloading textures")
            })
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        Fabric.with([Crashlytics()])
        
        //set up the assets
        preLoadAllAssets()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        //authenticate the player
        authenticateLocalPlayer()
        
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    //initiate gamecenter
    func authenticateLocalPlayer(){
        
        let localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            
            if (viewController != nil) {
                let VC = self.window?.rootViewController
                VC!.presentViewController(viewController!, animated: true, completion: nil)
            }
                
            else {
                print((GKLocalPlayer.localPlayer().authenticated))
            }
        }
        
    }
    
}

