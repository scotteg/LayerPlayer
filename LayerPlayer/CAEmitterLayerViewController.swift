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
  
  var emitterLayer = CAEmitterLayer()
  var emitterCell = CAEmitterCell()
  
  // MARK: - Quick reference
  
  func setUpEmitterLayer() {
    emitterLayer.frame = viewForEmitterLayer.bounds
    emitterLayer.seed = UInt32(Date().timeIntervalSince1970)
    emitterLayer.emitterPosition = CGPoint(x: viewForEmitterLayer.bounds.midX * 1.5, y: viewForEmitterLayer.bounds.midY)
  }
  
  func setUpEmitterCell() {
    emitterCell.isEnabled = true
    emitterCell.contents = UIImage(named: "smallStar")?.cgImage
    emitterCell.contentsRect = CGRect(origin: CGPoint.zero, size: CGSize(width: 1, height: 1))
    emitterCell.color = UIColor(hue: 0.0, saturation: 0.0, brightness: 0.0, alpha: 1.0).cgColor
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
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setUpEmitterCell()
    resetEmitterCells()
    setUpEmitterLayer()
    viewForEmitterLayer.layer.addSublayer(emitterLayer)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
      case "DisplayEmitterControls":
        emitterLayer.renderMode = kCAEmitterLayerAdditive
        (segue.destination as? CAEmitterLayerControlsViewController)?.emitterLayerViewController = self
      default:
        break
      }
    }
  }
  
  // MARK: - Triggered actions
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let location = touches.first?.location(in: viewForEmitterLayer) {
      emitterLayer.emitterPosition = location
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let location = touches.first?.location(in: viewForEmitterLayer) {
      emitterLayer.emitterPosition = location
    }
  }
  
  // MARK: - Helpers
  
  func resetEmitterCells() {
    emitterLayer.emitterCells = nil
    emitterLayer.emitterCells = [emitterCell]
  }
  
}
