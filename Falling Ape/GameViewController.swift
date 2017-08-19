//
//  GameViewController.swift
//  Falling Ape
//
//  Created by Noah Bragg on 4/30/15.
//  Copyright (c) 2015 NoahBragg. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit
import GoogleMobileAds

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            let sceneData = try! NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
            let archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController, GADInterstitialDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as! SKView
//            skView.showsFPS = true
//            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            scene.viewController = self
            skView.presentScene(scene)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "popUpTheAd", name: "NSNotificationCreate", object: nil)
        
        //init the ad
        self.initAd()
        
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.AllButUpsideDown
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    /********* Google Ad **********/
    /********* Google Ad **********/
    /********* Google Ad **********/
    /********* Google Ad **********/
    /********* Google Ad **********/
    
    var interstitial: GADInterstitial!
    
    func initAd() {
        //self.interstitial.delegate = self
        self.interstitial = self.createAndLoadAd()
    }
    
    @objc func popUpTheAd(/*rootViewController:UIViewController*/) {
        if(self.interstitial.isReady)
        {
            //stop background sound
            NSNotificationCenter.defaultCenter().postNotificationName("NSNotificationForSound", object: nil)
            self.interstitial.presentFromRootViewController(self)
            
        }
    }
    
    private func createAndLoadAd() -> GADInterstitial {
        let ad = GADInterstitial(adUnitID: "ca-app-pub-7240674847633441/2553248417")
        ad.delegate = self
        let request = GADRequest()
        
        //request.testDevices = ["3a3b4295c2011b1532642603c82ab3d8"]
        ad.loadRequest(request)
        
        return ad
    }
    
    func interstitialWillDismissScreen(ad: GADInterstitial!) {
        print("interstitialWillDismissScreen")
        
    }
    
    func interstitialDidDismissScreen(ad: GADInterstitial!) {
        //start background sound again
        NSNotificationCenter.defaultCenter().postNotificationName("NSNotificationForSoundStart", object: nil)
        print("interstitialDidDismissScreen")
        self.interstitial = self.createAndLoadAd()
    }
    
    func interstitialDidReceiveAd(ad: GADInterstitial!) {
        print("interstitialDidReceiveAd")
    }
    
    func interstitial(ad: GADInterstitial!, didFailToReceiveAdWithError error: GADRequestError!) {
        print("interstitialDidFailToReceiveAdWithError:\(error.localizedDescription)")
    }
}
