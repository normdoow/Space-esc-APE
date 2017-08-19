//
//  Generator.swift
//  Falling Ape
//
//  Created by Noah Bragg on 5/13/15.
//  Copyright (c) 2015 NoahBragg. All rights reserved.
//
//  Description: Used to make the random sequence of falling Asteroids

import Foundation
import UIKit

public class Generator {
    
    /************** Initializers **************/
    
    init(){
        smallAsteroidWidth = 0
        mediumAsteroidWidth = 0
        largeAsteroidWidth = 0
        frame = CGRectMake(3, 4, 5, 6)
        sizeOfAsteroid = "medium"
        generatedXPoints = [CGFloat]()
        chosenColumns = [Int]()
        yPoints = []
        score = 0
        numOfAsteroidChoices = 0
        bananaCounter = 0
        bananaXPoint = 0
        skipMakingNewPath = true
        skipTimesForBigAsteroid = 0
    }
    //initializes the class
    init(small:CGFloat, medium:CGFloat, large:CGFloat, f:CGRect){
        smallAsteroidWidth = small
        mediumAsteroidWidth = medium
        largeAsteroidWidth = large
        frame = f
        sizeOfAsteroid = "medium"
        generatedXPoints = [CGFloat]()
        chosenColumns = [Int]()
        yPoints = []
        yPoints.append(-frame.width * (3/5))
        score = 0
        numOfAsteroidChoices = 15
        bananaCounter = 0
        bananaXPoint = 0
        skipMakingNewPath = true
        skipTimesForBigAsteroid = 0
        
        //initialize a 5 x 8 array
        let numColumns = 5
        let numRows = 7
        for _ in 0...numRows - 1 {
            dataArray.append(Array(count: numColumns, repeatedValue: "X"))
        }
    }
    
    /************** Class variables **************/
    
    private var generatedXPoints:[CGFloat]
    private var yPoints:[CGFloat]
    private var chosenColumns:[Int]
    private var dataArray = Array<Array<String>>()
    private var smallAsteroidWidth:CGFloat
    private var mediumAsteroidWidth:CGFloat
    private var largeAsteroidWidth:CGFloat
    private var frame:CGRect
    private var sizeOfAsteroid:String
    private var score:Int
    private var numOfAsteroidChoices:UInt32
    private var bananaCounter:Int
    private var bananaXPoint:CGFloat
    private var skipMakingNewPath:Bool      //used to skip making new path every other time
    private var skipTimesForBigAsteroid:Int
    private var pLeft = false
    private var pRight = false
    
    /************** Setter Methods **************/
    
    public func setScore(score:Int) {
        self.score = score
    }
    
    //resets for a new game
    public func resetGenerator() {
        //resets the array
        for var k = 0; k < 7; k++ {
            for var j = 0; j < dataArray[k].count; j++ {
                dataArray[k][j] = "X"
            }
        }
        score = 0           //reset the score
        bananaCounter = 0
        skipMakingNewPath = true
        skipTimesForBigAsteroid = 0
    }
    
    public func setBananaCounter(num:Int) {
        bananaCounter = num
    }
    
    /************** Getter Methods **************/
    
    //get the gerated points array
    public func getGeneratedXPoints() -> [CGFloat] {
        return generatedXPoints
    }
    public func getSizeOfAsteroid() -> String {
        return sizeOfAsteroid
    }
    public func getYPoints() -> [CGFloat] {
        return yPoints
    }
    public func getBananaXPoint() -> CGFloat {
        return bananaXPoint
    }
    public func getBananaCounter() -> Int {
        return bananaCounter
    }
    
    /************** Generating Methods **************/
    
