//
//  InApp.swift
//  InAppPurchase
//
//  Created by Noah Bragg on 7/6/15.
//  Copyright (c) 2015 Brian Coleman. All rights reserved.
//

import Foundation
import StoreKit
import SpriteKit

class InApp : NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    //global variables needed
    var productIdentifiers = Set<String>()
    var productIdentifiersAsArray = [String]()
    var product: SKProduct?
    var productsArray = Array<SKProduct>()
    var request = SKProductsRequest()
    var productsToUnlock = [Bool]()             //array to use to see what is unlocked
    
    // In-App Purchase Methods
    
    //used to start the transaction process
    func initStoreKit(characters:[Character]) {
        //init the product identifiers
        for var k = 3; k < characters.count; k++ {      //start at 3 because the first 3 monkeys aren't purchases
            productIdentifiers.insert(characters[k].getID())
            productIdentifiersAsArray.append(characters[k].getID())
            productsToUnlock.append(false)
        }
        let adId = "com.NoahBragg.SpaceEscape.NoAds"             //add the id for getting rid of ads
        productIdentifiers.insert(adId)
        productIdentifiersAsArray.append(adId)
        
        //remove and then reAdd listener
        //NSNotificationCenter.defaultCenter().removeObserver(self, name: "NSNotificationInAppListen", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "endStoreKit", name: "NSNotificationInAppListen", object: nil)
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        requestProductData()           //call setting up data
        
    }
    
    //stops the transaction process
    func endStoreKit() {
        SKPaymentQueue.defaultQueue().removeTransactionObserver(self)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "NSNotificationInAppListen", object: nil)
    }
    
    //Stage 1: retrieve product information
    func requestProductData() {
        if SKPaymentQueue.canMakePayments() {
            self.request = SKProductsRequest(productIdentifiers:
                self.productIdentifiers)        //deleted "as Set<String>" from the end  //changed this from "object" to "String"
            self.request.delegate = self
            self.request.start()
        }
    }
    
    //part of stage 1
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        
        var products = response.products
        
        if (products.count != 0) {
            for var k = 0; k < productIdentifiersAsArray.count; k++ {       //array to match the products in the right order
                for var i = 0; i < products.count; i++ {
                    if products[i].productIdentifier == productIdentifiersAsArray[k] {
                        self.product = products[i] as SKProduct     //got rid of the question mark
                        self.productsArray.append(product!)
                    }
                }
            }
        } else {
            print("No products found")
        }
        
        let products2 = response.invalidProductIdentifiers      //changed this from products to products2 and declaring for ios9
        
        for product in products2 {
            print("Product not found: \(product)")
        }
    }
    
    func request(request: SKRequest, didFailWithError error: NSError) {
        print("The request failed")
        endStoreKit()
    }
    
    //Stage 2 Requesting payment called from tapping on button to buy
    func buyProductWithIndex(characterIndex:Int, scene:SKScene) {
        if SKPaymentQueue.canMakePayments() {                   //if you can make payment
            if productsArray.count > characterIndex {           //if the index is within
                let payment = SKPayment(product: productsArray[characterIndex])
                SKPaymentQueue.defaultQueue().addPayment(payment)
            } else {                                            //show that there was an error
                let alert = UIAlertController(title: "Error", message: "There was an error requesting the in-app purchases", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Error", style: UIAlertActionStyle.Default, handler: { alertAction in
                    alert.dismissViewControllerAnimated(true, completion: nil)
                    
                    let url: NSURL? = NSURL(string: UIApplicationOpenSettingsURLString)
                    if url != nil
                    {
                        UIApplication.sharedApplication().openURL(url!)
                    }
                    
                }))
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { alertAction in
                    alert.dismissViewControllerAnimated(true, completion: nil)
                }))
                let vc = scene.view?.window?.rootViewController          //get the root view controller
                vc!.presentViewController(alert, animated: true, completion: nil)
            }
        } else {                                    //tell them they need to open up in app purchases
            let alert = UIAlertController(title: "In-App Purchases Not Enabled", message: "Please enable In App Purchase in Settings", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.Default, handler: { alertAction in
            alert.dismissViewControllerAnimated(true, completion: nil)
            
            let url: NSURL? = NSURL(string: UIApplicationOpenSettingsURLString)
            if url != nil
            {
            UIApplication.sharedApplication().openURL(url!)
            }
            
            }))
            alert.addAction(UIAlertAction(title: "I will!", style: UIAlertActionStyle.Default, handler: { alertAction in
            alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            let vc = scene.view?.window?.rootViewController          //get the root view controller
            vc!.presentViewController(alert, animated: true, completion: nil)
        }
    }

    //stage 3 Delivering products
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            
            switch transaction.transactionState {
                
            case SKPaymentTransactionState.Purchased:
                print("Transaction Approved")
                print("Product Identifier: \(transaction.payment.productIdentifier)")
                self.unlockCharactersPurchased(transaction)                  //unlock the characters
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                
            case SKPaymentTransactionState.Failed:
                print("Transaction Failed")
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
            default:
                break
            }
        }
    }
    
    //unlocks the character that they bought
    func unlockCharactersPurchased(transaction:SKPaymentTransaction) {
        print("delivering the product")
        
        for var k = 0; k < productIdentifiersAsArray.count; k++ {
            if transaction.payment.productIdentifier == productIdentifiersAsArray[k] {
                if k == productIdentifiersAsArray.count - 2 {       //if second to last then its the unlock all
                    NSNotificationCenter.defaultCenter().postNotificationName("NSNotificationUnlockAll", object: nil);
                } else if k == productIdentifiersAsArray.count - 1 {    //if last then its the get rid of ads
                    NSNotificationCenter.defaultCenter().postNotificationName("NSNotificationNoAds", object: nil);
                } else {
                    productsToUnlock[k] = true      //set the character they want to be unlocked
                }
            }
        }
        //unlock the stuff from within PlayScene
        NSNotificationCenter.defaultCenter().postNotificationName("NSNotificationForInApp", object: nil);
    }
    
    //restore purchases: called from the restore button
    func restorePurchases() {
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
    }
    
    //goes through what is unlocked and unlocks the feature
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue) {
        print("Transactions Restored")
        
        for transaction:SKPaymentTransaction in queue.transactions {
            for var k = 0; k < productIdentifiersAsArray.count; k++ {
                if transaction.payment.productIdentifier == productIdentifiersAsArray[k] {
                    if k == productIdentifiersAsArray.count - 2 {       //if second to last then its the unlock all
                        NSNotificationCenter.defaultCenter().postNotificationName("NSNotificationUnlockAll", object: nil);
                    } else if k == productIdentifiersAsArray.count - 1 {    //if last then its the get rid of ads
                        NSNotificationCenter.defaultCenter().postNotificationName("NSNotificationNoAds", object: nil);
                    } else {
                        productsToUnlock[k] = true      //set the character they want to be unlocked
                    }
                }
            }

        }
        //unlock the stuff from within PlayScene
        NSNotificationCenter.defaultCenter().postNotificationName("NSNotificationForInApp", object: nil);
        let alert = UIAlertView(title: "Thank You", message: "You got your purchase(s) restored!", delegate: nil, cancelButtonTitle: "Sweet!")
        alert.show()
        
    }
    
}