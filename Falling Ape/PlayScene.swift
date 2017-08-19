//
//  PlayScene.swift
//  Falling Ape
//
//  Created by Noah Bragg on 4/30/15.
//  Copyright (c) 2015 NoahBragg. All rights reserved.
//

import Foundation
import SpriteKit
import AudioToolbox
import GameKit
import Social
import StoreKit

class PlayScene: SKScene, SKPhysicsContactDelegate, GKGameCenterControllerDelegate {
    
    /************** Declaring Variables **************/
    /************** Declaring Variables **************/
    /************** Declaring Variables **************/
    /************** Declaring Variables **************/
    /************** Declaring Variables **************/
    
    var viewController: UIViewController?
    
    var ape = SKSpriteNode(imageNamed: "Ape")
    let shield = SKSpriteNode(imageNamed: "Shield")
    var banana = SKSpriteNode(imageNamed: "Banana")
    var backgroundStuff = SKSpriteNode(imageNamed: "LargeAsteroid")
    var asteroid = SKSpriteNode(imageNamed: "MediumAsteroid")
    var smallAsteroid = SKSpriteNode(imageNamed: "SmallAsteroid")
    var largeAsteroid = SKSpriteNode(imageNamed: "LargeAsteroid")
    let scoreText = SKLabelNode(fontNamed: "ArialHebrew-Bold")
    //var monkeyTextures = [SKTexture]()                    //took these out to fix the images so they weren't needed
    //var monkeyLeftTextures = [SKTexture]()
    var bananaFrames:[SKTexture]!
    var backgroundTextures:[SKTexture]!
    var smallAsteroidTextures:[SKTexture]!
    var mediumAsteroidTextures:[SKTexture]!
    var largeAsteroidTextures:[SKTexture]!
    var menuTextures:[SKTexture]!
    var emitterNode = SKEmitterNode(fileNamed: "FireEmitter.sks")
    var goingLeft = false
    var goingRight = false
    var shieldActivated = false
    var yourDead = false
    var isRedTheme = false
    var velocity = CGFloat(0)
    var sideGravity = CGFloat(0)
    var gravity = CGFloat(0)//CGFloat(16)//(UIScreen.mainScreen().bounds.size.height * (1/69)))       //about 15
    var tensCounter = 1
    var score = 0
    var totalBananas = 0
    var dumbCounterThingThatIDontNeed = 0
    
    //End Game Menu
    var gameMenu = SKSpriteNode(color: UIColor.grayColor(), size: CGSizeMake(UIScreen.mainScreen().bounds.size.width * 2/3, UIScreen.mainScreen().bounds.size.height / 2))
    var playAgainButton = SKSpriteNode(imageNamed: "PlayAgainButton")
    var gameCenterButton = SKSpriteNode(imageNamed: "GameCenterButton")
    var shareButton = SKSpriteNode(imageNamed: "GameCenterButton")
    var gearButton = SKSpriteNode(imageNamed: "GameCenterButton")
    var faceBookButton = SKSpriteNode(imageNamed: "GameCenterButton")
    var twitterButton = SKSpriteNode(imageNamed: "GameCenterButton")
    var soundButton = SKSpriteNode(imageNamed: "GameCenterButton")
    var vibrateButton = SKSpriteNode(imageNamed: "GameCenterButton")
    var characterSceneButton = SKSpriteNode()
    var highScoreLabel = SKLabelNode(fontNamed: "ArialHebrew-Bold")
    var scoreLabel = SKLabelNode(fontNamed: "ArialHebrew-Bold")
    var totalBananasLabel = SKLabelNode(fontNamed: "ArialHebrew-Bold")
    var screenShot = UIImage(named: "ApeRight")
    
    //character picker stuff
    var characterBackButton = SKSpriteNode()
    var monkies = [SKSpriteNode]()
    var removeAdsButt = SKSpriteNode()
    var restorePurchasesButt = SKSpriteNode()
    var selectButton = SKSpriteNode()
    var payWithNannersButt = SKSpriteNode()
    var panRecognizer = UIPanGestureRecognizer()
    var characterView = SKSpriteNode()
    var inCharacterPicker = false
    var characterNameLabel = SKLabelNode(fontNamed: "ArialHebrew-Bold")
    var characterPayLabel = SKLabelNode(fontNamed: "ArialHebrew-Bold")
    var characterNannerAmountLabel = SKLabelNode(fontNamed: "ArialHebrew-Bold")
    var characterHowManyLabel = SKLabelNode(fontNamed: "ArialHebrew-Bold")
    
    //tutorial
    var rightBlock = SKSpriteNode()
    var leftBlock = SKSpriteNode()
    var directionsLabel = SKLabelNode()
    var inTutorialLeft = false
    var inTutorialRight = false
    var inTutorial = false
    
    //iAD stuff
//    var interAd = ADInterstitialAd()
//    var interAdView: UIView = UIView()
//    var closeButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
    var iAdCounter = 0
    
    //backscreen
    let runningSky = SKSpriteNode(imageNamed: "blueAllSizesBackground")
    let runningSky2 = SKSpriteNode(imageNamed: "blueAllSizesBackground")
    
    //declare generator class
    private var generator = Generator()
    //declare saving class
    private var save = Save()
    //declare the Sound class
    private var sound = Sound()
    //declare inApp
    private var inApp = InApp()
    
    
    //declare array of characters
    var characters = [Character]()
    var currentCharacter = Character()
    
    //enum for the colliding bodies
    enum ColliderType:UInt32 {
        case Ape = 1
        case Asteroid = 2
        case Shield = 3
        case Banana = 4
    }
    
    /************** Move to View **************/
    /************** Move to View **************/
    /************** Move to View **************/
    /************** Move to View **************/
    /************** Move to View **************/
    
