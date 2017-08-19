//
//  Reachability.swift
//  Falling Ape
//
//  Created by Noah Bragg on 7/18/15.
//  Copyright (c) 2015 NoahBragg. All rights reserved.
//

import Foundation
import SystemConfiguration

//commented this out because I don't think I am really using it and it was causing errors. Might have to bring it back sometime though

//public class Reachability {
//    
//    class func isConnectedToNetwork() -> Bool {
//        
//        var zeroAddress = sockaddr_in()
//        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
//        zeroAddress.sin_family = sa_family_t(AF_INET)
//        
//        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
//            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0)).takeRetainedValue()
//        }
//        
//        var flags : SCNetworkReachabilityFlags = 0
//        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == 0 {
//            return false
//        }
//        
//        let isReachable = (flags & UInt32(kSCNetworkFlagsReachable)) != 0
//        let needsConnection = (flags & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
//        return (isReachable && !needsConnection)
//    }
//    
//}