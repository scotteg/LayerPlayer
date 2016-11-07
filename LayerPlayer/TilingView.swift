//
//  TilingView.swift
//  LayerPlayer
//
//  Created by Scott Gardner on 11/17/14.
//  Copyright (c) 2014 Scott Gardner. All rights reserved.
//

import UIKit

class TilingView: UIView {
  
  let sideLength = CGFloat(100.0)
  
  override class var layerClass : AnyClass {
    return TiledLayer.self
  }
  
  required init?(coder aDecoder: NSCoder) {
    srand48(Int(Date().timeIntervalSince1970))
    super.init(coder: aDecoder)
    guard let layer = self.layer as? TiledLayer else { return nil }
    layer.contentsScale = UIScreen.main.scale
    layer.tileSize = CGSize(width: sideLength, height: sideLength)
  }
  
  override func draw(_ rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()
    let scale = UIScreen.main.scale
    
    var red = CGFloat(drand48())
    var green = CGFloat(drand48())
    var blue = CGFloat(drand48())
    context?.setFillColor(red: red, green: green, blue: blue, alpha: 1.0)
    context?.fill(rect)
    
    let x = bounds.origin.x
    let y = bounds.origin.y
    let offset = bounds.width / sideLength * (scale == 3 ? 2 : scale)
    context?.move(to: CGPoint(x: x + 9.0 * offset, y: y + 43.0 * offset))
    context?.addLine(to: CGPoint(x: x + 18.06 * offset, y: y + 22.6 * offset))
    context?.addLine(to: CGPoint(x: x + 25.0 * offset, y: y + 7.5 * offset))
    context?.addLine(to: CGPoint(x: x + 41.0 * offset, y: y + 43.0 * offset))
    context?.addLine(to: CGPoint(x: x + 9.0 * offset, y: y + 21.66 * offset))
    context?.addLine(to: CGPoint(x: x + 41.0 * offset, y: y + 14.54 * offset))
    context?.addLine(to: CGPoint(x: x + 9.0 * offset, y: y + 43.0 * offset))
    context?.closePath()
    
    red = CGFloat(drand48())
    green = CGFloat(drand48())
    blue = CGFloat(drand48())
    context?.setFillColor(red: red, green: green, blue: blue, alpha: 1.0)
    context?.setStrokeColor(UIColor.white.cgColor)
    context?.setLineWidth(4.0 / scale)
    context?.drawPath(using: .eoFillStroke)
  }
  
}
