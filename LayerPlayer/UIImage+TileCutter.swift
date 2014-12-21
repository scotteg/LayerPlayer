//
//  UIImage+TileCutter.swift
//  LayerPlayer
//
//  Created by Scott Gardner on 7/27/14.
//  Copyright (c) 2014 Scott Gardner. All rights reserved.
//
//  Adapted from Nick Lockwood's Terminal app in his book, iOS Core Animation: Advanced Techniques
//  http://www.informit.com/store/ios-core-animation-advanced-techniques-9780133440751
//

import UIKit

extension UIImage {
  
  class func saveTileOfSize(size: CGSize, name: String) -> () {
    let cachesPath = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0] as String
    let filePath = "\(cachesPath)/\(name)_0_0.png"
    let fileManager = NSFileManager.defaultManager()
    let fileExists = fileManager.fileExistsAtPath(filePath)
        
    if fileExists == false {
      var tileSize = size
      let scale = Float(UIScreen.mainScreen().scale)
      
      if let image = UIImage(named: "\(name).jpg") {
        let imageRef = image.CGImage
        let totalColumns = Int(ceilf(Float(image.size.width / tileSize.width)) * scale)
        let totalRows = Int(ceilf(Float(image.size.height / tileSize.height)) * scale)
        let partialColumnWidth = Int(image.size.width % tileSize.width)
        let partialRowHeight = Int(image.size.height % tileSize.height)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
          for y in 0..<totalRows {
            for x in 0..<totalColumns {
              if partialRowHeight > 0 && y + 1 == totalRows {
                tileSize.height = CGFloat(partialRowHeight)
              }
              
              if partialColumnWidth > 0 && x + 1 == totalColumns {
                tileSize.width = CGFloat(partialColumnWidth)
              }
              
              let xOffset = CGFloat(x) * tileSize.width
              let yOffset = CGFloat(y) * tileSize.height
              let point = CGPoint(x: xOffset, y: yOffset)
              let tileImageRef = CGImageCreateWithImageInRect(imageRef, CGRect(origin: point, size: tileSize))
              let imageData = UIImagePNGRepresentation(UIImage(CGImage: tileImageRef))
              let path = "\(cachesPath)/\(name)_\(x)_\(y).png"
              imageData?.writeToFile(path, atomically: false)
            }
          }
        })
      }
    }
  }
  
}
