//
//  CAReplicatorLayerViewController.swift
//  LayerPlayer
//
//  Created by Scott Gardner on 11/17/14.
//  Copyright (c) 2014 Scott Gardner. All rights reserved.
//

import UIKit

class CAReplicatorLayerViewController: UIViewController {
  
  @IBOutlet weak var viewForReplicatorLayer: UIView!
  @IBOutlet weak var layerSizeSlider: UISlider!
  @IBOutlet weak var layerSizeSliderValueLabel: UILabel!
  @IBOutlet weak var instanceCountSlider: UISlider!
  @IBOutlet weak var instanceCountSliderValueLabel: UILabel!
  @IBOutlet weak var instanceDelaySlider: UISlider!
  @IBOutlet weak var instanceDelaySliderValueLabel: UILabel!
  @IBOutlet weak var offsetRedSwitch: UISwitch!
  @IBOutlet weak var offsetGreenSwitch: UISwitch!
  @IBOutlet weak var offsetBlueSwitch: UISwitch!
  @IBOutlet weak var offsetAlphaSwitch: UISwitch!
  
  let lengthMultiplier: CGFloat = 3.0
  let whiteColor = UIColor.whiteColor().CGColor
  let replicatorLayer = CAReplicatorLayer()
  let instanceLayer = CALayer()
  let fadeAnimation = CABasicAnimation(keyPath: "opacity")
  
  // MARK: - Quick reference
  
  func setUpReplicatorLayer() {
    replicatorLayer.frame = viewForReplicatorLayer.bounds
    let count = instanceCountSlider.value
    replicatorLayer.instanceCount = Int(count)
    replicatorLayer.preservesDepth = false
    replicatorLayer.instanceColor = whiteColor
    replicatorLayer.instanceRedOffset = offsetValueForSwitch(offsetRedSwitch)
    replicatorLayer.instanceGreenOffset = offsetValueForSwitch(offsetGreenSwitch)
    replicatorLayer.instanceBlueOffset = offsetValueForSwitch(offsetBlueSwitch)
    replicatorLayer.instanceAlphaOffset = offsetValueForSwitch(offsetAlphaSwitch)
    let angle = Float(M_PI * 2.0) / count
    replicatorLayer.instanceTransform = CATransform3DMakeRotation(CGFloat(angle), 0.0, 0.0, 1.0)
  }
  
  func setUpInstanceLayer() {
    let layerWidth = CGFloat(layerSizeSlider.value)
    let midX = CGRectGetMidX(viewForReplicatorLayer.bounds) - layerWidth / 2.0
    instanceLayer.frame = CGRect(x: midX, y: 0.0, width: layerWidth, height: layerWidth * lengthMultiplier)
    instanceLayer.backgroundColor = whiteColor
  }
  
  func setUpLayerFadeAnimation() {
    fadeAnimation.fromValue = 1.0
    fadeAnimation.toValue = 0.0
    fadeAnimation.repeatCount = Float(Int.max)
  }
  
  // MARK: - View life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpReplicatorLayer()
    viewForReplicatorLayer.layer.addSublayer(replicatorLayer)
    setUpInstanceLayer()
    replicatorLayer.addSublayer(instanceLayer)
    setUpLayerFadeAnimation()
    instanceDelaySliderChanged(instanceDelaySlider)
    updateLayerSizeSliderValueLabel()
    updateInstanceCountSliderValueLabel()
    updateInstanceDelaySliderValueLabel()
  }
  
  // MARK: - IBActions
  
  @IBAction func layerSizeSliderChanged(sender: UISlider) {
    let value = CGFloat(sender.value)
    instanceLayer.bounds = CGRect(origin: CGPointZero, size: CGSize(width: value, height: value * lengthMultiplier))
    updateLayerSizeSliderValueLabel()
  }
  
  @IBAction func instanceCountSliderChanged(sender: UISlider) {
    replicatorLayer.instanceCount = Int(sender.value)
    replicatorLayer.instanceAlphaOffset = offsetValueForSwitch(offsetAlphaSwitch)
    updateInstanceCountSliderValueLabel()
  }
  
  @IBAction func instanceDelaySliderChanged(sender: UISlider) {
    if sender.value > 0.0 {
      replicatorLayer.instanceDelay = CFTimeInterval(sender.value / Float(replicatorLayer.instanceCount))
      setLayerFadeAnimation()
    } else {
      replicatorLayer.instanceDelay = 0.0
      instanceLayer.opacity = 1.0
      instanceLayer.removeAllAnimations()
    }
    
    updateInstanceDelaySliderValueLabel()
  }
  
  @IBAction func offsetSwitchChanged(sender: UISwitch) {
    switch sender {
    case offsetRedSwitch:
      replicatorLayer.instanceRedOffset = offsetValueForSwitch(sender)
    case offsetGreenSwitch:
      replicatorLayer.instanceGreenOffset = offsetValueForSwitch(sender)
    case offsetBlueSwitch:
      replicatorLayer.instanceBlueOffset = offsetValueForSwitch(sender)
    case offsetAlphaSwitch:
      replicatorLayer.instanceAlphaOffset = offsetValueForSwitch(sender)
    default:
      break
    }
  }
  
  // MARK: - Triggered actions
  
  func setLayerFadeAnimation() {
    instanceLayer.opacity = 0.0
    fadeAnimation.duration = CFTimeInterval(instanceDelaySlider.value)
    instanceLayer.addAnimation(fadeAnimation, forKey: "FadeAnimation")
  }
  
  // MARK: - Helpers
  
  func offsetValueForSwitch(offsetSwitch: UISwitch) -> Float {
    if offsetSwitch == offsetAlphaSwitch {
      let count = Float(replicatorLayer.instanceCount)
      return offsetSwitch.on ? -1.0 / count : 0.0
    } else {
      return offsetSwitch.on ? 0.0 : -0.05
    }
  }
  
  func updateLayerSizeSliderValueLabel() {
    let value = layerSizeSlider.value
    layerSizeSliderValueLabel.text = String(format: "%.0f x %.0f", value, value * Float(lengthMultiplier))
  }
  
  func updateInstanceCountSliderValueLabel() {
    instanceCountSliderValueLabel.text = String(format: "%.0f", instanceCountSlider.value)
  }
  
  func updateInstanceDelaySliderValueLabel() {
    instanceDelaySliderValueLabel.text = String(format: "%.0f", instanceDelaySlider.value)
  }
  
}
