//
//  CATransformLayerViewController.swift
//  LayerPlayer
//
//  Created by Scott Gardner on 11/20/14.
//  Copyright (c) 2014 Scott Gardner. All rights reserved.
//

import UIKit

func degreesToRadians(degrees: Double) -> CGFloat {
  return CGFloat(degrees * M_PI / 180.0)
}

func radiansToDegrees(radians: Double) -> CGFloat {
  return CGFloat(radians / M_PI * 180.0)
}

class CATransformLayerViewController: UIViewController {
  
  @IBOutlet weak var boxTappedLabel: UILabel!
  @IBOutlet weak var viewForTransformLayer: UIView!
  @IBOutlet var colorAlphaSwitches: [UISwitch]!
  
  enum Color: Int {
    case Red, Orange, Yellow, Green, Blue, Purple
  }
  let sideLength = CGFloat(160.0)
  let reducedAlpha = CGFloat(0.8)
  
  var transformLayer: CATransformLayer!
  let swipeMeTextLayer = CATextLayer()
  var redColor = UIColor.redColor()
  var orangeColor = UIColor.orangeColor()
  var yellowColor = UIColor.yellowColor()
  var greenColor = UIColor.greenColor()
  var blueColor = UIColor.blueColor()
  var purpleColor = UIColor.purpleColor()
  var trackBall: TrackBall?
  
  // MARK: - Quick reference
  
  func setUpSwipeMeTextLayer() {
    swipeMeTextLayer.frame = CGRect(x: 0.0, y: sideLength / 4.0, width: sideLength, height: sideLength / 2.0)
    swipeMeTextLayer.string = "Swipe Me"
    swipeMeTextLayer.alignmentMode = kCAAlignmentCenter
    swipeMeTextLayer.foregroundColor = UIColor.whiteColor().CGColor
    let fontName = "Noteworthy-Light" as CFString
    let fontRef = CTFontCreateWithName(fontName, 24.0, nil)
    swipeMeTextLayer.font = fontRef
    swipeMeTextLayer.contentsScale = UIScreen.mainScreen().scale
  }
  
  // MARK: - View life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpSwipeMeTextLayer()
    buildCube()
  }
  
  // MARK: - IBActions
  
  @IBAction func colorAlphaSwitchChanged(sender: UISwitch) {
    let alpha = sender.on ? reducedAlpha : 1.0
    
    switch (colorAlphaSwitches as NSArray).indexOfObject(sender) {
    case Color.Red.rawValue:
      redColor = colorForColor(redColor, withAlpha: alpha)
    case Color.Orange.rawValue:
      orangeColor = colorForColor(orangeColor, withAlpha: alpha)
    case Color.Yellow.rawValue:
      yellowColor = colorForColor(yellowColor, withAlpha: alpha)
    case Color.Green.rawValue:
      greenColor = colorForColor(greenColor, withAlpha: alpha)
    case Color.Blue.rawValue:
      blueColor = colorForColor(blueColor, withAlpha: alpha)
    case Color.Purple.rawValue:
      purpleColor = colorForColor(purpleColor, withAlpha: alpha)
    default:
      break
    }
    
    transformLayer.removeFromSuperlayer()
    buildCube()
  }
  
  // MARK: - Triggered actions
  
  override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
    if let location = touches.anyObject()?.locationInView(viewForTransformLayer) {
      if trackBall != nil {
        trackBall?.setStartPointFromLocation(location)
      } else {
        trackBall = TrackBall(location: location, inRect: viewForTransformLayer.bounds)
      }
      
      for layer in transformLayer.sublayers {
        if let hitLayer = layer.hitTest(location) {
          showBoxTappedLabel()
          break
        }
      }
    }
  }
  
  override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
    if let location = touches.anyObject()?.locationInView(viewForTransformLayer) {
      if let transform = trackBall?.rotationTransformForLocation(location) {
        viewForTransformLayer.layer.sublayerTransform = transform
      }
    }
  }
  
  override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
    if let location = touches.anyObject()?.locationInView(viewForTransformLayer) {
      trackBall?.finalizeTrackBallForLocation(location)
    }
  }
  
  func showBoxTappedLabel() {
    boxTappedLabel.alpha = 1.0
    boxTappedLabel.hidden = false
    
    UIView.animateWithDuration(0.5, animations: {
      self.boxTappedLabel.alpha = 0.0
      }, completion: {
        [unowned self] _ in
        self.boxTappedLabel.hidden = true
    })
  }
  
  // MARK: - Helpers
  
  func buildCube() {
    transformLayer = CATransformLayer()
    
    var layer = sideLayerWithColor(redColor)
    layer.addSublayer(swipeMeTextLayer)
    transformLayer.addSublayer(layer)
    
    layer = sideLayerWithColor(orangeColor)
    var transform = CATransform3DMakeTranslation(sideLength / 2.0, 0.0, sideLength / -2.0)
    transform = CATransform3DRotate(transform, degreesToRadians(90.0), 0.0, 1.0, 0.0)
    layer.transform = transform
    transformLayer.addSublayer(layer)
    
    layer = sideLayerWithColor(yellowColor)
    layer.transform = CATransform3DMakeTranslation(0.0, 0.0, -sideLength)
    transformLayer.addSublayer(layer)
    
    layer = sideLayerWithColor(greenColor)
    transform = CATransform3DMakeTranslation(sideLength / -2.0, 0.0, sideLength / -2.0)
    transform = CATransform3DRotate(transform, degreesToRadians(90.0), 0.0, 1.0, 0.0)
    layer.transform = transform
    transformLayer.addSublayer(layer)
    
    layer = sideLayerWithColor(blueColor)
    transform = CATransform3DMakeTranslation(0.0, sideLength / -2.0, sideLength / -2.0)
    transform = CATransform3DRotate(transform, degreesToRadians(90.0), 1.0, 0.0, 0.0)
    layer.transform = transform
    transformLayer.addSublayer(layer)
    
    layer = sideLayerWithColor(purpleColor)
    transform = CATransform3DMakeTranslation(0.0, sideLength / 2.0, sideLength / -2.0)
    transform = CATransform3DRotate(transform, degreesToRadians(90.0), 1.0, 0.0, 0.0)
    layer.transform = transform
    transformLayer.addSublayer(layer)
    
    transformLayer.anchorPointZ = sideLength / -2.0
    viewForTransformLayer.layer.addSublayer(transformLayer)
  }
  
  func sideLayerWithColor(color: UIColor) -> CALayer {
    let layer = CALayer()
    layer.frame = CGRect(origin: CGPointZero, size: CGSize(width: sideLength, height: sideLength))
    layer.position = CGPoint(x: CGRectGetMidX(viewForTransformLayer.bounds), y: CGRectGetMidY(viewForTransformLayer.bounds))
    layer.backgroundColor = color.CGColor
    return layer
  }
  
  func colorForColor(var color: UIColor, withAlpha newAlpha: CGFloat) -> UIColor {
    var red = CGFloat()
    var green = red, blue = red, alpha = red
    
    if color.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
      color = UIColor(red: red, green: green, blue: blue, alpha: newAlpha)
    }
    
    return color
  }
  
}
