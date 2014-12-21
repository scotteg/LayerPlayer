//
//  TilingViewForImage.swift
//  LayerPlayer
//
//  Created by Scott Gardner on 7/27/14.
//  Copyright (c) 2014 Scott Gardner. All rights reserved.
//

import UIKit

let sideLength: CGFloat = 640.0
let fileName = "windingRoad"

class TilingViewForImage: UIView {
  
  let sideLength = CGFloat(640.0)
  let cachesPath = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0] as String
  
  override class func layerClass() -> AnyClass {
    return TiledLayer.self
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    let layer = self.layer as TiledLayer
    layer.contentsScale = UIScreen.mainScreen().scale
    layer.tileSize = CGSize(width: sideLength, height: sideLength)
  }
  
  override func drawRect(rect: CGRect) {
    let firstColumn = Int(CGRectGetMinX(rect) / sideLength)
    let lastColumn = Int(CGRectGetMaxX(rect) / sideLength)
    let firstRow = Int(CGRectGetMinY(rect) / sideLength)
    let lastRow = Int(CGRectGetMaxY(rect) / sideLength)
    
    for row in firstRow...lastRow {
      for column in firstColumn...lastColumn {
        if let tile = imageForTileAtColumn(column, row: row) {
          let x = sideLength * CGFloat(column)
          let y = sideLength * CGFloat(row)
          let point = CGPoint(x: x, y: y)
          let size = CGSize(width: sideLength, height: sideLength)
          var tileRect = CGRect(origin: point, size: size)
          tileRect = CGRectIntersection(bounds, tileRect)
          tile.drawInRect(tileRect)
        }
      }
    }
  }
  
  func imageForTileAtColumn(column: Int, row: Int) -> UIImage? {
    let filePath = "\(cachesPath)/\(fileName)_\(column)_\(row)"
    return UIImage(contentsOfFile: filePath)
  }

}