    //function called when moved to the view
    override func didMoveToView(view: SKView) {
        
        dumbCounterThingThatIDontNeed = 0
        score = 0
        
        //get instance of appDelegate
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //self.monkeyTextures = appDelegate.monkeyTextures
        //self.monkeyLeftTextures = appDelegate.monkeyLeftTextures
        self.bananaFrames = appDelegate.bananaFrames
        self.smallAsteroidTextures = appDelegate.smallAsteroidTextures
        self.mediumAsteroidTextures = appDelegate.mediumAsteroidTextures
        self.largeAsteroidTextures = appDelegate.largeAsteroidTextures
        self.menuTextures = appDelegate.menuTextures
        
        //create the characters
        characters = currentCharacter.initArrayOfCharacters(save.getCharactersUnlocked(), isActivatedArray: save.getCharactersActivated()/*, leftTextures: self.monkeyLeftTextures, middleTextures: self.monkeyTextures*/)
        for var k = 0; k < characters.count; k++ {      //set the current character
            if characters[k].getIsActivated() {
                currentCharacter = characters[k]
            }
        }
        
        //play some sounds!
        sound = Sound(soundIsOn: save.getSoundIsOn(), musicIsOn: true, scene: self)
        self.sound.playBackgroundSound()
        
        //initthe generator
        generator = Generator(small:smallAsteroid.size.width, medium: asteroid.size.width, large: largeAsteroid.size.width, f: self.frame)
        
        self.physicsWorld.contactDelegate = self
        //world gravity
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.gravity = initGravity()        //init the gravity
        
        //background anchorpoint stuff and positions
        self.runningSky.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        self.runningSky.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame))
        self.runningSky.zPosition = -10             //set the backgrounds to the far back
        self.runningSky2.zPosition = -10
        self.runningSky2.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        self.runningSky2.position = runningSky.position
        
        //ape position and physics stuff

        self.ape = SKSpriteNode(texture: currentCharacter.getMiddleTexture())
        self.scaleSprite(self.ape)
        self.ape.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) - self.frame.size.height / 12)
        self.ape.physicsBody = SKPhysicsBody(texture: self.ape.texture!, size: self.ape.size)
        self.ape.physicsBody?.dynamic = true
        self.ape.physicsBody?.usesPreciseCollisionDetection = true
        self.ape.physicsBody?.categoryBitMask = ColliderType.Ape.rawValue
        self.ape.physicsBody?.contactTestBitMask = ColliderType.Asteroid.rawValue
        self.ape.physicsBody?.collisionBitMask = ColliderType.Asteroid.rawValue
        //self.ape.zPosition = 1
        
        //add one large asteroid to get rid of lag
        asteroid = SKSpriteNode(texture: largeAsteroidTextures[0])
        self.scaleSprite(asteroid)          //scale the asteroid to the right size
        asteroid.name = "asteroid"
        asteroid.position = CGPointMake(-20000, 0)          //make sure its off the screen
        self.addChild(asteroid)
        
        //create the shield
        self.shield.position = CGPointMake(self.frame.maxX * 2, self.frame.maxY + self.ape.size.height * 10)
        self.shield.physicsBody = SKPhysicsBody(texture: self.shield.texture!, size: self.shield.size)
        self.shield.physicsBody?.dynamic = false
        self.shield.physicsBody?.mass = 800
        self.shield.physicsBody?.usesPreciseCollisionDetection = true
        self.shield.physicsBody?.categoryBitMask = ColliderType.Shield.rawValue            //use ape collider so we can see that its just the shield
        self.shield.physicsBody?.contactTestBitMask = ColliderType.Asteroid.rawValue
        self.shield.physicsBody?.collisionBitMask = ColliderType.Asteroid.rawValue
        self.shield.hidden = true
        
        
        if save.getHighScore() == 0 {
            runTutorial()
        } else {
            initAsteroidsAndOtherThings()
        }
        
        //sets how many launches the app has done
        setNumLaunches()
    
        //add the nodes to the scene
        self.addChild(runningSky)
        self.addChild(runningSky2)
        self.addChild(scoreText)
        self.addChild(ape)
        //self.addChild(shield)
        
        //scale the background down so it fits all screens
        let scaleBy = self.frame.height / 2211  //this is the size of the image
        self.runningSky.runAction(SKAction.scaleTo(scaleBy, duration: 0))
        self.runningSky2.runAction(SKAction.scaleTo(scaleBy, duration: 0))
        
    }
    
    func getRealTexture(currTex:SKTexture) -> SKTexture {
        let tex1 = SKTexture(imageNamed: "monkey1.png")
        let tex7 = SKTexture(imageNamed: "monkey7.png")
        if currTex == tex1 {
            return tex1
        } else if currTex == tex7 {
            return tex7
        }
        print("didn't match with anything")
        return tex1
    }
    
    func initAsteroidsAndOtherThings() {
        //Add the Score text
        self.scoreText.text = "0"
        self.scoreText.fontSize = self.frame.size.width / 5
        self.scoreText.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame) + (scoreText.fontSize * 1/5))
        self.scoreText.zPosition = 50       //make it the very top
        
        var duration = 0.0
        print(self.frame.width)
        if self.frame.width > 750 {        //set the duration depending on ipad or iphone
            duration = 0.2
            
        } else if self.frame.width < 700 {
            duration = 0.19
        }
        
        let randomlyAddAsteroids = SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock({self.addAsteroid();}),
            SKAction.waitForDuration(duration, withRange: 0.0)
            ]))
        //add asteroids randomly
        self.runAction(randomlyAddAsteroids)         //starts out being hidden
        
        //add background stuff
        addBackgroundStuff()                    //adds background stuff to the scene
    }
    
    /************** Tutorial **************/
    /************** Tutorial **************/
    /************** Tutorial **************/
    /************** Tutorial **************/
    /************** Tutorial **************/
    
    func runTutorial() {
        inTutorial = true
        let leftSide = SKAction.sequence([SKAction.waitForDuration(1),
                                            SKAction.runBlock({self.createLeftBlock()})
                                        ])
        self.runAction(leftSide)
    }
    
    func createLeftBlock() {
        leftBlock = SKSpriteNode(color: UIColor.whiteColor(), size: CGSizeMake(self.frame.width / 2, self.frame.height))
        leftBlock.position = CGPointMake(self.frame.midX / 2, self.frame.midY)
        leftBlock.alpha = 0.2
        self.addChild(leftBlock)
        
        //create label to tell directions
        directionsLabel = SKLabelNode(fontNamed: "ArialHebrew-Bold")
        directionsLabel.fontSize = self.frame.size.width / 14
        directionsLabel.text = "tap / hold"
        directionsLabel.position = CGPointMake(self.frame.midX - self.frame.size.width / 4, self.frame.midY)
        self.addChild(directionsLabel)
        
        inTutorialLeft = true       //in left block now
    }
    
    //creates the left block
    func runTutorialNextPart() {
        directionsLabel.hidden = true
        leftBlock.removeFromParent()
        let rightSide = SKAction.sequence([SKAction.waitForDuration(1),
                                            SKAction.runBlock({self.createRightBlock()})
                                        ])
        self.runAction(rightSide)
    }
    
    //creates the right block
    func createRightBlock() {
        rightBlock = SKSpriteNode(color: UIColor.whiteColor(), size: CGSizeMake(self.frame.width / 2, self.frame.height))
        rightBlock.position = CGPointMake(self.frame.midX + self.frame.size.width / 4, self.frame.midY)
        rightBlock.alpha = 0.2
        self.addChild(rightBlock)
        
        //move directions label to the other side
        directionsLabel.position = CGPointMake(self.frame.midX + self.frame.size.width / 4, self.frame.midY)
        directionsLabel.hidden = false
        inTutorialRight = true      //in right block now
    }
    
    //instructions of how to play the game
    func finishTutorial() {
        directionsLabel.removeFromParent()
        rightBlock.removeFromParent()
        let directions = SKLabelNode(fontNamed: "ArialHebrew-Bold")
        directions.position = CGPointMake(self.frame.midX, self.frame.midY)
        directions.fontSize = self.frame.size.width / 12
        directions.text = "Alrighty!"
        let instructions = SKAction.sequence([
                            SKAction.waitForDuration(1),
                            SKAction.runBlock({
                                self.addChild(directions)
                            }),
                            SKAction.waitForDuration(2),
                            SKAction.runBlock({
                                directions.hidden = true
                            }),
                            SKAction.waitForDuration(0.5),
                            SKAction.runBlock({
                                directions.hidden = false
                                directions.text = "Get them Nanners!"
                            }),
                            SKAction.waitForDuration(2),
                            SKAction.runBlock({
                                directions.hidden = true
                            }),
                            SKAction.waitForDuration(0.5),
                            SKAction.runBlock({
                                directions.hidden = false
                                directions.text = "and Esc-APE Space!"
                            }),
                            SKAction.waitForDuration(2),
                            SKAction.runBlock({
                                directions.removeFromParent()
                            }),
                            SKAction.waitForDuration(0.5),
                            SKAction.runBlock({
                                self.inTutorial = false
                                self.initAsteroidsAndOtherThings()
                            }),
                        ])
        self.runAction(instructions)
    }
    
    /************** Add Asteroids **************/
    /************** Add Asteroids **************/
    /************** Add Asteroids **************/
    /************** Add Asteroids **************/
    /************** Add Asteroids **************/
    
    //initializing Asteroids
    func addAsteroid() {
        //set the score
        generator.setScore(score)
        //generate the sequence
        generator.makeSequence()
        //if the banana counter is over 10, add a banana
        if generator.getBananaCounter() > 4 {
            self.addBanana()
            generator.setBananaCounter(0)
        }
        for var k = 0; k < generator.getGeneratedXPoints().count; k++ {
            //set the correct asteroid size
            if generator.getSizeOfAsteroid() == "medium" {
                var rand = 0
                if isRedTheme {                     //pick asteroid based on theme
                    rand = randomNumFrom(2, end: 3)
                } else {
                    rand = randomNumFrom(0, end: 1)
                }
                asteroid = SKSpriteNode(texture: mediumAsteroidTextures[rand])
                self.scaleSprite(asteroid)          //scale the asteroid to the right size
                asteroid.name = "asteroid"
            } else if generator.getSizeOfAsteroid() == "small" {
                var rand = 0
                if isRedTheme {                     //pick asteroid based on theme
                    rand = randomNumFrom(2, end: 3)
                } else {
                    rand = randomNumFrom(0, end: 1)
                }
                asteroid = SKSpriteNode(texture: smallAsteroidTextures[rand])
                self.scaleSprite(asteroid)          //scale the asteroid to the right size
                asteroid.name = "smallAsteroid"
            } else {
                var rand = 0
                if isRedTheme {                     //pick asteroid based on theme
                    rand = randomNumFrom(2, end: 3)
                } else {
                    rand = randomNumFrom(0, end: 1)
                }
                asteroid = SKSpriteNode(texture: largeAsteroidTextures[rand])
                self.scaleSprite(asteroid)          //scale the asteroid to the right size
                asteroid.name = "asteroid"
            }
            var yPoint = generator.getYPoints()[0]
            if k == 1 && generator.getYPoints().count > 1 {
                yPoint = generator.getYPoints()[1]
            }
            //add the position
            asteroid.position = CGPointMake(generator.getGeneratedXPoints()[k], yPoint)
            //physics body stuff
            asteroid.physicsBody = SKPhysicsBody(circleOfRadius: asteroid.size.width / 2)
            asteroid.physicsBody!.mass = 300
            asteroid.physicsBody?.dynamic = true
            self.asteroid.physicsBody?.usesPreciseCollisionDetection = true
            self.asteroid.physicsBody?.categoryBitMask = ColliderType.Asteroid.rawValue
            self.asteroid.physicsBody?.contactTestBitMask = ColliderType.Ape.rawValue
            self.asteroid.physicsBody?.collisionBitMask = ColliderType.Ape.rawValue
            //self.asteroid.zPosition = 1
            addRotation(asteroid)
//            if asteroid.name == "asteroid" {
//                addAsteroidEmitter(CGPointMake(asteroid.position.x, asteroid.position.y + 20))
//            }
            
            self.addChild(asteroid)
        }
    }
    
    func addRotation(asteroid:SKSpriteNode) {
        
        var rotate:SKAction                                 //init test
        var angle:Double
        let rand = Int(arc4random_uniform(2))               //random 0 or 1
        if rand == 0 {                                      //choose which direction to rotate
            angle = -M_PI_4
        } else {
            angle = M_PI_4
        }
        //make the asteroid rotate depending on the size and angle
        if generator.getSizeOfAsteroid() == "small" {
            rotate = SKAction.repeatActionForever(SKAction.rotateByAngle(CGFloat(angle), duration: randomDoubleBetween(0.2, high: 0.4)))
        } else if generator.getSizeOfAsteroid() == "medium" {
            rotate = SKAction.repeatActionForever(SKAction.rotateByAngle(CGFloat(angle), duration: randomDoubleBetween(0.6, high: 1.1)))
        } else {
            rotate = SKAction.repeatActionForever(SKAction.rotateByAngle(CGFloat(angle), duration: randomDoubleBetween(1.6, high: 2.3)))
        }

        asteroid.runAction(rotate)
    }
    
