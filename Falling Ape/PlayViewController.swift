//
//  PlayViewController.swift
//  Falling Ape
//
//  Created by Noah Bragg on 6/28/15.
//  Copyright (c) 2015 NoahBragg. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit

class PlayViewController: UIViewController {
    
    var scene: PlayScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure the view.
        //let skView = view as! SKView
        let skView = SKView(frame: self.view.frame)
        self.view.addSubview(skView)
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        
        // Create and configure the scene.
        scene = PlayScene(size: skView.bounds.size)
        scene.scaleMode = .ResizeFill
        scene.viewController = self
        // Present the scene.
        skView.presentScene(scene)
        
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
}
