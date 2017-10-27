//
//  UIImageExtension.swift
//  RxAstroChannels
//
//  Created by Candice H on 10/27/17.
//  Copyright © 2017 Candice H. All rights reserved.
//

import UIKit

extension UIImage {
    
    func scaledToSize(_ newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
