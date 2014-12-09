//
//  CAEmitterLayerViewController.swift
//  LayerPlayer
//
//  Created by Scott Gardner on 11/22/14.
//  Copyright (c) 2014 Scott Gardner. All rights reserved.
//

import UIKit

class CAEmitterLayerViewController: UIViewController {
  
  @IBOutlet weak var viewForEmitterLayer: UIView!
  
  var emitterLayer: CAEmitterLayer!
  var emitterCell: CAEmitterCell!
  
  // MARK: - Quick reference
  
  func setUpEmitterLayer() {
    emitterLayer = CAEmitterLayer()
    emitterLayer.frame = viewForEmitterLayer.bounds
    emitterLayer.seed = UInt32(NSDate().timeIntervalSince1970)
    emitterLayer.renderMode = kCAEmitterLayerAdditive
    emitterLayer.emitterPosition = CGPoint(x: CGRectGetWidth(self.view.frame) / 4.0 * 3.0, y: CGRectGetHeight(emitterLayer.frame) / 2.0)
  }
  
  func setUpEmitterCell() {
    emitterCell = CAEmitterCell()
    emitterCell.enabled = true
    emitterCell.contents = UIImage(named: "smallStar")?.CGImage
    emitterCell.contentsRect = CGRect(origin: CGPointZero, size: CGSize(width: 1, height: 1))
    emitterCell.color = UIColor(hue: 0.0, saturation: 0.0, brightness: 0.0, alpha: 1.0).CGColor
    emitterCell.redRange = 1.0
    emitterCell.greenRange = 1.0
    emitterCell.blueRange = 1.0
    emitterCell.alphaRange = 0.0
    emitterCell.redSpeed = 0.0
    emitterCell.greenSpeed = 0.0
    emitterCell.blueSpeed = 0.0
    emitterCell.alphaSpeed = -0.5
    emitterCell.scale = 1.0
    emitterCell.scaleRange = 0.0
    emitterCell.scaleSpeed = 0.1
    
    let zeroDegreesInRadians = degreesToRadians(0.0)
    emitterCell.spin = degreesToRadians(130.0)
    emitterCell.spinRange = zeroDegreesInRadians
    emitterCell.emissionLatitude = zeroDegreesInRadians
    emitterCell.emissionLongitude = zeroDegreesInRadians
    emitterCell.emissionRange = degreesToRadians(360.0)
    
    emitterCell.lifetime = 1.0
    emitterCell.lifetimeRange = 0.0
    emitterCell.birthRate = 250.0
    emitterCell.velocity = 50.0
    emitterCell.velocityRange = 500.0
    emitterCell.xAcceleration = -750.0
    emitterCell.yAcceleration = 0.0
  }
  
  // MARK: - View life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let identifier = segue.identifier {
      switch identifier {
      case "DisplayEmitterControls":
        setUpEmitterLayer()
        setUpEmitterCell()
        resetEmitterCells()
        viewForEmitterLayer.layer.addSublayer(emitterLayer)
        let controller = segue.destinationViewController as CAEmitterLayerControlsViewController
        controller.emitterLayerViewController = self
      default:
        break
      }
    }
  }
  
  // MARK: - Triggered actions
  
  override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
    if let location = touches.anyObject()?.locationInView(viewForEmitterLayer) {
      emitterLayer.position = location
    }
  }
  
  override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
    if let location = touches.anyObject()?.locationInView(viewForEmitterLayer) {
      emitterLayer.position = location
    }
  }
  
  // MARK: - Helpers
  
  func resetEmitterCells() {
    emitterLayer.emitterCells = nil
    emitterLayer.emitterCells = [emitterCell]
  }
  
}