//    func addAsteroidEmitter(pos: CGPoint) {
//        emitterNode = SKEmitterNode(fileNamed: "FireEmitter.sks")
//        emitterNode.particlePosition = pos
//        emitterNode.name = "emitternode"
//        emitterNode.zPosition = 5
//        self.addChild(emitterNode)
//        // Don't forget to remove the emitter node after the explosion
//        //self.runAction(SKAction.waitForDuration(2), completion: { emitterNode.removeFromParent() })
//    }
    
    //add a banana to the screen
    func addBanana() {
        generator.generateBanana()
        self.banana = SKSpriteNode(imageNamed: "Banana")
        self.banana.position = CGPointMake(generator.getBananaXPoint(), generator.getYPoints()[0])
        self.banana.physicsBody = SKPhysicsBody(texture: banana.texture!, size: banana.size)
        self.banana.physicsBody!.mass = 300
        self.banana.physicsBody?.dynamic = true
        self.banana.physicsBody?.usesPreciseCollisionDetection = true
        self.banana.name = "Banana"
        self.banana.physicsBody?.categoryBitMask = ColliderType.Banana.rawValue
        self.banana.physicsBody?.contactTestBitMask = ColliderType.Ape.rawValue
        self.banana.physicsBody?.collisionBitMask = ColliderType.Ape.rawValue
        self.addBananaRotation()
        self.addChild(banana)
    }
    
    //adds vertical rotation to the banana
    func addBananaRotation() {
        let scaleBy = (self.frame.width / 20) / self.banana.frame.width
        banana.runAction(SKAction.scaleTo(scaleBy, duration: 0))
        banana.runAction(SKAction.repeatActionForever(
            SKAction.animateWithTextures(bananaFrames,
                timePerFrame: 0.04,
                resize: false,
                restore: true)),
            withKey:"bananaIsAnimated")
    }
    
    /************** Add background stuff **************/
    /************** Add background stuff **************/
    /************** Add background stuff **************/
    /************** Add background stuff **************/
    /************** Add background stuff **************/
    
    private func addBackgroundStuff() {
        //this code runs at the beginning
        let backgroundAtlas = SKTextureAtlas(named: "BackgroundAssets")
        var tempBackgroundAtlas = [SKTexture]()
        let numImages = backgroundAtlas.textureNames.count
        for var i = 1; i <= numImages; i++ {                //put all the atlas images into array of textures
            tempBackgroundAtlas.append(backgroundAtlas.textureNamed("object\(i)"))
        }
        backgroundTextures = tempBackgroundAtlas
        
        let randomlyAddBackgroundStuff = SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock({
                    let rand = self.randomNumFrom(UInt32(0), end: UInt32(self.backgroundTextures.count - 1))
                    self.backgroundStuff = SKSpriteNode(texture: self.backgroundTextures[rand])
                    let scaleBy = self.frame.width / 1536   //scale by iPad version which imags are made for
                    self.backgroundStuff.runAction(SKAction.scaleTo(scaleBy, duration: 0))
                    self.backgroundStuff.position = CGPointMake(CGFloat(arc4random()) % self.frame.size.width, self.frame.minY - self.backgroundStuff.frame.height * 1.5)
                    self.backgroundStuff.zPosition = -5
                    self.backgroundStuff.name = "BackgroundStuff"
                    self.backgroundStuff.color = UIColor.blackColor()           //to give it a background color feel
                    self.backgroundStuff.colorBlendFactor = 0.6
                    self.addChild(self.backgroundStuff)
                }),
                SKAction.waitForDuration(5, withRange: 4)
            ]))
        
        self.runAction(randomlyAddBackgroundStuff)
    }
    
    /************** touching **************/
    /************** touching **************/
    /************** touching **************/
    /************** touching **************/
    /************** touching **************/
    
    //when touches begin
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !yourDead && !inTutorial {
            //check for how many fingers are touching
            if event!.allTouches()?.count > 1 {
                self.shield.position = CGPointMake(self.ape.position.x, self.ape.position.y - self.ape.size.height / 1.5)
                self.shield.hidden = false
                self.shieldActivated = true
                //change image
                self.ape.runAction(SKAction.setTexture(currentCharacter.getMiddleTexture(), resize: true))
                
                if goingLeft {
                    self.sideGravity = self.view!.bounds.size.height * (1/1138)     //about 0.9
                    print(self.view!.bounds.size.height * (1/1138))
                } else if goingRight {
                    self.sideGravity = -self.view!.bounds.size.height * (1/1138)    //about -0.9
                }
            
            } else {
                for touch:AnyObject in touches {
                    let location = touch.locationInNode(self)
                
                    //see what side of the screen the touch came from
                    if location.x < CGRectGetMidX(self.frame) {
                        //ape.physicsBody?.applyImpulse(CGVectorMake(-300, 0))
                        self.goingLeft = true                   //set things
                        self.goingRight = false
                        self.velocity = initVelocity()//self.view!.bounds.size.height * (1/73)   //14
                        self.sideGravity = 0
                        let changeTexture = SKAction.setTexture(currentCharacter.getLeftTexture(), resize: true)
                        self.ape.runAction(changeTexture)
                        self.ape.xScale = abs(ape.xScale)
                        self.ape.zRotation = CGFloat(M_PI_4 / 4)
                    } else {
                        //ape.physicsBody?.applyImpulse(CGVectorMake(300, 0))
                        self.goingRight = true
                        self.goingLeft = false
                        self.velocity = -initVelocity()//-self.view!.bounds.size.height * (1/73)  //-14
                        self.sideGravity = 0
                        let changeTexture = SKAction.setTexture(currentCharacter.getLeftTexture(), resize: true)
                        self.ape.runAction(changeTexture)
                        self.ape.xScale = ape.xScale * -1                      //flip the monkey
                        self.ape.zRotation = CGFloat(-M_PI_4 / 4)
                    }
                
                }
            }
        } else if inTutorial {                  //for going left and right in the tutorial
            for touch:AnyObject in touches {
                let location = touch.locationInNode(self)
                //see what side of the screen the touch came from
                if location.x < CGRectGetMidX(self.frame) && inTutorialLeft {
                    //ape.physicsBody?.applyImpulse(CGVectorMake(-300, 0))
                    self.goingLeft = true                   //set things
                    self.goingRight = false
                    self.velocity = initVelocity()//self.view!.bounds.size.height * (1/73)   //14
                    self.sideGravity = 0
                    let changeTexture = SKAction.setTexture(currentCharacter.getLeftTexture(), resize: true)
                    self.ape.runAction(changeTexture)
                    self.ape.xScale = abs(ape.xScale)
                    self.ape.zRotation = CGFloat(M_PI_4 / 4)
                    
                    inTutorialLeft = false
                    self.runTutorialNextPart()           //next part of tutorial
                    
                } else if location.x > CGRectGetMidX(self.frame) && inTutorialRight {
                    //ape.physicsBody?.applyImpulse(CGVectorMake(300, 0))
                    self.goingRight = true
                    self.goingLeft = false
                    self.velocity = -initVelocity()//-self.view!.bounds.size.height * (1/73)  //-14
                    self.sideGravity = 0
                    let changeTexture = SKAction.setTexture(currentCharacter.getLeftTexture(), resize: true)
                    self.ape.runAction(changeTexture)
                    self.ape.xScale = ape.xScale * -1                      //flip the monkey
                    self.ape.zRotation = CGFloat(-M_PI_4 / 4)
                    
                    inTutorialRight = false
                    self.finishTutorial()               //finish the tutorial
                }
                
            }
            
        } else {    //you are dead and in the menu screen
            for touch:AnyObject in touches {
                let location = touch.locationInNode(self)
                if self.nodeAtPoint(location) == self.playAgainButton {
                    sound.buttonDown()          //make button sound
                    self.playAgainButton.color = UIColor.blackColor()
                    self.playAgainButton.colorBlendFactor = 0.5
                } else if self.nodeAtPoint(location) == self.gameCenterButton {
                    sound.buttonDown()          //make button sound
                    //pull up the leaderboards
                    self.gameCenterButton.color = UIColor.blackColor()
                    self.gameCenterButton.colorBlendFactor = 0.5
                } else if self.nodeAtPoint(location) == self.characterSceneButton {
                    sound.buttonDown()          //make button sound
                    self.characterSceneButton.color = UIColor.blackColor()
                    self.characterSceneButton.colorBlendFactor = 0.5
                } else if self.nodeAtPoint(location) == self.characterBackButton {
                    sound.buttonDown()          //make button sound
                    self.characterBackButton.color = UIColor.blackColor()
                    self.characterBackButton.colorBlendFactor = 0.5
                } else if self.nodeAtPoint(location) == self.shareButton {
                    sound.buttonDown()          //make button sound
                    self.shareButton.color = UIColor.blackColor()
                    self.shareButton.colorBlendFactor = 0.5
                } else if self.nodeAtPoint(location) == self.faceBookButton {
                    sound.buttonDown()          //make button sound
                    self.faceBookButton.color = UIColor.blackColor()
                    self.faceBookButton.colorBlendFactor = 0.5
                } else if self.nodeAtPoint(location) == self.twitterButton {
                    sound.buttonDown()          //make button sound
                    self.twitterButton.color = UIColor.blackColor()
                    self.twitterButton.colorBlendFactor = 0.5
                } else if self.nodeAtPoint(location) == self.gearButton {
                    sound.buttonDown()          //make button sound
                    self.gearButton.color = UIColor.blackColor()
                    self.gearButton.colorBlendFactor = 0.5
                } else if self.nodeAtPoint(location) == self.soundButton {
                    sound.buttonDown()          //make button sound
                    self.soundButton.color = UIColor.blackColor()
                    self.soundButton.colorBlendFactor = 0.5
                } else if self.nodeAtPoint(location) == self.vibrateButton {
                    sound.buttonDown()          //make button sound
                    self.vibrateButton.color = UIColor.blackColor()
                    self.vibrateButton.colorBlendFactor = 0.5
                } else if self.nodeAtPoint(location) == self.restorePurchasesButt {
                    sound.buttonDown()          //make button sound
                    self.restorePurchasesButt.color = UIColor.blackColor()
                    self.restorePurchasesButt.colorBlendFactor = 0.5
                } else if self.nodeAtPoint(location) == self.removeAdsButt {
                    sound.buttonDown()          //make button sound
                    self.removeAdsButt.color = UIColor.blackColor()
                    self.removeAdsButt.colorBlendFactor = 0.5
                } else if self.nodeAtPoint(location) == self.selectButton || self.nodeAtPoint(location) == self.characterPayLabel {
                    sound.buttonDown()          //make button sound
                    self.selectButton.color = UIColor.blackColor()
                    self.selectButton.colorBlendFactor = 0.5
                } else if self.nodeAtPoint(location) == self.payWithNannersButt || self.nodeAtPoint(location) == self.characterNannerAmountLabel {
                    sound.buttonDown()          //make button sound
                    self.payWithNannersButt.color = UIColor.blackColor()
                    self.payWithNannersButt.colorBlendFactor = 0.5
                }
                
            }
        }
        
    }
    
    //when touches end
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !yourDead {
            if event!.allTouches()?.count > 1 {
                self.shield.position = CGPointMake(self.frame.maxX * 2, self.frame.maxY + self.ape.size.height * 10)
                self.shield.hidden = true
                self.shieldActivated = false
                
            } else {
                for touch:AnyObject in touches {
                    let location = touch.locationInNode(self)
                    //see what side the touch is from
                    if location.x < CGRectGetMidX(self.frame) {
                        //ape.physicsBody?.velocity = CGVectorMake(-10, 0)
                        self.sideGravity = self.view!.bounds.size.height * (1/1138)
                    } else {
                        //ape.physicsBody?.velocity = CGVectorMake(10, 0)
                        self.sideGravity = -self.view!.bounds.size.height * (1/1138)
                    }
                }
                //change image and move for the new height
                self.ape.runAction(SKAction.setTexture(currentCharacter.getMiddleTexture(), resize: true))
                self.ape.xScale = abs(ape.xScale)
                self.ape.zRotation = 0
            }
        } else {                //in the menu
            for touch:AnyObject in touches {
                let location = touch.locationInNode(self)
                if self.nodeAtPoint(location) == self.playAgainButton {
                    sound.buttonUp()    //make the sound
                    self.resetTheGame()
                } else if self.nodeAtPoint(location) == self.gameCenterButton {
                    sound.buttonUp()    //make the sound
                    //pull up the leaderboards
                    showLeaderBoard()
                } else if self.nodeAtPoint(location) == self.characterSceneButton {
                    sound.buttonUp()    //make the sound
                    self.animateMenuSlideOut()
                    self.goToCharacterPickScene()        //go to the picker scene
                } else if self.nodeAtPoint(location) == self.characterBackButton {
                    sound.buttonUp()    //make the sound
                    for var k = 0; k < monkies.count; k++ {
                        if monkies[k].position.x == UIScreen.mainScreen().bounds.midX {
                            if self.characters[k].getIsUnlocked() {   //only if it is unlocked
                                save.saveCharacterActivatedAt(k, isActivated: true)
                            }
                        }
                    }
                    //reset characters
                    self.characters = currentCharacter.initArrayOfCharacters(save.getCharactersUnlocked(), isActivatedArray: save.getCharactersActivated()/*, leftTextures: monkeyLeftTextures, middleTextures: monkeyTextures*/)
                    for var k = 0; k < characters.count; k++ {      //set the current character
                        if characters[k].getIsActivated() {
                            currentCharacter = characters[k]
                        }
                    }
                    //call end transactions
                    NSNotificationCenter.defaultCenter().postNotificationName("NSNotificationInAppListen", object: nil);
                    self.removeCharacterPicker()
                } else if self.nodeAtPoint(location) == self.shareButton {
                    sound.buttonUp()    //make the sound
                    if faceBookButton.position == shareButton.position {
                        self.animateSocialButtonsOut()
                    } else {
                        self.animateSocialButtonsIn()
                    }
                } else if self.nodeAtPoint(location) == self.faceBookButton {
                    sound.buttonUp()    //make the sound
                    self.postToFacebook()
                } else if self.nodeAtPoint(location) == self.twitterButton {
                    sound.buttonUp()    //make the sound
                    self.tweetToTwitter()
                } else if self.nodeAtPoint(location) == self.gearButton {
                    sound.buttonUp()    //make the sound
                    if soundButton.position == gearButton.position {
                        self.animateGearButtonsOut()
                    } else {
                        self.animateGearButtonsIn()
                    }
                } else if self.nodeAtPoint(location) == self.soundButton {
                    sound.buttonUp()    //make the sound
                    if soundButton.texture == menuTextures[12] {                            //turn sound off
                        soundButton.texture = menuTextures[13]
                        sound.stopBackgroundSound()
                        save.saveSoundIsOn(false)
                        sound.setSoundIsOn(false)
                    } else {                                                                //turn sound on
                        soundButton.texture = menuTextures[12]
                        save.saveSoundIsOn(true)
                        sound.setSoundIsOn(true)
                        sound.playBackgroundSound()
                    }
                } else if self.nodeAtPoint(location) == self.vibrateButton {
                    sound.buttonUp()    //make the sound
                    if vibrateButton.texture == menuTextures[14] {                          //turn vibrate off
                        vibrateButton.texture = menuTextures[15]
                        save.saveVibrateIsOn(false)
                    } else {                                                                //turn vibrate on
                        vibrateButton.texture = menuTextures[14]
                        save.saveVibrateIsOn(true)
                    }
                } else if self.nodeAtPoint(location) == self.restorePurchasesButt {         //restore purchases
                    sound.buttonUp()    //make the sound
                    inApp.restorePurchases()        //goes in inApp and restores the purchases
                } else if self.nodeAtPoint(location) == self.removeAdsButt {                //remove ads
                    sound.buttonUp()    //make the sound
                   inApp.buyProductWithIndex(monkies.count - 3, scene: self)    //monkies.count should get the ad that is appended onto the array
                } else if (self.nodeAtPoint(location) == self.selectButton || self.nodeAtPoint(location) == self.characterPayLabel) && (self.selectButton.hidden == false) { //buy with money
                    sound.buttonUp()    //make the sound
                    if monkies[1].position.x == self.frame.midX {           //share with facebook
                        self.postToFacebook2()
                    } else if monkies[2].position.x == self.frame.midX {    //follow on twitter
                        self.followOnTwitter()
                    } else if monkies[monkies.count - 1].position.x == self.frame.midX {    //unlock all
                        inApp.buyProductWithIndex(monkies.count - 4, scene: self)   //monkies.count - 1
                    } else {   //pay with money
                        for var k = 3; k < monkies.count; k++ {
                            if monkies[k].position.x == self.frame.midX {
                                inApp.buyProductWithIndex(k - 3, scene: self)   // - 3 because first 3 monkeys can't be purchased
                            }
                        }
                    }
                    
                } else if (self.nodeAtPoint(location) == self.payWithNannersButt || self.nodeAtPoint(location) == self.characterNannerAmountLabel) && (payWithNannersButt.hidden == false && characterNannerAmountLabel.hidden == false) {      //buy with nanners
                    sound.buttonUp()    //make the sound
                    for var k = 0; k < monkies.count; k++ {
                        if monkies[k].position.x == self.frame.midX {
                            if !self.characters[k].getIsUnlocked() {            //if not already unlocked
                                if totalBananas > characters[k].getBananaPrice() {      //if you have enough nanners
                                    characters[k].setIsUnlocked(true)
                                    totalBananas -= characters[k].getBananaPrice()
                                    save.saveTotalBananas(totalBananas)
                                    self.characterHowManyLabel.text = "You have \(totalBananas)🍌"
                                    //get all characters that are unlocked
                                    var tempCharactersUnlocked = [Bool]()
                                    for var k = 0; k < characters.count; k++ {
                                        tempCharactersUnlocked.append(characters[k].getIsUnlocked())
                                    }
                                    //save the characters that are unlocked
                                    save.saveCharactersUnlocked(tempCharactersUnlocked)
                                    monkies[k].colorBlendFactor = 0.0           //make monkey blend 0.0
                                    //hide bottom buttons
                                    self.payWithNannersButt.hidden = true
                                    self.selectButton.hidden = true
                                    self.characterNannerAmountLabel.hidden = true
                                    self.characterPayLabel.hidden = true
                                } else {                        //you don't have enough nanners
                                    //show alert that they don't have enough
                                    let alert = UIAlertController(title: "You Want more 🍌?", message: "You don't have enough Nanners!", preferredStyle: UIAlertControllerStyle.Alert)
                                    alert.addAction(UIAlertAction(title: "Ahh Stink!", style: UIAlertActionStyle.Default, handler: { alertAction in
                                        alert.dismissViewControllerAnimated(true, completion: nil)
                                    }))
                                    let vc = self.view?.window?.rootViewController          //get the root view controller
                                    vc!.presentViewController(alert, animated: true, completion: nil)
                                    
                                }
                            }
                        }
                    }
                }
                
            }
            //make sure no buttons are black
            self.playAgainButton.colorBlendFactor = 0.0
            self.gameCenterButton.colorBlendFactor = 0.0
            self.characterSceneButton.colorBlendFactor = 0.0
            self.characterBackButton.colorBlendFactor = 0.0
            self.shareButton.colorBlendFactor = 0.0
            self.faceBookButton.colorBlendFactor = 0.0
            self.twitterButton.colorBlendFactor = 0.0
            self.gearButton.colorBlendFactor = 0.0
            self.soundButton.colorBlendFactor = 0.0
            self.vibrateButton.colorBlendFactor = 0.0
            self.restorePurchasesButt.colorBlendFactor = 0.0
            self.removeAdsButt.colorBlendFactor = 0.0
            self.selectButton.colorBlendFactor = 0.0
            self.payWithNannersButt.colorBlendFactor = 0.0
        }
    }
    
    /************** Update **************/
    /************** Update **************/
    /************** Update **************/
    /************** Update **************/
    /************** Update **************/
    
    
    override func update(currentTime: NSTimeInterval) {
        
        if (self.velocity > 1 || self.velocity < -1) {
            
            //if going left and ape's position is not hitting the left of screen
            if goingLeft && ape.position.x > UIScreen.mainScreen().bounds.minX + ape.size.width / 1.9{//UIScreen.mainScreen().bounds.width / 20 {//CGRectGetMinX(self.frame) + ape.size.width / 1.9 {
                if self.velocity != 0 {     //so you only move if you have velocity fixed a problem with the shield
                    self.velocity -= self.sideGravity
                    ape.position.x -= self.velocity
                }
            } else if goingRight && ape.position.x < UIScreen.mainScreen().bounds.maxX - UIScreen.mainScreen().bounds.width / 10 {//CGRectGetMaxX(self.frame) - ape.size.width / 1.9 {
                if self.velocity != 0 {     //so you only move if you have velocity
                    self.velocity -= self.sideGravity
                    ape.position.x -= self.velocity
                }
            }
            if shieldActivated {
                //moves the shield to the correct location
                self.shield.position = CGPointMake(self.ape.position.x, self.ape.position.y - self.ape.size.height / 1.5)
            }
        }
        
        //move the first background
        runningSky.position = CGPointMake(runningSky.position.x, runningSky.position.y + (self.view!.bounds.size.height * (1/170))) //adds by about 6
        runningSky2.position = CGPointMake(runningSky.position.x, runningSky.position.y + (self.view!.bounds.size.height * (1/170)))    //adds by about 6
        
        if runningSky.position.y > CGRectGetMaxY(self.frame) {
            //if the picture goes away
            self.runningSky.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame))
            self.runningSky2.position = self.runningSky.position
        }
        
        //if in the character picker
        if inCharacterPicker {
            let fifth = self.frame.size.width / 5
            for var k = 0; k < monkies.count; k++ {
                if monkies[k].frame.size.width < fifth + 10 && (monkies[k].position.x > self.frame.midX - fifth / 4 && monkies[k].position.x < self.frame.midX + fifth / 4) {
                    monkies[k].runAction(SKAction.scaleBy(1.1, duration: 0.1))
                    monkies[k].zPosition = 120
                } else if monkies[k].frame.size.width > fifth && (monkies[k].position.x < self.frame.midX - fifth / 4 || monkies[k].position.x > self.frame.midX + fifth / 4) {
                    monkies[k].runAction(SKAction.scaleBy(0.96, duration: 0.1))
                    monkies[k].zPosition = 101
                }
            }
            //go through monkies and see if there isn't one in the middel
            
        }
        
        //move the background stuff up the screen
        enumerateChildNodesWithName("BackgroundStuff", usingBlock: {(node: SKNode, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
            //move the asteroids off the screen
            node.position.y += self.view!.bounds.size.height * (1/125)      //about how fast it should move
            //if it is out of screen
            if self.backgroundStuff.position.y > self.frame.maxY + self.backgroundStuff.frame.height * 2 {
                self.backgroundStuff.removeFromParent()         //remove from screen
            }
        })
        
        //take Asteroids off the screen and increment score for larger asteroids
        enumerateChildNodesWithName("asteroid", usingBlock: {(node: SKNode, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
            //move the asteroids off the screen
            node.position = CGPointMake(node.position.x, node.position.y + self.gravity)
            
            //if it is out of screen
            if node.position.y > self.frame.size.height + self.largeAsteroid.size.width {
                node.removeFromParent()
            }
        })
        
        //take small asteroids off the screen and increment score for small Asteroids
        enumerateChildNodesWithName("smallAsteroid", usingBlock: {(node: SKNode, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
            //move the asteroids up the screen
            node.position = CGPointMake(node.position.x, node.position.y + self.gravity)
            //if it is out of screen
            if node.position.y > self.frame.size.height + self.largeAsteroid.size.width {
                node.removeFromParent()
            }
        })
        
        enumerateChildNodesWithName("Banana", usingBlock: {(node: SKNode, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
            //move the banana up the screen
            node.position = CGPointMake(node.position.x, node.position.y + self.gravity)
            if node.position.y > self.frame.size.height + self.largeAsteroid.size.width {
                node.removeFromParent()
            }

        })
        
        self.enumerateChildNodesWithName("emitternode", usingBlock: {(emitter: SKNode, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
            emitter.position.y += self.gravity
            if emitter.position.y > self.frame.size.height + self.largeAsteroid.size.width {
                self.runAction(SKAction.waitForDuration(0), completion: { emitter.removeFromParent() })
            }
        })
        
    }
    
    /************** Contact **************/
    /************** Contact **************/
    /************** Contact **************/
    /************** Contact **************/
    /************** Contact **************/
    
    func didBeginContact(contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == ColliderType.Shield.rawValue || contact.bodyB.categoryBitMask == ColliderType.Shield.rawValue) {
            
            //I don't like how this codes works but not sure what else is best
            var asteroidCount = 0
            //if the asteroid is a big asteroid
            enumerateChildNodesWithName("asteroid", usingBlock: {(node: SKNode, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
                if node == contact.bodyA.node || node == contact.bodyB.node {
                    asteroidCount++
                }
                
            })
            if asteroidCount > 0 {
                if dumbCounterThingThatIDontNeed == 0 {
                    deathAnimation()         //death from big Asteroid hitting shield
                    dumbCounterThingThatIDontNeed++
                }
            } else {
                //delete the correct small asteroid that was hit
                enumerateChildNodesWithName("smallAsteroid", usingBlock: {(node: SKNode, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
                    if node == contact.bodyA.node || node == contact.bodyB.node {
                        node.removeFromParent()
                    }
                })
            }
                    
        } else if(contact.bodyA.categoryBitMask == ColliderType.Banana.rawValue || contact.bodyB.categoryBitMask == ColliderType.Banana.rawValue) && (contact.bodyA.categoryBitMask == ColliderType.Ape.rawValue || contact.bodyB.categoryBitMask == ColliderType.Ape.rawValue) {
            //delete the correct banana that was hit
            enumerateChildNodesWithName("Banana", usingBlock: {(node: SKNode, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
                if node == contact.bodyA.node || node == contact.bodyB.node {
                    self.sound.gotNannerSound()          //play the got nanner sound
                    node.removeFromParent()
                    if !self.yourDead {
                        self.score++
                        self.generator.setScore(self.score)
                        self.scoreText.text = String(self.score)
                    }
                }
            })
        
        }else {
            if dumbCounterThingThatIDontNeed == 0 {
                deathAnimation()        //also runs moveToGameOverView
                dumbCounterThingThatIDontNeed++
            }
        }

    }
    
    /************** Reset Game and Death **************/
    /************** Reset Game and Death **************/
    /************** Reset Game and Death **************/
    /************** Reset Game and Death **************/
    /************** Reset Game and Death **************/
    
    //function for the animation of the Ape's death
    func deathAnimation() {
        //virabte the phones only for death
        if save.getVibrateIsOn() {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        //death sound
        sound.playDeathSound(currentCharacter)
        sound.hitAsteroid()
        //set shield for death
        self.yourDead = true
        self.shield.position = CGPointMake(self.frame.maxX * 2, self.frame.maxY + self.ape.size.height * 10)
        self.shield.hidden = true
        self.shieldActivated = false
        //set Ape image to default
        self.ape.runAction(SKAction.setTexture(currentCharacter.getMiddleTexture(), resize: true))
        self.ape.zRotation = 0
        //changes physicsBody values so He doesn't collide
        self.ape.physicsBody?.dynamic = false
        self.ape.physicsBody?.categoryBitMask = ColliderType.Asteroid.rawValue
        self.ape.physicsBody?.contactTestBitMask = ColliderType.Ape.rawValue
        self.ape.physicsBody?.collisionBitMask = ColliderType.Ape.rawValue
        self.ape.zPosition = 10     //bring the ape to the front
        //shake everything
        shake()
        let death = SKAction.sequence([
                            SKAction.group([
                                    SKAction.scaleBy(4, duration: 0.5),
                                    //SKAction.runBlock({self.screenShot = self.view?.takeSnapshot()}),
                                    SKAction.moveTo(CGPointMake(UIScreen.mainScreen().bounds.width * 1/4, UIScreen.mainScreen().bounds.minY - UIScreen.mainScreen().bounds.height * 1/5), duration: 2),
                                    SKAction.repeatAction(SKAction.rotateByAngle(CGFloat(M_PI_4), duration: 0.2), count: 8)
                                ]),
                            SKAction.runBlock({self.showMessage();})
                        ])
        ape.runAction(death)        //run the animation sequence
        //self.runAction(SKAction.sequence([SKAction.waitForDuration(1), SKAction.runBlock({self.screenShot = self.view?.takeSnapshot()})]))
    }
    
    func shake() {
        //go through all nodes and shake them
        enumerateChildNodesWithName("//*", usingBlock: {(node: SKNode, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
            node.runAction(SKAction.shake(0.3, amplitudeX: self.frame.width / 20, amplitudeY: self.frame.width / 80))
        })
    }
    
    func showMessage() {
        if self.score > save.getHighScore() {       //new high score
            let highScoreLabel = SKLabelNode(fontNamed: "ArialHebrew-Bold")
            highScoreLabel.text = "New HighScore!"
            highScoreLabel.fontSize = self.frame.width / 10
            highScoreLabel.position = CGPointMake(self.frame.midX, self.frame.midY)
            highScoreLabel.zPosition = 100
            self.addChild(highScoreLabel)
            let labelAction = SKAction.sequence([SKAction.waitForDuration(1.4), SKAction.runBlock({highScoreLabel.removeFromParent();
                                                                                self.moveToGameOverView();})])
            self.runAction(labelAction)
            sound.highScore()
            
        } else {
            self.moveToGameOverView()
        }
    }
    
    //function for ending the game
    func moveToGameOverView() {
        
        initGameOverMenu()      //brings up the game over menu
        
        //hide the ussual score text
        self.scoreText.hidden = true
        
        //save if highscore
        if score > save.getHighScore() {
            save.saveHighScore(score)
            //save to game center
            self.saveHighscoreToGameCenter(save.getHighScore())
        }
        //set the high score label
        self.highScoreLabel.text = String(save.getHighScore())
        
        //save and set the totalBanans
        self.totalBananas = save.getTotalBananas() + score
        save.saveTotalBananas(totalBananas)
        self.totalBananasLabel.text = String(self.totalBananas)
        
        //set the score label
        self.scoreLabel.text = String(self.score)
        
        //increment to know how many times till next ad
        iAdCounter++
        
        //add the ad to the view
        if iAdCounter > randomNumFrom(3, end: 4) {
            if save.getAdsAreOn() {         //if ads are not turned off
                NSNotificationCenter.defaultCenter().postNotificationName("NSNotificationCreate", object: nil);
            }
            iAdCounter = 0
        } else {
            if score > 10 {
                rateMe()
            }
        }
    
    }
    
    //function that resets the whole game
    func resetTheGame() {
        //remove all asteroids from the screen
        enumerateChildNodesWithName("asteroid", usingBlock: {(node: SKNode, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
            node.removeFromParent()
        })
        enumerateChildNodesWithName("smallAsteroid", usingBlock: {(node: SKNode, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
            node.removeFromParent()
        })
        enumerateChildNodesWithName("Banana", usingBlock: {(node: SKNode, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
            node.removeFromParent()
        })
        self.enumerateChildNodesWithName("emitternode", usingBlock: {(emitter: SKNode, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
            self.runAction(SKAction.waitForDuration(0), completion: { emitter.removeFromParent() })
        })
        //set stuff back to normal for the ape
        self.ape.removeFromParent()
        self.ape = SKSpriteNode(texture: currentCharacter.getMiddleTexture())
        self.scaleSprite(self.ape)
        self.ape.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) - self.frame.size.height / 12)
        self.ape.physicsBody = SKPhysicsBody(texture: self.ape.texture!, size: self.ape.size)
        self.ape.physicsBody?.dynamic = true
        self.ape.physicsBody?.usesPreciseCollisionDetection = true
        self.ape.physicsBody?.categoryBitMask = ColliderType.Ape.rawValue
        self.ape.physicsBody?.contactTestBitMask = ColliderType.Asteroid.rawValue
        self.ape.physicsBody?.collisionBitMask = ColliderType.Asteroid.rawValue
        
        //move shield back to starting location
        self.shield.position = CGPointMake(self.frame.maxX * 2, self.frame.maxY + self.ape.size.height * 10)
        self.shield.hidden = true
        self.shieldActivated = false
        
        //change colors of the background
        let rand = randomNumFrom(0, end: 1)
        if rand == 0 {
            isRedTheme = false
            self.runningSky.runAction(SKAction.setTexture(SKTexture(imageNamed: "blueAllSizesBackground"), resize: false))
            self.runningSky2.runAction(SKAction.setTexture(SKTexture(imageNamed: "blueAllSizesBackground"), resize: false))
            self.runningSky.colorBlendFactor = 0.0
            self.runningSky2.colorBlendFactor = 0.0
        } else {
            isRedTheme = true
            self.runningSky.runAction(SKAction.setTexture(SKTexture(imageNamed: "redAllSizesBackground"), resize: false))
            self.runningSky2.runAction(SKAction.setTexture(SKTexture(imageNamed: "redAllSizesBackground"), resize: false))
            self.runningSky.color = UIColor.blackColor()
            self.runningSky2.color = UIColor.blackColor()
            self.runningSky.colorBlendFactor = 0.5
            self.runningSky2.colorBlendFactor = 0.5
        }
        
        //remove the main menu
        self.gameMenu.removeFromParent()
        
        self.scoreText.hidden = false       //show the actual score label
        
        //reset the score
        self.scoreText.text = "0"
        self.score = 0
        self.goingLeft = false
        self.goingRight = false
        self.velocity = CGFloat(0)
        self.sideGravity = CGFloat(0)
        //self.gravity = CGFloat(16)//(UIScreen.mainScreen().bounds.size.height * (1/74)))       //about 19 for 69
        self.gravity = initGravity()        //init the gravity
        self.tensCounter = 1
        self.dumbCounterThingThatIDontNeed = 0
        
        //you are not dead
        self.yourDead = false
        
        //reset the generator
        generator.resetGenerator()
        
        self.addChild(ape)
    }
    
    func initGameOverMenu(){
        //set the gameMenu
        self.gameMenu = SKSpriteNode(texture: menuTextures[0])
        self.gameMenu.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.gameMenu.position = CGPointMake(self.frame.midX, self.frame.midY - self.frame.size.height * 2)
        self.gameMenu.zPosition = 15        //bring the view to the front
        self.addChild(gameMenu)
        
        //set the play button
        self.playAgainButton = SKSpriteNode(texture: menuTextures[5])
        self.playAgainButton.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        self.playAgainButton.position = CGPointMake(0, -self.gameMenu.frame.height / 2 + playAgainButton.size.height / 8)
        
        //set the shareButton
        self.shareButton = SKSpriteNode(texture: menuTextures[1])
        self.shareButton.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        self.shareButton.position = CGPointMake(-gameMenu.frame.size.width / 2 + playAgainButton.size.height / 8, playAgainButton.frame.origin.y + playAgainButton.frame.size.height + playAgainButton.size.height / 10)
        
        //set the Game Center Button
        self.gameCenterButton = SKSpriteNode(texture: menuTextures[3])
        self.gameCenterButton.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        self.gameCenterButton.position = CGPointMake(shareButton.position.x + gameCenterButton.frame.size.width * 2 + playAgainButton.size.height / 7.5, shareButton.position.y)
        
        //set the characters Button
        self.characterSceneButton = SKSpriteNode(texture: menuTextures[2])
        self.characterSceneButton.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        self.characterSceneButton.position = CGPointMake(shareButton.position.x + characterSceneButton.frame.size.width + playAgainButton.size.height / 15, shareButton.position.y)
        
        //set the gear button
        self.gearButton = SKSpriteNode(texture: menuTextures[4])
        self.gearButton.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        self.gearButton.position = CGPointMake(characterSceneButton.position.x + characterSceneButton.frame.size.width * 2 + playAgainButton.size.height / 7.5, shareButton.position.y)
        
        //set facebook button
        self.faceBookButton = SKSpriteNode(texture: menuTextures[6])
        self.faceBookButton.anchorPoint = CGPointMake(0.0, 0.0)
        self.faceBookButton.position = shareButton.position
        
        //set twitter button
        self.twitterButton = SKSpriteNode(texture: menuTextures[7])
        self.twitterButton.anchorPoint = CGPointMake(0.0, 0.0)
        self.twitterButton.position = shareButton.position
        
        //set sound button
        self.soundButton = SKSpriteNode(texture: menuTextures[12])
        if !save.getSoundIsOn() {                       //change texture if not on
            self.soundButton.texture = menuTextures[13]
        }
        self.soundButton.anchorPoint = CGPointMake(0.0, 0.0)
        self.soundButton.position = gearButton.position
        
        //set vibrate button
        self.vibrateButton = SKSpriteNode(texture: menuTextures[14])
        if !save.getVibrateIsOn() {                     //change texture if not on
            self.vibrateButton.texture = menuTextures[15]
        }
        self.vibrateButton.anchorPoint = CGPointMake(0.0, 0.0)
        self.vibrateButton.position = gearButton.position
        
        //set up high score label
        self.highScoreLabel.position = CGPointMake(gameMenu.frame.size.width * 1/4.4, gameCenterButton.frame.size.height * 2)
        self.highScoreLabel.fontSize = self.shareButton.size.width / 2            //make the font size based on screen size
        self.highScoreLabel.zPosition = 101
        
        //set up score label
        self.scoreLabel.position = CGPointMake(gameMenu.frame.size.width * 1/4, gameCenterButton.frame.size.height / 2)
        self.scoreLabel.fontSize = self.shareButton.size.width
        self.scoreLabel.zPosition = 101
        
        //set up score label
        self.totalBananasLabel.position = CGPointMake(-gameMenu.frame.size.width * 1/4.4, gameCenterButton.frame.size.height * 2)
        self.totalBananasLabel.fontSize = self.shareButton.size.width / 2
        self.totalBananasLabel.zPosition = 105
        
        self.gameMenu.addChild(faceBookButton)
        self.gameMenu.addChild(twitterButton)
        self.gameMenu.addChild(soundButton)
        self.gameMenu.addChild(vibrateButton)
        self.gameMenu.addChild(playAgainButton)
        self.gameMenu.addChild(shareButton)
        self.gameMenu.addChild(gearButton)
        self.gameMenu.addChild(gameCenterButton)
        self.gameMenu.addChild(characterSceneButton)
        self.gameMenu.addChild(highScoreLabel)
        self.gameMenu.addChild(scoreLabel)
        self.gameMenu.addChild(totalBananasLabel)
        
        //shrink stuff
        self.scaleSpritePlus(self.gameMenu)
        animateMenuSlideIn()
    
    }
    
    func animateMenuSlideIn() {
        let slideIn = SKAction.moveToY(self.frame.midY, duration: 0.3)
        self.gameMenu.runAction(slideIn)
    }
    
    func animateMenuSlideOut() {
        let slideIn = SKAction.moveToY(self.frame.midY - self.frame.height * 2, duration: 0.3)
        self.gameMenu.runAction(slideIn)
    }
    
    /************** Go to Character Scene **************/
    /************** Go to Character Scene **************/
    /************** Go to Character Scene **************/
    /************** Go to Character Scene **************/
    /************** Go to Character Scene **************/
    
    func goToCharacterPickScene() {
        
        //so we know we are in characterPicker
        inCharacterPicker = true
        
        //add observers for purchasing
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "unlockStuffForPurchase", name: "NSNotificationForInApp", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "unlockAllPurchases", name: "NSNotificationUnlockAll", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "unlockAds", name: "NSNotificationNoAds", object: nil)
        
        //init the store incase they want to buy
        inApp = InApp()     //recreate it everytime
        inApp.initStoreKit(characters)
        
        characterView = SKSpriteNode(color: UIColor.whiteColor(), size: self.frame.size)
        characterView.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        characterView.position = CGPointMake(0,self.frame.minY)
        characterView.alpha = 0.7
        characterView.zPosition = 100
        
        //make a pan gesture
        self.panRecognizer = UIPanGestureRecognizer(target: self, action: "panGesture:")
        self.view!.addGestureRecognizer(panRecognizer)
        
        //set up buttons
        characterBackButton = SKSpriteNode(texture: menuTextures[8])
        characterBackButton.position = CGPointMake(self.frame.size.width * (1/6), self.frame.size.height * (17/18) - self.frame.size.height)
        characterBackButton.zPosition = 101
        
        restorePurchasesButt = SKSpriteNode(texture: menuTextures[9])
        restorePurchasesButt.position = CGPointMake(self.frame.midX, characterBackButton.position.y - self.frame.height / 12.2)
        restorePurchasesButt.zPosition = 101
        
        removeAdsButt = SKSpriteNode(texture: menuTextures[10])
        removeAdsButt.position = CGPointMake(self.frame.midX, restorePurchasesButt.position.y - self.frame.height / 12.2)
        removeAdsButt.zPosition = 101
        if !save.getAdsAreOn() {
            removeAdsButt.hidden = true
        }
        
        selectButton = SKSpriteNode(texture: menuTextures[11])
        selectButton.position = CGPointMake(self.frame.midX, self.frame.minX + self.frame.height / 12.2 - self.frame.size.height)
        selectButton.zPosition = 101
        
        payWithNannersButt = SKSpriteNode(texture: menuTextures[11])
        payWithNannersButt.position = CGPointMake(self.frame.midX, self.selectButton.position.y + self.frame.height / 12.2)
        payWithNannersButt.zPosition = 101
        
        characterNameLabel = SKLabelNode(fontNamed: "ArialHebrew-Bold")
        characterNameLabel.fontColor = UIColor.blackColor()
        characterNameLabel.fontSize = self.shareButton.size.width / 7
        let yPosition = ((removeAdsButt.position.y + self.frame.size.height) - self.frame.midY) / 2 + self.frame.midY
        characterNameLabel.position = CGPointMake(self.frame.midX, yPosition - self.frame.size.height - removeAdsButt.frame.size.height / 22)
        characterNameLabel.zPosition = 101
        characterNameLabel.text = currentCharacter.getName()
        
        characterHowManyLabel = SKLabelNode(fontNamed: "ArialHebrew-Bold")
        characterHowManyLabel.fontColor = UIColor.blackColor()
        characterHowManyLabel.fontSize = self.shareButton.size.width / 7
        let yPosition2 = (self.frame.midY  - (payWithNannersButt.position.y + self.frame.size.height)) / 2 + payWithNannersButt.position.y + self.frame.size.height
        characterHowManyLabel.position = CGPointMake(self.frame.midX, yPosition2 - self.frame.size.height - removeAdsButt.frame.size.height / 22)
        characterHowManyLabel.zPosition = 101
        characterHowManyLabel.text = "You have \(totalBananas)🍌"
        
        characterNannerAmountLabel = SKLabelNode(fontNamed: "ArialHebrew-Bold")
        characterNannerAmountLabel.fontColor = UIColor.blackColor()
        characterNannerAmountLabel.fontSize = payWithNannersButt.frame.size.height / 8
        characterNannerAmountLabel.position = payWithNannersButt.position
        characterNannerAmountLabel.position.y -= removeAdsButt.frame.size.height / 22
        characterNannerAmountLabel.zPosition = 102
        characterNannerAmountLabel.text = "\(currentCharacter.getBananaPrice())🍌"
        
        characterPayLabel = SKLabelNode(fontNamed: "ArialHebrew-Bold")
        characterPayLabel.fontColor = UIColor.blackColor()
        characterPayLabel.fontSize = payWithNannersButt.frame.size.height / 8
        characterPayLabel.position = selectButton.position
        characterPayLabel.position.y -= removeAdsButt.frame.size.height / 22
        characterPayLabel.zPosition = 102
        characterPayLabel.text = "$0.99"
        
        //add stuff to the view
        self.addChild(characterView)
        self.addChild(characterBackButton)
        self.addChild(restorePurchasesButt)
        self.addChild(removeAdsButt)
        self.addChild(selectButton)
        self.addChild(payWithNannersButt)
        self.addChild(characterNameLabel)
        self.addChild(characterHowManyLabel)
        self.addChild(characterNannerAmountLabel)
        self.addChild(characterPayLabel)
        
        if self.frame.size.width < 750 {
            //shrink all the button stuff to correct size
            self.scaleSprite(characterBackButton)
            self.scaleSprite(restorePurchasesButt)
            self.scaleSprite(removeAdsButt)
            self.scaleSprite(selectButton)
            self.scaleSprite(payWithNannersButt)
        } else {                //for the iPad to scale down even more
            self.scaleExtraForIpad(characterBackButton)
            self.scaleExtraForIpad(restorePurchasesButt)
            self.scaleExtraForIpad(removeAdsButt)
            self.scaleExtraForIpad(selectButton)
            self.scaleExtraForIpad(payWithNannersButt)
        }
        
        //init monkies
        initMonkies(characterView)
        
        //slide all the different things up
        self.characterView.runAction(SKAction.moveTo(CGPointMake(0, self.frame.maxY), duration: 0.2))
        self.characterBackButton.runAction(SKAction.moveTo(CGPointMake(characterBackButton.position.x, characterBackButton.position.y + self.frame.size.height), duration: 0.2))
        self.restorePurchasesButt.runAction(SKAction.moveTo(CGPointMake(restorePurchasesButt.position.x, restorePurchasesButt.position.y + self.frame.size.height), duration: 0.2))
        self.removeAdsButt.runAction(SKAction.moveTo(CGPointMake(removeAdsButt.position.x, removeAdsButt.position.y + self.frame.size.height), duration: 0.2))
        self.selectButton.runAction(SKAction.moveTo(CGPointMake(selectButton.position.x, selectButton.position.y + self.frame.size.height), duration: 0.2))
        self.payWithNannersButt.runAction(SKAction.moveTo(CGPointMake(payWithNannersButt.position.x, payWithNannersButt.position.y + self.frame.size.height), duration: 0.2))
        self.characterNameLabel.runAction(SKAction.moveTo(CGPointMake(characterNameLabel.position.x, characterNameLabel.position.y + self.frame.size.height), duration: 0.2))
        self.characterHowManyLabel.runAction(SKAction.moveTo(CGPointMake(characterHowManyLabel.position.x, characterHowManyLabel.position.y + self.frame.size.height), duration: 0.2))
        self.characterPayLabel.runAction(SKAction.moveTo(CGPointMake(characterPayLabel.position.x, characterPayLabel.position.y + self.frame.size.height), duration: 0.2))
        self.characterNannerAmountLabel.runAction(SKAction.moveTo(CGPointMake(characterNannerAmountLabel.position.x, characterNannerAmountLabel.position.y + self.frame.size.height), duration: 0.2))
        
        //slide monkies up
        for var k = 0; k < monkies.count; k++ {
            monkies[k].runAction(SKAction.moveTo(CGPointMake(monkies[k].position.x, monkies[k].position.y + self.frame.size.height), duration: 0.2))
        }
        self.runAction(SKAction.sequence([SKAction.waitForDuration(0.2), SKAction.runBlock({self.sound.selectScreen()})]))
        
    }
    
    func initMonkies(characterView:SKSpriteNode) {
        //add the textures to sprites then add to the screen
        
        //figure out if all monkies are unlocked
        var allMonkiesUnlocked = true
        for var k = 0; k < self.characters.count /*self.monkeyTextures.count*/; k++ {
            if !characters[k].getIsUnlocked() {
                allMonkiesUnlocked = false
            }
        }
        
        //var count:CGFloat = 0     //wasn't using this
        for var k = 0; k < self.characters.count /*self.monkeyTextures.count*/; k++ {
            self.monkies.append(SKSpriteNode(texture: self.characters[k].getMiddleTexture()))
            self.scaleSprite(self.monkies[k])
            self.monkies[k].anchorPoint = CGPoint(x: 0.5, y: 0.5)
            self.monkies[k].position = CGPointMake(self.frame.midX + (self.frame.size.width / 5) * CGFloat(k), self.frame.midY - self.frame.size.height)
            self.monkies[k].zPosition = 101
            self.monkies[k].name = "monkey"
            if !characters[k].getIsUnlocked() {         //if not unlocked
                monkies[k].color = UIColor.blackColor()
                monkies[k].colorBlendFactor = 0.5
            }
            if k == characters.count - 1 {      //if unlock monkey don't shade it
                monkies[k].colorBlendFactor = 0.0
            }
            if !(k == characters.count - 1 && allMonkiesUnlocked) {
                self.addChild(self.monkies[k])
            }
            
        }
        
        moveMonkiesToActivatedOne()
    }
    
    func moveMonkiesToActivatedOne() {
        //set the monkies on the correct one chosen
        var currentIndex = -1
        for var k = 0; k < characters.count; k++ {
            if currentCharacter.getName() == characters[k].getName() {        //find the index for the currentCharacter
                currentIndex = k
            }
        }
        if currentIndex != -1 {
            for var k = 0; k < self.monkies.count; k++ {
                monkies[k].position = CGPointMake(monkies[k].position.x - (self.frame.size.width / 5) * CGFloat(currentIndex), monkies[k].position.y)
            }
        }
        //hide bottom buttons cause they won't be shown first time
        self.characterNannerAmountLabel.hidden = true
        self.characterPayLabel.hidden = true
        self.selectButton.hidden = true
        self.payWithNannersButt.hidden = true

    }
    
    //remove all the character stuff
    func removeCharacterPicker() {
        inCharacterPicker = false
        
        //remove observers
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "NSNotificationForInApp", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "NSNotificationUnlockAll", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "NSNotificationNoAds", object: nil)
        
        //slide everything down
        characterView.runAction(SKAction.moveTo(CGPointMake(0, self.frame.minY), duration: 0.2))
        characterBackButton.runAction(SKAction.moveTo(CGPointMake(characterBackButton.position.x, characterBackButton.position.y - self.frame.size.height), duration: 0.2))
        self.restorePurchasesButt.runAction(SKAction.moveTo(CGPointMake(restorePurchasesButt.position.x, restorePurchasesButt.position.y - self.frame.size.height), duration: 0.2))
        self.removeAdsButt.runAction(SKAction.moveTo(CGPointMake(removeAdsButt.position.x, removeAdsButt.position.y - self.frame.size.height), duration: 0.2))
        self.selectButton.runAction(SKAction.moveTo(CGPointMake(selectButton.position.x, selectButton.position.y - self.frame.size.height), duration: 0.2))
        self.payWithNannersButt.runAction(SKAction.moveTo(CGPointMake(payWithNannersButt.position.x, payWithNannersButt.position.y - self.frame.size.height), duration: 0.2))
        self.payWithNannersButt.runAction(SKAction.moveTo(CGPointMake(payWithNannersButt.position.x, payWithNannersButt.position.y - self.frame.size.height), duration: 0.2))
        self.characterNameLabel.runAction(SKAction.moveTo(CGPointMake(characterNameLabel.position.x, characterNameLabel.position.y - self.frame.size.height), duration: 0.2))
        self.characterHowManyLabel.runAction(SKAction.moveTo(CGPointMake(characterHowManyLabel.position.x, characterHowManyLabel.position.y - self.frame.size.height), duration: 0.2))
        self.characterPayLabel.runAction(SKAction.moveTo(CGPointMake(characterPayLabel.position.x, characterPayLabel.position.y - self.frame.size.height), duration: 0.2))
        self.characterNannerAmountLabel.runAction(SKAction.moveTo(CGPointMake(characterNannerAmountLabel.position.x, characterNannerAmountLabel.position.y - self.frame.size.height), duration: 0.2))
        
        //slide monkies down
        for var k = 0; k < monkies.count; k++ {
            monkies[k].runAction(SKAction.moveTo(CGPointMake(monkies[k].position.x, monkies[k].position.y - self.frame.size.height), duration: 0.2))
        }
        
        //delete the things
        let deleteStuff = SKAction.sequence([SKAction.waitForDuration(0.2), SKAction.runBlock({self.deleteCharacterStuff()})])
        self.view?.removeGestureRecognizer(panRecognizer)       //remove the pan recognizer
        self.runAction(deleteStuff)
    }
    
    //delete all the character stuff
    func deleteCharacterStuff() {
        self.animateMenuSlideIn()
        self.characterView.removeFromParent();
        self.characterBackButton.removeFromParent()
        self.restorePurchasesButt.removeFromParent()
        self.removeAdsButt.removeFromParent()
        self.selectButton.removeFromParent()
        self.payWithNannersButt.removeFromParent()
        self.characterNameLabel.removeFromParent()
        self.characterHowManyLabel.removeFromParent()
        self.characterNannerAmountLabel.removeFromParent()
        self.characterPayLabel.removeFromParent()
        for var k = 0; k < monkies.count; k++ {
            monkies[k].removeFromParent()
        }
        //make the monkey array empty
        monkies = []
    }
    
    func panGesture(recognizer: UIPanGestureRecognizer) {
        //var location = recognizer.locationInView(recognizer.view)     //wasn't using it
        
        if recognizer.state == UIGestureRecognizerState.Cancelled {
            print("you canceled")
        } else if recognizer.state == UIGestureRecognizerState.Failed {
            print("it failed!")
        } else if recognizer.state == UIGestureRecognizerState.Changed {   //when changed
            for var k = 0; k < monkies.count; k++ {
                monkies[k].removeAllActions()
            }
            
            //figure out if all monkies are unlocked
            var allMonkiesUnlocked = true
            for var k = 0; k < self.characters.count; k++ {
                if !characters[k].getIsUnlocked() {
                    allMonkiesUnlocked = false
                }
            }
            var includedMonkies = characters.count - 1
            if allMonkiesUnlocked {
                includedMonkies = characters.count - 2
            }
            
            let translation = recognizer.translationInView(recognizer.view!)
            var finalXPoint = self.monkies[0].position.x + translation.x
            finalXPoint = min(max(finalXPoint, (self.view!.bounds.size.width / 2) - self.frame.size.width / 5 * CGFloat(includedMonkies)), self.view!.bounds.size.width / 2);
            for var k = 0; k < monkies.count; k++ {
                //move all the monkies
                var tempFinalXPoint = finalXPoint
                tempFinalXPoint += ((self.frame.size.width / 5) * CGFloat(k))
                self.monkies[k].position.x = tempFinalXPoint
                //change the monkies size
                let fifth = self.frame.size.width / 5
                if monkies[k].frame.size.width < fifth + 10 && monkies[k].position.x > fifth * 2 && monkies[k].position.x < fifth * 3 {
                    monkies[k].runAction(SKAction.scaleBy(1.1, duration: 0.1))
                    monkies[k].zPosition = 102
                } else if monkies[k].frame.size.width > fifth && (monkies[k].position.x < fifth * 2 || monkies[k].position.x > fifth * 3) {
                    monkies[k].runAction(SKAction.scaleBy(0.96, duration: 0.1))
                    monkies[k].zPosition = 101
                }
            }
            
            recognizer.setTranslation(CGPointMake(0, 0), inView: self.view)
        } else if recognizer.state == UIGestureRecognizerState.Ended {      //when ended for velocity
            
            let velocity = recognizer.velocityInView(self.view)
            let magnitude = sqrt(velocity.x * velocity.x)
            let slideMult = magnitude / 1800
            let slideFactor = 0.1 * slideMult
            var duration = sqrt(slideFactor * slideFactor) * 2
            var finalPoint = CGPointMake(monkies[0].position.x + (velocity.x * slideFactor), 0)
            let tempFinal = finalPoint.x
            
            //move the monkey to the middle spot
            let fifth = self.frame.size.width / 5
            var start = self.frame.midX + (-fifth * CGFloat(monkies.count - 1))
            var closest = start
            
            var next = start + fifth
            while start < finalPoint.x {
                start = next
                next += fifth
                if next > finalPoint.x {
                    closest = start
                }
            }
            
            //figure out if all monkies are unlocked
            var allMonkiesUnlocked = true
            for var k = 0; k < self.characters.count; k++ {
                if !characters[k].getIsUnlocked() {
                    allMonkiesUnlocked = false
                }
            }
            var includedMonkies = characters.count - 1
            if allMonkiesUnlocked {
                includedMonkies = characters.count - 2
            }
            
            finalPoint.x = closest
            finalPoint.x = min(max(finalPoint.x, (self.view!.bounds.size.width / 2) - fifth * CGFloat(includedMonkies)), self.view!.bounds.size.width / 2);
            
            duration = duration * finalPoint.x / tempFinal          //changes the time if it ends up getting stopped half way
            if duration < 0.1 { //make it so there is minimu duration
                duration = 0.2
            }
            let slide = SKAction.moveToX(finalPoint.x, duration: NSTimeInterval(duration))
            slide.timingMode = SKActionTimingMode.EaseOut
            
            for var k = 0; k < includedMonkies + 1; k++ {   // +1 cause we need to include unlock monkey
                //move all the monkies
                var tempFinalXPoint = finalPoint.x
                tempFinalXPoint += (self.frame.size.width / 5) * CGFloat(k)
                let slide = SKAction.moveToX(tempFinalXPoint, duration: NSTimeInterval(duration))
                slide.timingMode = SKActionTimingMode.EaseOut
                
                monkies[k].runAction(slide)
            }
            self.runAction(SKAction.sequence(([SKAction.waitForDuration(NSTimeInterval(duration)), SKAction.runBlock({ self.setCharacterLables() })])))
            
        }
    }
    
    func setCharacterLables() {
        //get the label info
        var indexForMonkey = -1
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        for var k = 0; k < monkies.count; k++ {
            if monkies[k].position.x > (screenWidth / 2) - 15 && monkies[k].position.x  < (screenWidth / 2) + 15 {
                indexForMonkey = k
            }
        }
        if indexForMonkey != -1 {
            self.characterNameLabel.text = self.characters[indexForMonkey].getName()
            self.characterNannerAmountLabel.text = "\(characters[indexForMonkey].getBananaPrice())🍌"
            if !characters[indexForMonkey].getIsUnlocked() {        //if not unlocked show lables
                //show bottom buttons cause they won't be shown first time
                self.characterNannerAmountLabel.hidden = false
                self.characterPayLabel.hidden = false
                self.selectButton.hidden = false
                self.payWithNannersButt.hidden = false
                self.characterPayLabel.text = "$0.99"
                
                self.selectButton.texture = menuTextures[11]        //set back to nothing
                if indexForMonkey == 1 {            //share for facebook
                    self.payWithNannersButt.hidden = true
                    self.characterNannerAmountLabel.hidden = true
                    self.characterPayLabel.hidden = true
                    self.selectButton.texture = menuTextures[16]
                } else if indexForMonkey == 2 {     //share for twitter
                    self.payWithNannersButt.hidden = true
                    self.characterNannerAmountLabel.hidden = true
                    self.characterPayLabel.hidden = true
                    self.selectButton.texture = menuTextures[17]
                } else if indexForMonkey == monkies.count - 1 {          //if its unlock all monkey
                    self.payWithNannersButt.hidden = true
                    self.characterNannerAmountLabel.hidden = true
                    self.characterPayLabel.text = "$2.99"
                }
            } else {
                //hide bottom buttons cause they won't be shown first time
                self.characterNannerAmountLabel.hidden = true
                self.characterPayLabel.hidden = true
                self.selectButton.hidden = true
                self.payWithNannersButt.hidden = true
            }
        }
    }
    
    
    /*********** unlock ***********/
    /*********** unlock ***********/
    /*********** unlock ***********/
    /*********** unlock ***********/
    /*********** unlock ***********/
    
    func unlockStuffForPurchase() {
        for var k = 3; k < monkies.count - 1; k++ {
            print("k is \(k) and count is \(inApp.productsToUnlock.count)")
            if inApp.productsToUnlock.count > k - 3 && inApp.productsToUnlock[k - 3] == true {
                //unlock the stuff
                characters[k].setIsUnlocked(true)
                //get all characters that are unlocked
                var tempCharactersUnlocked = [Bool]()
                for var k = 0; k < characters.count; k++ {
                    tempCharactersUnlocked.append(characters[k].getIsUnlocked())
                }
                //save the characters that are unlocked
                save.saveCharactersUnlocked(tempCharactersUnlocked)
                monkies[k].colorBlendFactor = 0.0           //make monkey blend 0.0
                //hide bottom buttons
                self.payWithNannersButt.hidden = true
                self.selectButton.hidden = true
                self.characterNannerAmountLabel.hidden = true
                self.characterPayLabel.hidden = true
            }
        }
    }
    
    func unlockAllPurchases() {
        for var k = 0; k < monkies.count; k++ {
            //unlock the stuff
            characters[k].setIsUnlocked(true)
            //get all characters that are unlocked
            monkies[k].colorBlendFactor = 0.0           //make monkey blend 0.0
        }
        var tempCharactersUnlocked = [Bool]()
        for var k = 0; k < characters.count; k++ {
            tempCharactersUnlocked.append(characters[k].getIsUnlocked())
        }
        //save all the characters that are unlocked
        save.saveCharactersUnlocked(tempCharactersUnlocked)
        //hide unlock monkey
        monkies[monkies.count-1].hidden = true
        
        //move monkies to first one 
        for var k = 0; k < monkies.count - 1; k++ {
            self.monkies[k].position = CGPointMake(self.frame.midX + (self.frame.size.width / 5) * CGFloat(k), self.frame.midY)
            self.monkies[k].zPosition = 101
        }
        //move monkies to activated one, should hide buttons as well
        moveMonkiesToActivatedOne()
    }
    
    func unlockAds() {
        save.saveAdsAreOn(false)
        self.removeAdsButt.hidden = true
    }
    
    /************** Settings **************/
    /************** Settings **************/
    /************** Settings **************/
    /************** Settings **************/
    /************** Settings **************/
    
    func animateGearButtonsOut() {
        let slideSoundOut = SKAction.moveTo(CGPointMake(gearButton.position.x + faceBookButton.frame.size.width + playAgainButton.size.height / 7, gearButton.position.y + faceBookButton.frame.size.height / 2 + playAgainButton.size.height / 20), duration: 0.2)
        let slideVibrateOut = SKAction.moveTo(CGPointMake(gearButton.position.x + faceBookButton.frame.size.width + playAgainButton.size.height / 7, gearButton.position.y - faceBookButton.frame.size.height / 2 - playAgainButton.size.height / 20), duration: 0.2)
        self.soundButton.runAction(slideSoundOut)
        self.vibrateButton.runAction(slideVibrateOut)
    }
    
    func animateGearButtonsIn() {
        let slideSoundIn = SKAction.moveTo(gearButton.position, duration: 0.2)
        let slideVibrateIn = SKAction.moveTo(gearButton.position, duration: 0.2)
        self.soundButton.runAction(slideSoundIn)
        self.vibrateButton.runAction(slideVibrateIn)
    }
    
    /************** Social **************/
    /************** Social **************/
    /************** Social **************/
    /************** Social **************/
    /************** Social **************/
    
    func postToFacebook() {
        let vc = self.view?.window?.rootViewController          //get the root view controller
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            let fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            fbShare.setInitialText("I got \(score) nanners in Space Escape! See if you can beat me!")
            let shareImage = UIImage(named: "shareImage.png")
            fbShare.addImage(shareImage)            //image from death screen shot
            vc!.presentViewController(fbShare, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            vc!.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func tweetToTwitter() {
        let vc = self.view?.window?.rootViewController          //get the root view controller
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            
            let tweetShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            tweetShare.setInitialText("I got \(score) nanners in Space Escape! See if you can beat me! www.space-esc-ape.com #SpaceEscAPE")
            let shareImage = UIImage(named: "shareImage.png")
            tweetShare.addImage(shareImage)         ////image from death screen shot
            vc!.presentViewController(tweetShare, animated: true, completion: nil)
            
        } else {
            
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to tweet.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            vc!.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func animateSocialButtonsOut() {
        let slideFacebookOut = SKAction.moveTo(CGPointMake(faceBookButton.position.x - faceBookButton.frame.size.width - playAgainButton.size.height / 7, faceBookButton.position.y + faceBookButton.frame.size.height / 2 + playAgainButton.size.height / 20), duration: 0.2)
        let slideTwitterOut = SKAction.moveTo(CGPointMake(faceBookButton.position.x - faceBookButton.frame.size.width - playAgainButton.size.height / 7, faceBookButton.position.y - faceBookButton.frame.size.height / 2 - playAgainButton.size.height / 20), duration: 0.2)
        self.faceBookButton.runAction(slideFacebookOut)
        self.twitterButton.runAction(slideTwitterOut)
    }
    
    func animateSocialButtonsIn() {
        let slideFacebookIn = SKAction.moveTo(shareButton.position, duration: 0.2)
        let slideTwitterIn = SKAction.moveTo(shareButton.position, duration: 0.2)
        self.faceBookButton.runAction(slideFacebookIn)
        self.twitterButton.runAction(slideTwitterIn)
    }
    
    func postToFacebook2() {
        //check for a network connection
        //if Reachability.isConnectedToNetwork() {
            let vc = self.view?.window?.rootViewController          //get the root view controller
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
                let fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                fbShare.setInitialText("I got \(score) nanners in Space Escape! See if you can beat me!")
                let shareImage = UIImage(named: "shareImage.png")
                fbShare.addImage(shareImage)            //image from death screen shot
                vc!.presentViewController(fbShare, animated: true, completion: nil)
                
            } else {
                let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                vc!.presentViewController(alert, animated: true, completion: nil)
            }
            //unlock the stuff
            characters[1].setIsUnlocked(true)
            var tempCharactersUnlocked = [Bool]()
            for var k = 0; k < characters.count; k++ {
                tempCharactersUnlocked.append(characters[k].getIsUnlocked())
            }
            //save the characters that are unlocked
            save.saveCharactersUnlocked(tempCharactersUnlocked)
            monkies[1].colorBlendFactor = 0.0           //make monkey blend 0.0
            //hide bottom buttons
            self.selectButton.hidden = true
            self.characterPayLabel.hidden = true
//        } else {    //no network connection
//            //show alert that they don't have enough
//            let alert = UIAlertController(title: "Utoh!", message: "No network connection. You'll have to try again later! I know you will 😜", preferredStyle: UIAlertControllerStyle.Alert)
//            alert.addAction(UIAlertAction(title: "I'll try later!", style: UIAlertActionStyle.Default, handler: { alertAction in
//                alert.dismissViewControllerAnimated(true, completion: nil)
//            }))
//            let vc = self.view?.window?.rootViewController          //get the root view controller
//            vc!.presentViewController(alert, animated: true, completion: nil)
//        }
    }
    
    func followOnTwitter() {
        //check for a network connection
        //if Reachability.isConnectedToNetwork() {
            // open the Twitter App
            if !UIApplication.sharedApplication().openURL(NSURL(string: "twitter://user?screen_name=NoahBraggg")!) {
                // opening the app didn't work - let's open Safari
                if !UIApplication.sharedApplication().openURL(NSURL(string: "https://twitter.com/NoahBraggg")!) {
                    //shouldn't go in here
                }
            }
            //unlock the stuff
            characters[2].setIsUnlocked(true)
            var tempCharactersUnlocked = [Bool]()
            for var k = 0; k < characters.count; k++ {
                tempCharactersUnlocked.append(characters[k].getIsUnlocked())
            }
            //save the characters that are unlocked
            save.saveCharactersUnlocked(tempCharactersUnlocked)
            monkies[2].colorBlendFactor = 0.0           //make monkey blend 0.0
            //hide bottom buttons
            self.selectButton.hidden = true
            self.characterPayLabel.hidden = true
//        } else {    //no network connection
//            //show alert that they don't have enough
//            let alert = UIAlertController(title: "Utoh!", message: "No network connection. You'll have to try again later! I know you will 😜", preferredStyle: UIAlertControllerStyle.Alert)
//            alert.addAction(UIAlertAction(title: "I'll try later!", style: UIAlertActionStyle.Default, handler: { alertAction in
//                alert.dismissViewControllerAnimated(true, completion: nil)
//            }))
//            let vc = self.view?.window?.rootViewController          //get the root view controller
//            vc!.presentViewController(alert, animated: true, completion: nil)
//        }
    }
    
    /************** Rating **************/
    /************** Rating **************/
    /************** Rating **************/
    /************** Rating **************/
    /************** Rating **************/
    
    func setNumLaunches() {
        let numLaunches = NSUserDefaults.standardUserDefaults().integerForKey("numLaunches") + 1
        NSUserDefaults.standardUserDefaults().setInteger(numLaunches, forKey: "numLaunches")
    }
    
    //controls when the rateMe shows up
    func rateMe() {
        //number of times to ask for rating
        let iMinSessions = 3
        let iTryAgainSessions = 6
        
        let neverRate = NSUserDefaults.standardUserDefaults().boolForKey("neverRate")
        var numLaunches = NSUserDefaults.standardUserDefaults().integerForKey("numLaunches")
        
        if (!neverRate && (numLaunches == iMinSessions || numLaunches >= (iMinSessions + iTryAgainSessions + 1))) {
            showRateMe()
            numLaunches = iMinSessions + 1
        }
        NSUserDefaults.standardUserDefaults().setInteger(numLaunches, forKey: "numLaunches")
    }
    
    //shows the rate me controller
    func showRateMe() {
        let vc = self.view?.window?.rootViewController          //get the root view controller
        let alert = UIAlertController(title: "Rate Us", message: "Thanks for playing Space EscAPE", preferredStyle: UIAlertControllerStyle.Alert)
        let urlString = "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1017588879&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"
        alert.addAction(UIAlertAction(title: "Rate Space Esc-APE", style: UIAlertActionStyle.Default, handler: { alertAction in
            UIApplication.sharedApplication().openURL(NSURL(string : urlString)!)    //my app id is in there now
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "neverRate")
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No Thanks", style: UIAlertActionStyle.Default, handler: { alertAction in
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "neverRate")
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Maybe Later", style: UIAlertActionStyle.Default, handler: { alertAction in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        vc!.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    /************** Game Center **************/
    /************** Game Center **************/
    /************** Game Center **************/
    /************** Game Center **************/
    /************** Game Center **************/
    
    func showLeaderBoard() {
        let vc = self.view?.window?.rootViewController
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        vc!.presentViewController(gc, animated: true, completion: nil)
    }
    
    //hides leaderboard screen, required for the delegate
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //send high score to leaderboard
    func saveHighscoreToGameCenter(score:Int) {
        
        //check if user is signed in
        if GKLocalPlayer.localPlayer().authenticated {
            
            let scoreReporter = GKScore(leaderboardIdentifier: "SpaceEscAPE1994") //leaderboard id here
            //SpaceEscAPE1994
            //fallingApeLeaderboard1994
            scoreReporter.value = Int64(score) //score variable here (same as above)
            
            let scoreArray: [GKScore] = [scoreReporter]
            
            GKScore.reportScores(scoreArray, withCompletionHandler: {(error : NSError?) -> Void in
                if error != nil {
                    print("error")
                }
            })
            
        }
        
    }
    
    /************** Helper Methods **************/
    /************** Helper Methods **************/
    /************** Helper Methods **************/
    /************** Helper Methods **************/
    /************** Helper Methods **************/
    
    //scales the sprite to the correct size for the screen
    private func scaleSprite(sprite:SKSpriteNode) {
        let scaleBy = self.frame.width / 1536   //scale by iPad version which images are made for
        sprite.runAction(SKAction.scaleTo(scaleBy, duration: 0))
    }
    
    //scales the sprite to the correct size for the screen based on 6Plus
    private func scaleSpritePlus(sprite:SKSpriteNode) {
        let scaleBy = self.frame.width / 1242   //scale by 6 Plus version which images are made for
        sprite.runAction(SKAction.scaleTo(scaleBy, duration: 0))
    }
    
    //scales the sprite to the correct size for the screen based on 6Plus
    private func scaleExtraForIpad(sprite:SKSpriteNode) {
        if self.frame.width < 1000 {        //basically only make iPad scale, not iPhone 6
            let scaleBy = self.frame.width / 2000   //scale by 6 Plus version which images are made for
            sprite.runAction(SKAction.scaleTo(scaleBy, duration: 0))
        }
    }
    
    private func initVelocity() -> CGFloat {
        if self.frame.size.width > 700 {                                            //ipad or 6Plus
            return CGFloat(16)
        } else if self.frame.size.height < 500 && self.frame.size.width < 375 {     //iphone 4
            return CGFloat(8)
        } else if self.frame.size.width < 375 {                                     //iPhone 5
            return CGFloat(8.5)
        }
        return CGFloat(9.5)                                                         //iPhone 6
    }
    
    private func initGravity() -> CGFloat {
        if self.frame.size.width > 700 {                                            //ipad or 6 plus
            return CGFloat(16)
        } else if self.frame.size.height < 500 && self.frame.size.width < 375 {     //iphone 4
            return CGFloat(8)
        } else if self.frame.size.width < 375 {                                     //iPhone 5
            return CGFloat(8.5)
        }
        return CGFloat(9.5)                                                         //iPhone 6
    }
    
    private func randomDoubleBetween(low:Double, high:Double) -> Double {
        let arc4randoMax:Double = 0x100000000
        let upper = high
        let lower = low
        return (Double(arc4random()) / arc4randoMax) * (upper - lower) + lower
    }
        
    private func randomNumFrom(start:UInt32, end:UInt32) -> Int {
        return Int(arc4random_uniform(end - start + 1) + start)
    }
    
}