//
//  AppleAd.swift
//  Falling Ape
//
//  Created by Noah Bragg on 7/11/15.
//  Copyright (c) 2015 NoahBragg. All rights reserved.
//

import Foundation

//class AppleAd {
//    /************** iAd Methods **************/
//    /************** iAd Methods **************/
//    /************** iAd Methods **************/
//    /************** iAd Methods **************/
//    /************** iAd Methods **************/
//    
//    //create the close button for the iAd
//    func makeiAdCloseButton() {
//        self.closeButton.frame = CGRectMake(10, 10, 60, 60)
//        closeButton.layer.cornerRadius = 30
//        closeButton.setTitle("x", forState: .Normal)
//        closeButton.titleLabel!.font = UIFont(name: "AlNile", size: 48)
//        closeButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
//        closeButton.backgroundColor = UIColor.whiteColor()
//        closeButton.layer.borderColor = UIColor.blackColor().CGColor
//        closeButton.layer.borderWidth = 2
//        closeButton.addTarget(self, action: "close:", forControlEvents: UIControlEvents.TouchDown)
//    }
//    
//    //function that closes the ads
//    func close(sender: UIButton) {
//        
//        closeButton.removeFromSuperview()       //remove the close button first
//        self.showMenu()
//        self.yourDead = true
//        //animate the ad coming onto the screen
//        UIView.animateWithDuration(0.3,
//            animations: {
//                self.interAdView.frame.origin.y = self.frame.maxY
//            },
//            completion: { (value: Bool) in
//                self.interAdView.removeFromSuperview()
//        })
//        
//    }
//    
//    //starts the ad loading process
//    func loadAd() {
//        println("load ad")
//        interAd = ADInterstitialAd()
//        interAd.delegate = self
//    }
//    
//    //needed for interstitialAd
//    func interstitialAdDidLoad(interstitialAd: ADInterstitialAd!) {
//        println("ad did load")
//        
//        interAdView = UIView()
//        interAdView.frame = self.view!.bounds
//        interAdView.frame.origin.y = self.frame.maxY        //set it to the bottom
//        view!.addSubview(interAdView)
//        
//        //animate the ad coming onto the screen
//        UIView.animateWithDuration(0.3,
//            animations: {
//                self.interAdView.frame.origin.y = self.frame.origin.y
//            },
//            completion: { (value: Bool) in
//                self.interAdView.addSubview(self.closeButton)
//        })
//        interAd.presentInView(interAdView)
//        
//        UIViewController.prepareInterstitialAds()
//        
//        
//    }
//    
//    //needed for interstitialAd
//    func interstitialAdDidUnload(interstitialAd: ADInterstitialAd!) {
//        
//    }
//    
//    //if the add fails this is called
//    func interstitialAd(interstitialAd: ADInterstitialAd!, didFailWithError error: NSError!) {
//        println("failed to receive")
//        println(error.localizedDescription)
//        iAdCounter = 4      //set the iAd to 4 so it trys to load next time
//        
//        self.showMenu()     //hide the menu
//        self.yourDead = true
//        closeButton.removeFromSuperview()
//        interAdView.removeFromSuperview()
//        
//    }
//}