    //decides what the generated sequence should be
    public func makeSequence() {
        //reset arrays
        generatedXPoints = []
        chosenColumns = []
        moveRowsForwardInArray()            //move the data array forward
        bananaCounter++                     //increment the banana counter
        skipMakingNewPath = !skipMakingNewPath
        
        //remove yPoints if needed
        if yPoints.count > 1 {
            yPoints.removeAtIndex(1)
        }
        
        let randNum = randomNumFromZeroTo(39)
        if (randNum == 0 || skipTimesForBigAsteroid > 0) && score > 15 {        //make big asteroids
            //awful code to set dataArray based on which side the asteroid was chosen
            if pLeft {
                dataArray[5][0] = "P"
                dataArray[5][1] = "P"
            }else if pRight {
                dataArray[5][3] = "P"
                dataArray[5][4] = "P"
            }
            if skipTimesForBigAsteroid == 0 {
                skipTimesForBigAsteroid = 4
            } else if skipTimesForBigAsteroid == 2 {
                let rand = randomNumFromZeroTo(1)
                if rand == 0 {                  //create left or right big asteroid
                    chosenColumns.append(30)
                    dataArray[5][0] = "P"
                    dataArray[5][1] = "P"
                    pLeft = true
                } else {
                    chosenColumns.append(31)
                    dataArray[5][3] = "P"
                    dataArray[5][4] = "P"
                    pRight = true
                }
                setPoints()
            }
            skipTimesForBigAsteroid--
            if skipTimesForBigAsteroid == 0 {
                pRight = false
                pLeft = false
            }
        } else {
            if !skipMakingNewPath{
                var lastPIndex = -1
                //find the first P in row 4
                for var k = 0; k < dataArray[5].count; k++ {
                    if dataArray[4][k] == "P" {
                        lastPIndex = k
                        k = 10  //jump out of for loop
                    }
                }
                if lastPIndex == -1 {       //if there was no P and therefore we are just starting the game
                    //choose a random P
                    let rand = self.randomNumFromZeroTo(3)
                    //set the path values
                    dataArray[5][rand] = "P"
                    dataArray[5][rand + 1] = "P"
                } else {                    //we need to make new path adjacent to last path
                    var chosenRand:Int
                    if lastPIndex == 0 {            //different if statements to watch out for edges
                        chosenRand = self.randomNumFrom(UInt32(lastPIndex), end: UInt32(lastPIndex + 1))
                    } else  if lastPIndex == 3{
                        chosenRand = self.randomNumFrom(UInt32(lastPIndex - 1), end: UInt32(lastPIndex))
                    } else {
                        chosenRand = self.randomNumFrom(UInt32(lastPIndex - 1), end: UInt32(lastPIndex + 1))
                    }
                    dataArray[5][chosenRand] = "P"
                    dataArray[5][chosenRand + 1] = "P"
                }
            } else if skipMakingNewPath {            //add P's at the same place as last time
                for var k = 0; k < dataArray[4].count; k++ {
                    if dataArray[4][k] == "P" {
                        dataArray[5][k] = "P"      //put the path another time in a row
                    }
                }
            }
            
            //find P's 
            var jumpOverIndex = 0
            for var k = 0; k < dataArray[5].count; k++ {
                if dataArray[5][k] == "P" {
                    jumpOverIndex = k
                    k = 10  //jump out of the loop
                }
            }
            
            switch jumpOverIndex {
            case 0:
                chosenColumns.append(randomNumFromOneToEndExcept(1, end: 5, finalEnd: numOfAsteroidChoices - 2))
            case 1:
                chosenColumns.append(randomNumFromOneToEndExcept(4, end: 8, finalEnd: numOfAsteroidChoices - 2))
            case 2:
                chosenColumns.append(randomNumFromOneToEndExcept(6, end: 10, finalEnd: numOfAsteroidChoices - 2))
            case 3:
                chosenColumns.append(randomNumFromOneToEndExcept(9, end: 13, finalEnd: numOfAsteroidChoices - 2))
            default:
                chosenColumns.append(randomNumFromOneTo(numOfAsteroidChoices))
                print("went to default", terminator: "")
            }
            //chosenColumns = []
            //chosenColumns.append(14)
            setPoints()
            
        }
        
        //printElementsInDataArray()
    }
    
