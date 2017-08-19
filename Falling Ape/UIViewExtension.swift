//
//  UIViewExtension.swift
//  Falling Ape
//
//  Created by Noah Bragg on 7/4/15.
//  Copyright (c) 2015 NoahBragg. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func takeSnapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.mainScreen().scale)
        
        drawViewHierarchyInRect(self.bounds, afterScreenUpdates: true)
        
        // old style: layer.renderInContext(UIGraphicsGetCurrentContext())
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}