    private func setPoints(){
        
        for column in chosenColumns {
            switch column {
                
            /************** left side **************/
            case 1:     //first column
                if dataArray[5][0] == "X" {
                    generatedXPoints.append(frame.minX + mediumAsteroidWidth / 2)
                    sizeOfAsteroid = "medium"
                    dataArray[5][0] = "M"
                }
            case 2:     //first column small
                if dataArray[5][0] == "X" {
                    generatedXPoints.append(frame.minX + mediumAsteroidWidth / 2)
                    sizeOfAsteroid = "small"
                    dataArray[5][0] = "S"
                }
            case 3:    //small double left side
                if dataArray[5][0] == "X" {
                    generatedXPoints.append(frame.minX + smallAsteroidWidth / 2)
                    generatedXPoints.append(frame.minX + smallAsteroidWidth * 1.5)
                    let rand = randomNumFromZeroTo(1)
                    if rand == 0 {
                        yPoints.append(yPoints[0] + smallAsteroidWidth)
                    } else {
                        yPoints.append(yPoints[0] - smallAsteroidWidth)
                    }
                    sizeOfAsteroid = "small"
                    dataArray[5][0] = "M"
                }
            case 4:     //second column
                if dataArray[5][1] == "X" {
                    generatedXPoints.append(frame.width * (2/5) - mediumAsteroidWidth / 2)
                    sizeOfAsteroid = "medium"
                    dataArray[5][1] = "M"
                }
            case 5:     //second column small
                if dataArray[5][1] == "X" {
                    generatedXPoints.append(frame.width * (2/5) - mediumAsteroidWidth / 2)
                    sizeOfAsteroid = "small"
                    dataArray[5][1] = "S"
                }
                
            /************** middle **************/
            case 6:     //third column
                if dataArray[5][2] == "X" {
                    generatedXPoints.append(frame.midX)
                    sizeOfAsteroid = "medium"
                    dataArray[5][2] = "M"
                }
            case 7:     //third column small
                if dataArray[5][2] == "X" {
                    generatedXPoints.append(frame.midX)
                    sizeOfAsteroid = "small"
                    dataArray[5][2] = "S"
                }
            case 8:    //small double middle
                if dataArray[5][2] == "X" {
                    generatedXPoints.append(frame.midX + smallAsteroidWidth / 2)
                    generatedXPoints.append(frame.midX - smallAsteroidWidth / 2)
                    let rand = randomNumFromZeroTo(1)
                    if rand == 0 {
                        yPoints.append(yPoints[0] + smallAsteroidWidth)
                    } else {
                        yPoints.append(yPoints[0] - smallAsteroidWidth)
                    }
                    sizeOfAsteroid = "small"
                    dataArray[5][2] = "M"
                }
            /************** right side **************/
            case 9:     //fourth column
                if dataArray[5][3] == "X" {
                    generatedXPoints.append(frame.width * (3/5) + mediumAsteroidWidth / 2)
                    sizeOfAsteroid = "medium"
                    dataArray[5][3] = "M"
                }
            case 10:     //fourth column small
                if dataArray[5][3] == "X" {
                    generatedXPoints.append(frame.width * (3/5) + mediumAsteroidWidth / 2)
                    sizeOfAsteroid = "small"
                    dataArray[5][3] = "S"
                }
            case 11:    //fifth column small
                if dataArray[5][4] == "X" {
                    generatedXPoints.append(frame.maxX - mediumAsteroidWidth / 2)
                    sizeOfAsteroid = "small"
                    dataArray[5][4] = "S"
                }
            case 12:     //fifth column
                if dataArray[5][4] == "X" {
                    generatedXPoints.append(frame.maxX - mediumAsteroidWidth / 2)
                    sizeOfAsteroid = "medium"
                    dataArray[5][4] = "M"
                }
            case 13:    //small double right side
                if dataArray[5][4] == "X" {
                    generatedXPoints.append(frame.maxX - smallAsteroidWidth / 2)
                    generatedXPoints.append(frame.maxX - smallAsteroidWidth * 1.5)
                    let rand = randomNumFromZeroTo(1)
                    if rand == 0 {
                        yPoints.append(yPoints[0] + smallAsteroidWidth)
                    } else {
                        yPoints.append(yPoints[0] - smallAsteroidWidth)
                    }
                    sizeOfAsteroid = "small"
                    dataArray[5][4] = "M"
                }
                
            
             /************** big asteroids **************/
            case 30:    //Big Asteroid Right Side
                generatedXPoints.append(frame.width * (5/7))
                sizeOfAsteroid = "large"
            case 31:    //Big ASteroid Left Side
                generatedXPoints.append(frame.width * (2/7))
                sizeOfAsteroid = "large"
            default:
                generatedXPoints.append(frame.midX)
                sizeOfAsteroid = "medium"
                dataArray[5][2] = "M"
            }
        }
    }
    
    public func generateBanana() {
        var index = 10
        for var k = 0; k < dataArray[5].count; k++ {
            if dataArray[5][k] == "P" {
                index = k
                k = 20      //jump out of the for loop
            }
        }
        switch index {
        case 0:     //path on the left side
            bananaXPoint = frame.size.width / 5
        case 1:
            bananaXPoint = frame.size.width / 5 * 2
        case 2:
            bananaXPoint = frame.size.width / 5 * 3
        case 3:
            bananaXPoint = frame.size.width / 5 * 4
        default:    //no path
            bananaXPoint = -200
        }
    }
    
    /************** Helper functions **************/
    
    //move stuff forward in the array
    private func moveRowsForwardInArray(){
        for var k = 0; k < 5; k++ {
            dataArray[0].removeAtIndex(0)
        }
        dataArray.removeAtIndex(0)      //delete that first row
        dataArray.append(Array(count: 5, repeatedValue: "X"))
    }
    //print the elements in dataArray
    private func printElementsInDataArray() {
        for var k = 0; k < 7; k++ {
            for var j = 0; j < dataArray[k].count; j++ {
                print(dataArray[k][j] + " ", terminator: "")
            }
            print("")
        }
        print("Finished the printing")
    }
    
    //creates a random number starting at 0
    private func randomNumFromZeroTo(amount:UInt32) -> Int {
        return Int(arc4random_uniform(amount + 1))
    }
    //creates a random number starting at 1
    private func randomNumFromOneTo(amount:UInt32) -> Int {
        return Int(arc4random_uniform(amount) + 1)
    }
    //create a random number starting at x and ending at y
    private func randomNumFrom(start:UInt32, end:UInt32) -> Int {
        return Int(arc4random_uniform(end - start + 1) + start)
    }
    //create random number  to z from full range except x and y
    private func randomNumFromOneToEndExcept(start:UInt32, end:UInt32, finalEnd:UInt32) -> Int {
        var rand = arc4random_uniform(finalEnd - (end - start) - 1) + 1
        if rand >= start {
            rand += end - start + 1
        }
        return Int(rand)
    }
    
}
